create table if not exists public.check_ins (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  check_in_date date not null,
  routine text not null check (routine in ('breakfast','lunch','dinner')),
  outcome text check (outcome is null or outcome in ('happy','neutral','not-yet')),
  size text check (size is null or size in ('little','medium','big')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists check_ins_user_date_idx on public.check_ins(user_id,check_in_date);
alter table public.check_ins enable row level security;
create policy "Families read own check-ins" on public.check_ins for select using (auth.uid()=user_id);
create policy "Families add own check-ins" on public.check_ins for insert with check (auth.uid()=user_id);
create policy "Families update own check-ins" on public.check_ins for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "Families delete own check-ins" on public.check_ins for delete using (auth.uid()=user_id);

create table if not exists public.day_notes (
  user_id uuid not null references auth.users(id) on delete cascade,
  note_date date not null,
  note text not null default '',
  updated_at timestamptz not null default now(),
  primary key (user_id, note_date)
);
alter table public.day_notes enable row level security;
create policy "Families read own notes" on public.day_notes for select using (auth.uid()=user_id);
create policy "Families add own notes" on public.day_notes for insert with check (auth.uid()=user_id);
create policy "Families update own notes" on public.day_notes for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "Families delete own notes" on public.day_notes for delete using (auth.uid()=user_id);
