create table if not exists public.medicine_check_ins (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  check_in_date date not null,
  moment text not null check (moment in ('morning', 'evening')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, check_in_date, moment)
);

alter table public.medicine_check_ins enable row level security;
drop policy if exists "Families read own medicine" on public.medicine_check_ins;
drop policy if exists "Families add own medicine" on public.medicine_check_ins;
drop policy if exists "Families update own medicine" on public.medicine_check_ins;
drop policy if exists "Families delete own medicine" on public.medicine_check_ins;
create policy "Families read own medicine" on public.medicine_check_ins for select using (auth.uid()=user_id);
create policy "Families add own medicine" on public.medicine_check_ins for insert with check (auth.uid()=user_id);
create policy "Families update own medicine" on public.medicine_check_ins for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "Families delete own medicine" on public.medicine_check_ins for delete using (auth.uid()=user_id);

create table if not exists public.water_days (
  user_id uuid not null references auth.users(id) on delete cascade,
  check_in_date date not null,
  bottle_count integer not null default 0 check (bottle_count >= 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, check_in_date)
);

alter table public.water_days enable row level security;
drop policy if exists "Families read own water" on public.water_days;
drop policy if exists "Families add own water" on public.water_days;
drop policy if exists "Families update own water" on public.water_days;
drop policy if exists "Families delete own water" on public.water_days;
create policy "Families read own water" on public.water_days for select using (auth.uid()=user_id);
create policy "Families add own water" on public.water_days for insert with check (auth.uid()=user_id);
create policy "Families update own water" on public.water_days for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "Families delete own water" on public.water_days for delete using (auth.uid()=user_id);
