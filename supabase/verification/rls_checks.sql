-- NEXORA TECH database security checks (TC-014, TC-020, TC-027, TC-028).
--
-- Run in the Supabase SQL editor AFTER both migrations. Every row in the
-- result must say PASS. The script inserts a few clearly marked test rows and
-- deletes them again. It never touches real enquiries.
--
-- NOT YET RUN. If a row says FAIL, do not enable public enquiries; send the
-- result to the developer.

drop table if exists pg_temp.rls_check_results;
create temp table rls_check_results (
  test text,
  expected text,
  actual text,
  result text
);
grant all on rls_check_results to anon, authenticated;

do $$
declare
  affected integer;
  seen integer;
  valid_row jsonb := '{}'::jsonb;
begin
  -- 1. Visitors (anon) cannot read enquiries
  execute 'set local role anon';
  begin
    perform 1 from public.enquiries limit 1;
    insert into rls_check_results values
      ('Visitor cannot read enquiries', 'permission denied', 'read allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot read enquiries', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  -- 2. Visitors can submit a valid enquiry
  begin
    insert into public.enquiries
      (name, email, service_interest, message, consent_given)
    values
      ('RLS TEST', 'rls-test-1@example.invalid', 'other',
       'Automated security check message.', true);
    insert into rls_check_results values
      ('Visitor can submit a valid enquiry', 'insert allowed', 'insert allowed', 'PASS');
  exception when others then
    insert into rls_check_results values
      ('Visitor can submit a valid enquiry', 'insert allowed', sqlstate, 'FAIL');
  end;

  -- 3. Visitors cannot submit without consent
  begin
    insert into public.enquiries
      (name, email, service_interest, message, consent_given)
    values
      ('RLS TEST', 'rls-test-2@example.invalid', 'other',
       'Automated security check message.', false);
    insert into rls_check_results values
      ('Visitor cannot submit without consent', 'rejected', 'accepted', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot submit without consent', 'rejected', sqlstate,
       case when sqlstate in ('42501', '23514') then 'PASS' else 'FAIL' end);
  end;

  -- 4. Visitors cannot set system columns such as status
  begin
    insert into public.enquiries
      (name, email, service_interest, message, consent_given, status)
    values
      ('RLS TEST', 'rls-test-3@example.invalid', 'other',
       'Automated security check message.', true, 'closed');
    insert into rls_check_results values
      ('Visitor cannot set status', 'permission denied', 'accepted', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot set status', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  -- 5. Visitors cannot update or delete
  begin
    update public.enquiries set status = 'closed';
    insert into rls_check_results values
      ('Visitor cannot update enquiries', 'permission denied', 'allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot update enquiries', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  begin
    delete from public.enquiries;
    insert into rls_check_results values
      ('Visitor cannot delete enquiries', 'permission denied', 'allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot delete enquiries', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  -- 6. Visitors cannot read profiles, the audit log, or call is_admin()
  begin
    perform 1 from public.profiles limit 1;
    insert into rls_check_results values
      ('Visitor cannot read profiles', 'permission denied', 'allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot read profiles', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  begin
    perform 1 from public.audit_log limit 1;
    insert into rls_check_results values
      ('Visitor cannot read the audit log', 'permission denied', 'allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot read the audit log', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  begin
    perform public.is_admin();
    insert into rls_check_results values
      ('Visitor cannot call is_admin()', 'permission denied', 'allowed', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Visitor cannot call is_admin()', 'permission denied', sqlstate,
       case when sqlstate = '42501' then 'PASS' else 'FAIL' end);
  end;

  -- 7. Rate limit: the 4th enquiry from one email within an hour is rejected
  begin
    for i in 1..4 loop
      insert into public.enquiries
        (name, email, service_interest, message, consent_given)
      values
        ('RLS TEST', 'rls-test-rate@example.invalid', 'other',
         'Automated security check message.', true);
    end loop;
    insert into rls_check_results values
      ('Rate limit rejects a 4th enquiry per email', 'rate_limit_email', 'accepted', 'FAIL');
  exception when others then
    insert into rls_check_results values
      ('Rate limit rejects a 4th enquiry per email', 'rate_limit_email', sqlerrm,
       case when sqlerrm = 'rate_limit_email' then 'PASS' else 'FAIL' end);
  end;
  execute 'reset role';

  -- 8. A signed-in user who is NOT an administrator sees and changes nothing
  execute 'set local role authenticated';
  perform set_config(
    'request.jwt.claims',
    '{"sub":"00000000-0000-0000-0000-00000000dead","role":"authenticated"}',
    true
  );

  select count(*) into seen from public.enquiries;
  insert into rls_check_results values
    ('Non-admin user sees no enquiries', '0 rows', seen::text || ' rows',
     case when seen = 0 then 'PASS' else 'FAIL' end);

  update public.enquiries set status = 'closed';
  get diagnostics affected = row_count;
  insert into rls_check_results values
    ('Non-admin user changes no enquiries', '0 rows', affected::text || ' rows',
     case when affected = 0 then 'PASS' else 'FAIL' end);

  select count(*) into seen from public.profiles;
  insert into rls_check_results values
    ('Non-admin user sees no profiles', '0 rows', seen::text || ' rows',
     case when seen = 0 then 'PASS' else 'FAIL' end);

  select count(*) into seen from public.audit_log;
  insert into rls_check_results values
    ('Non-admin user sees no audit log', '0 rows', seen::text || ' rows',
     case when seen = 0 then 'PASS' else 'FAIL' end);

  execute 'reset role';
  perform set_config('request.jwt.claims', '', true);

  -- Clean up the test rows (runs as the database owner)
  delete from public.enquiries where email like 'rls-test-%@example.invalid';
end;
$$;

select test, expected, actual, result
from rls_check_results
order by case result when 'FAIL' then 0 else 1 end, test;
