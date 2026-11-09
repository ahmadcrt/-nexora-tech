-- NEXORA TECH security hardening (NT-DOC-07, NT-DOC-09).
-- Run AFTER 20261107000000_initial_schema.sql.
--
-- DRAFT, NOT YET RUN. Written without access to a PostgreSQL server.
-- After applying it, run supabase/verification/rls_checks.sql and confirm
-- every row says PASS before enabling public enquiries.

-- 1. Administrators may change only the handling fields, never the data a
--    visitor submitted.
revoke update on public.enquiries from authenticated;
grant update (status, internal_notes, assigned_to)
  on public.enquiries to authenticated;

-- 2. Platform default privileges can grant EXECUTE to anon; remove it.
revoke execute on function public.is_admin() from anon;

-- 3. Audit log of administrator actions (FR-029) ---------------------------

create table public.audit_log (
  id bigint generated always as identity primary key,
  actor_id uuid references public.profiles (id) on delete set null,
  action text not null,
  entity text not null,
  entity_id uuid,
  details jsonb,
  created_at timestamptz not null default now()
);

create index audit_log_created_at_idx on public.audit_log (created_at desc);

alter table public.audit_log enable row level security;

revoke all on public.audit_log from anon, authenticated;
grant select on public.audit_log to authenticated;

create policy "admins read audit log"
  on public.audit_log for select to authenticated
  using (public.is_admin());

-- Records who changed or deleted an enquiry. Contains identifiers and field
-- names only, never personal data. Changes made outside the application
-- (SQL editor, service role) have no signed-in user and are not recorded.
create function public.audit_enquiry_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  changed text[] := '{}';
begin
  if auth.uid() is null then
    return null;
  end if;

  if tg_op = 'DELETE' then
    insert into public.audit_log (actor_id, action, entity, entity_id)
    values (auth.uid(), 'enquiry_deleted', 'enquiries', old.id);
    return null;
  end if;

  if new.status is distinct from old.status then
    changed := changed || 'status';
  end if;
  if new.internal_notes is distinct from old.internal_notes then
    changed := changed || 'internal_notes';
  end if;
  if new.assigned_to is distinct from old.assigned_to then
    changed := changed || 'assigned_to';
  end if;

  if array_length(changed, 1) is not null then
    insert into public.audit_log (actor_id, action, entity, entity_id, details)
    values (
      auth.uid(),
      'enquiry_updated',
      'enquiries',
      new.id,
      jsonb_build_object(
        'changed_fields', to_jsonb(changed),
        'old_status', old.status::text,
        'new_status', new.status::text
      )
    );
  end if;
  return null;
end;
$$;

revoke all on function public.audit_enquiry_change() from public, anon, authenticated;

create trigger enquiries_audit
  after update or delete on public.enquiries
  for each row execute function public.audit_enquiry_change();

-- 4. Basic abuse limits on public submissions (R-012, TBD-025) -------------
-- Limits are proposals: at most 3 enquiries per email address per hour and
-- 60 in total per hour. The total limit stops a flood from filling the
-- database but can also block genuine visitors during an attack; adjust or
-- replace it with a CAPTCHA or Edge Function if that happens.

create index enquiries_email_created_idx
  on public.enquiries (lower(email), created_at desc);

create function public.enquiries_rate_limit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  recent_same_email integer;
  recent_total integer;
begin
  select count(*) into recent_same_email
  from public.enquiries
  where lower(email) = lower(new.email)
    and created_at > now() - interval '1 hour';

  if recent_same_email >= 3 then
    raise exception 'rate_limit_email' using errcode = 'P0001';
  end if;

  select count(*) into recent_total
  from public.enquiries
  where created_at > now() - interval '1 hour';

  if recent_total >= 60 then
    raise exception 'rate_limit_total' using errcode = 'P0001';
  end if;

  return new;
end;
$$;

revoke all on function public.enquiries_rate_limit() from public, anon, authenticated;

create trigger enquiries_rate_limit
  before insert on public.enquiries
  for each row execute function public.enquiries_rate_limit();
