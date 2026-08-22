# CampusOS — Supabase Cloud Database Integration Guide

CampusOS is now fully integrated with **Supabase** for live cloud persistence, real-time multi-device sync, and automatic offline caching.

---

## 🚀 Quick Setup (3 Minutes)

### Step 1: Create a Free Supabase Project
1. Go to [https://supabase.com](https://supabase.com) and log in or create a free account.
2. Click **"New Project"**, choose an organization, give it a name (e.g., `CampusOS`), and set a database password.
3. Wait ~1 minute for Supabase to finish provisioning.

### Step 2: Run the SQL Schema
1. In your Supabase project dashboard, click **"SQL Editor"** on the left navigation bar.
2. Click **"New query"**.
3. Open the [`supabase_schema.sql`](./supabase_schema.sql) file from this repository, copy its entire contents, paste it into the query editor, and click **"Run"** (or press `Ctrl + Enter`).
4. You will see a success message: `CampusOS database schema created successfully with Realtime and RLS policies!`.

### Step 3: Connect CampusOS to Supabase
1. In Supabase, go to **Project Settings** (gear icon) > **API**.
2. Copy two values:
   - **Project URL** (e.g., `https://xyzcompany.supabase.co`)
   - **anon / public key** (the long string under `Project API keys`)
3. Open `index.html` in your browser.
4. Click the **☁️ Supabase** button on the top-right (or in the login banner) to open the **Supabase Cloud Sync Settings** modal.
5. Paste your **Project URL** and **Anon Key**, then click **"Save & Connect"**.

✨ **That's it!** The badge will turn **🟢 Supabase Connected (Live Cloud Sync)**.

---

## ⚡ What Gets Automatically Saved to Supabase?

Every single operation across all roles is automatically synchronized with Supabase in real time:

- **Attendance**:
  - Faculty marking attendance (Present / Absent) updates in the cloud immediately.
  - Student simulated future attendance choices (*Attending*, *Not attending*, *Ignored*) and projected percentages persist across reloads.
- **Marks & CGPA**:
  - Faculty uploading / updating internal (30) or external (70) marks.
  - Real-time grade and CGPA re-computation saved to the cloud.
- **Fees & Facilities**:
  - Student semester fee payments.
  - Optional campus facility subscriptions (Gym, Swimming Pool, Tennis, Badminton, Squash, Rock Climbing).
  - Itemized transaction receipts with timestamp, receipt numbers, and transaction IDs.
- **Placement Cell**:
  - Student job drive applications and registered status.
- **Complaints & Grievances**:
  - Raising complaints with category, description, and submitter info.
  - Admin resolving complaints with resolution timestamp.
- **Emergency Safety & SOS**:
  - Immediate SOS triggers with live GPS coordinates.
  - Admin emergency resolution.
  - Anonymous and named incident reports.
- **Visitor Management**:
  - Student / Employee visitor registration.
  - Admin 1-click Approval / Rejection.
- **Parent Communication**:
  - Messages sent to parents by faculty or admin.
  - Transparent message logs on the student dashboard.
- **Academic Updates**:
  - New campus-wide announcements posted by Admin or Faculty.
  - Mid-sem and End-sem exam scheduling.
- **Theme & Preferences**:
  - Dark Mode / Light Mode state.

---

## 🔄 Real-time Multi-Device Sync

CampusOS uses **Supabase Realtime channels**. When an Admin marks a complaint resolved or an SOS alert is triggered from one device, every other connected device or open browser tab updates instantly without refreshing.

---

## 🛡️ Offline-First & Fallback Architecture

If there is ever a network interruption:
1. All changes are queued and saved to local persistent storage.
2. Once the network reconnects or Supabase is available, the sync resumes seamlessly.
3. You never lose your data.
