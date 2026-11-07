-- NEXORA TECH initial schema (NT-DOC-07, Phase 1: profiles and enquiries).
--
-- DRAFT, NOT YET RUN. This file was written without access to a PostgreSQL
-- server or the Supabase CLI. Review it, apply it to a local Supabase
-- instance, and test the access rules (TC-014, TC-020, TC-027, TC-028)
-- before using it anywhere else.
--
-- Not included yet: audit_log (FR-029) and Phase 2 tables.
-- The first administrator is created by the project owner, in the Supabase
-- dashboard or SQL editor, by inserting a row into public.profiles for an
-- existing auth user. Never commit user identifiers or credentials.

create type public.user_role as enum ('admin');
create type public.enquiry_status as enum ('new', 'in_progress', 'closed');
create type public.service_interest as enum (
  'website_development',
  'software_development',
  'ui_ux_design',
  'graphic_design',
  'digital_solutions',
  'other'
);

-- Profiles ---------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text check (display_name is null or char_length(display_name) <= 100),
  role public.user_role not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Security definer avoids recursive policy evaluation on public.profiles.
create function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;

create policy "users read own profile"
  on public.profiles for select to authenticated
  using (id = auth.uid());

create policy "admins read all profiles"
  on public.profiles for select to authenticated
  using (public.is_admin());

-- Enquiries --------------------------------------------------------------

create table public.enquiries (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 2 and 100),
  email text not null check (
    char_length(email) <= 254
    and email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'
  ),
  phone text check (
    phone is null
    or (char_length(phone) <= 30 and phone ~ '^[0-9+[:space:]-]+$')
  ),
  service_interest public.service_interest not null,
  message text not null check (char_length(btrim(message)) between 10 and 2000),
  consent_given boolean not null check (consent_given),
  consent_at timestamptz not null default now(),
  privacy_notice_version text,
  status public.enquiry_status not null default 'new',
  internal_notes text check (internal_notes is null or char_length(internal_notes) <= 5000),
  assigned_to uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index enquiries_created_at_idx on public.enquiries (created_at desc);
create index enquiries_status_created_at_idx on public.enquiries (status, created_at desc);
create index enquiries_email_idx on public.enquiries (email);

create function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger enquiries_set_updated_at
  before update on public.enquiries
  for each row execute function public.set_updated_at();

alter table public.enquiries enable row level security;

-- Default deny, then grant only what is needed (R-008).
revoke all on public.enquiries from anon, authenticated;

-- Visitors may insert the visitor-supplied columns only; system columns
-- (status, notes, assignee, timestamps) cannot be set by clients.
grant insert (name, email, phone, service_interest, message, consent_given)
  on public.enquiries to anon, authenticated;

grant select, update, delete on public.enquiries to authenticated;

create policy "visitors submit enquiries"
  on public.enquiries for insert to anon, authenticated
  with check (consent_given);

create policy "admins read enquiries"
  on public.enquiries for select to authenticated
  using (public.is_admin());

create policy "admins update enquiries"
  on public.enquiries for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy "admins delete enquiries"
  on public.enquiries for delete to authenticated
  using (public.is_admin());
