# Noam’s Little Wins

A private, mobile-first toilet-routine tracker for Noam and family. It works as an installable PWA, keeps working offline, and uses gentle, shame-free language throughout.

## What is included

- Three large daily toilet-time cards
- Two meal-linked medicine routine check-ins for “2 Macrogol packets with water.”
- A visual 350 mL bottle counter with a parent-configurable display target
- Optional feeling/outcome and abstract size choices
- Stars, a growing garden collection, and a gentle October path
- Monthly check-in calendar
- Persisted family sign-in before anyone can record a check-in
- PIN-gated family summary and detailed history
- Downloadable JSON family backup
- Offline local demo mode
- Optional Supabase family sign-in and sync with row-level security

## Run locally

Requires Node.js 22 or newer.

```bash
npm install
cp .env.example .env.local
npm run dev
```

The Supabase variables are optional during local development. Without them, the local app runs in demo mode. A production build without them shows a locked setup screen and cannot record check-ins.

## Connect Supabase securely

1. Open the Supabase SQL Editor and run [`supabase/schema.sql`](supabase/schema.sql). This creates only the check-in table and family-only row-level access policies.
   For an existing installation, also run [`supabase/migration-medicine-water.sql`](supabase/migration-medicine-water.sql) to add family-only medicine and water tracking.
2. In Supabase Authentication, create or invite the parent user. Do not create an account on the child’s behalf.
3. Copy `.env.example` to `.env.local` and enter the project URL and **anon/public** key. Never use the service-role key in this app.
4. Restart the local app. In **Grown-ups**, make a PIN, then sign in with the parent account to sync.

The Supabase client persists the parent session on the family phone. After a grown-up signs in once, Noam’s daily check-in screen needs no repeated sign-in. Unknown visitors cannot reach the check-in controls. The local PIN separately gates detailed history; Supabase authentication and row-level security protect cloud data. The PIN is hashed before being stored locally. The code keeps the PIN gate separate so device biometrics can replace or complement it later.

## GitHub Pages setup

The app is preconfigured for `https://pab-ai.github.io/noam-project/`. The included workflow builds on `main`, but nothing has been pushed or deployed.

Before enabling the workflow:

1. Add repository Actions secrets named `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
2. In repository **Settings → Pages**, choose **GitHub Actions** as the source.
3. Review the workflow, then run it manually or push to `main` when ready.

The anon key is designed to be public; security comes from authenticated parent sessions and the row-level policies. Routine data is sent only to Supabase and is never written to GitHub.

## Backups and offline behavior

Tap **Grown-ups → Export family data** to download a dated JSON backup. Check-ins save locally first, so they work offline. When credentials and a signed-in parent session are available, the app retries sync when the device reconnects.

## Useful commands

```bash
npm run build
npm run preview
```

The production output is written to `dist/`.
