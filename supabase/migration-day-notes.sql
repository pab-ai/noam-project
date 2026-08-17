create table if not exists public.day_notes (
  user_id uuid not null references auth.users(id) on delete cascade,
  note_date date not null,
  note text not null default '',
  updated_at timestamptz not null default now(),
  primary key (user_id, note_date)
);

alter table public.day_notes enable row level security;

drop policy if exists "Families read own notes" on public.day_notes;
drop policy if exists "Families add own notes" on public.day_notes;
drop policy if exists "Families update own notes" on public.day_notes;
drop policy if exists "Families delete own notes" on public.day_notes;

create policy "Families read own notes" on public.day_notes for select using (auth.uid()=user_id);
create policy "Families add own notes" on public.day_notes for insert with check (auth.uid()=user_id);
create policy "Families update own notes" on public.day_notes for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "Families delete own notes" on public.day_notes for delete using (auth.uid()=user_id);
