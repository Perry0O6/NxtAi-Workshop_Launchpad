drop table if exists registrations cascade;

create table registrations(
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 80),
  email text not null unique check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  college text not null check (char_length(college) between 2 and 100),
  branch text, code text not null unique, ref text,
  created_at timestamptz default now());
alter table registrations enable row level security;

create or replace function register(p_name text,p_email text,p_college text,p_branch text,p_ref text)
returns text language plpgsql security definer set search_path=public as $$
declare c text; e text := lower(trim(p_email));
begin
  select code into c from registrations where email=e;
  if c is not null then return c; end if;
  loop c := upper(substr(md5(random()::text||clock_timestamp()::text),1,6));
    exit when not exists(select 1 from registrations where code=c); end loop;
  insert into registrations(name,email,college,branch,code,ref)
  values(trim(p_name),e,trim(p_college),p_branch,c,nullif(upper(trim(p_ref)),''));
  return c;
end $$;

create or replace function reg_count() returns int language sql security definer set search_path=public as
$$ select count(*)::int from registrations $$;

create or replace function leaderboard() returns table(name text,college text,referrals int)
language sql security definer set search_path=public as
$$ select r.name,r.college,count(x.id)::int from registrations r join registrations x on x.ref=r.code
   group by r.id order by 3 desc limit 10 $$;

create or replace function my_referrals(p_code text) returns int language sql security definer set search_path=public as
$$ select count(*)::int from registrations where ref=upper(p_code) $$;

grant execute on function register,reg_count,leaderboard,my_referrals to anon;