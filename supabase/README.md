# Supabase setup for NEXORA TECH

Everything here is safe to publish: it contains no keys, passwords or project identifiers. Never put secrets in this repository.

## What the database does

| Table | Purpose |
|---|---|
| `profiles` | Which signed-in users are administrators (`role = admin`) |
| `enquiries` | Enquiries sent from the website contact form |
| `audit_log` | Who changed or deleted an enquiry (identifiers only) |

Row Level Security is on for every table. Visitors can only **add** an enquiry. Only an administrator can read, change or delete enquiries. Visitors cannot set the status, notes or assignee.

## One-time setup (about 20 minutes)

### 1. Supabase project
Use the Supabase project you approved for NEXORA TECH. If none exists yet, create one at supabase.com and pick a region close to your users (this affects where personal data is stored; see TBD-007 and TBD-009).

### 2. Run the two migrations, in this order
Open the project, then **SQL Editor**, then **New query**. Paste the whole file, tap **Run**, and wait for "Success".
1. `supabase/migrations/20261107000000_initial_schema.sql`
2. `supabase/migrations/20261108000000_enquiry_security_hardening.sql`

If either shows an error, stop and send the error text to the developer. Do not continue.

### 3. Lock down sign-ups
Open **Authentication**, then **Sign In / Providers** (or **Settings**). Turn **off** "Allow new users to sign up". Only you will create administrator accounts.

### 4. Create the administrator account
Open **Authentication**, then **Users**, then **Add user**, then **Create new user**. Enter your email and a long, unique password (at least 14 characters, stored in a password manager). Tick "Auto Confirm User".

### 5. Give that account the admin role
In **SQL Editor**, run this, replacing the email with the one you just created:

```sql
insert into public.profiles (id, display_name, role)
select id, 'Administrator', 'admin'
from auth.users
where email = 'REPLACE-WITH-YOUR-ADMIN-EMAIL';
```
It should say "1 row affected". If it says 0 rows, the email is wrong.

### 6. Set the site address
Open **Authentication**, then **URL Configuration**. Set **Site URL** to `https://ahmadcrt.github.io/-nexora-tech/`.

### 7. Verify the security
In **SQL Editor**, paste and run `supabase/verification/rls_checks.sql`. Every row of the result must say **PASS**. If any row says FAIL, do not enable public enquiries.

### 8. Add the website settings to GitHub
In the GitHub repository, open **Settings**, then **Secrets and variables**, then **Actions**.
1. Under **Secrets**, tap **New repository secret** and add:
   - `SUPABASE_URL`: the Project URL (Supabase **Project Settings**, **API**).
   - `SUPABASE_ANON_KEY`: the key labelled **anon** / **public** or **publishable**.
2. **Never** copy the `service_role` key or any key labelled "secret". The build stops if it detects one.

### 9. Rebuild, then test the administrator
Run the **CI and Deploy to GitHub Pages** workflow. Then open `https://ahmadcrt.github.io/-nexora-tech/admin`, sign in, and check the empty enquiry list loads. Public enquiries are still **off**.

### 10. Turn public enquiries on (only after step 7 passed)
In GitHub: **Settings**, **Secrets and variables**, **Actions**, **Variables** tab, **New repository variable**: name `ENQUIRIES_ENABLED`, value `true`. Run the workflow again. To switch enquiries off, delete the variable or set it to `false` and run the workflow again.

## Still to do before a full public launch
- Privacy notice and terms wording, reviewed by a qualified adviser (TBD-009).
- Second-factor sign-in for the administrator (Supabase supports it; the app screen is not built yet).
- Email or other notification for new enquiries (TBD-014).
- A CAPTCHA or server-side limit if abuse appears (TBD-025).
- Backup and restore plan (TBD-024).
