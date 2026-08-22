-- ==============================================================================
-- CampusOS — Supabase Database Schema & Setup Script
-- ==============================================================================
-- Instructions:
-- 1. Open your Supabase Project dashboard (https://supabase.com/dashboard)
-- 2. Go to "SQL Editor" on the left sidebar
-- 3. Click "New query", paste this entire script, and click "Run" (or Ctrl+Enter)
-- 4. Copy your Project URL & Anon Key from Project Settings > API and paste them
--    into CampusOS (either via the in-app Supabase Setup modal or in index.html).
-- ==============================================================================

-- 1. Create the primary key-value and collections store for CampusOS
CREATE TABLE IF NOT EXISTS public.campusos_store (
    id TEXT PRIMARY KEY,
    data JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Comment on table
COMMENT ON TABLE public.campusos_store IS 'Primary store for CampusOS state, students, teachers, complaints, alerts, and settings.';

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.campusos_store ENABLE ROW LEVEL SECURITY;

-- 3. Create RLS Policies allowing full read, insert, update, and delete access for anonymous/authenticated clients
DROP POLICY IF EXISTS "Allow public read access on campusos_store" ON public.campusos_store;
CREATE POLICY "Allow public read access on campusos_store"
    ON public.campusos_store FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Allow public insert access on campusos_store" ON public.campusos_store;
CREATE POLICY "Allow public insert access on campusos_store"
    ON public.campusos_store FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public update access on campusos_store" ON public.campusos_store;
CREATE POLICY "Allow public update access on campusos_store"
    ON public.campusos_store FOR UPDATE
    TO anon, authenticated
    USING (true)
    WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public delete access on campusos_store" ON public.campusos_store;
CREATE POLICY "Allow public delete access on campusos_store"
    ON public.campusos_store FOR DELETE
    TO anon, authenticated
    USING (true);

-- 4. Enable Supabase Realtime so changes sync live across multiple tabs and devices
ALTER PUBLICATION supabase_realtime ADD TABLE public.campusos_store;

-- 5. Helper function and trigger to automatically update `updated_at` on every change
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_campusos_store_updated_at ON public.campusos_store;
CREATE TRIGGER set_campusos_store_updated_at
    BEFORE UPDATE ON public.campusos_store
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- 6. (Optional) Dedicated relational tables for viewing & querying specific entities via SQL
CREATE TABLE IF NOT EXISTS public.students (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    dept TEXT,
    sem INT,
    section TEXT,
    cgpa NUMERIC,
    fees_total NUMERIC,
    fees_paid NUMERIC,
    data JSONB,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all on students" ON public.students FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.complaints (
    id TEXT PRIMARY KEY,
    from_user TEXT NOT NULL,
    role TEXT,
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    status TEXT DEFAULT 'Open',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.complaints ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all on complaints" ON public.complaints FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.emergency_alerts (
    id TEXT PRIMARY KEY,
    user_name TEXT NOT NULL,
    role TEXT,
    location TEXT,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.emergency_alerts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all on emergency_alerts" ON public.emergency_alerts FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.announcements (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author TEXT,
    date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all on announcements" ON public.announcements FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- Success message
SELECT 'CampusOS database schema created successfully with Realtime and RLS policies!' AS status;
