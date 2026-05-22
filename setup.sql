-- ============================================================
-- scheduler-v2 · 신규 테이블 설정
-- Supabase > SQL Editor 에서 실행하세요
-- ============================================================

-- ① 월간 뷰 할일
create table if not exists daily_todos (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  text text not null,
  done boolean default false,
  sort_order int default 0,
  created_at timestamptz default now()
);
alter table daily_todos enable row level security;
create policy "Users own daily_todos" on daily_todos
  for all using (auth.uid() = user_id);

-- ② 주간 뷰 항목 템플릿 (TODO / 습관)
create table if not exists week_items (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  category text not null check (category in ('todo','habit')),
  name text not null,
  sort_order int default 0
);
alter table week_items enable row level security;
create policy "Users own week_items" on week_items
  for all using (auth.uid() = user_id);

-- ③ 주간 항목 일별 완료 기록
create table if not exists week_item_records (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  item_id uuid references week_items(id) on delete cascade not null,
  done boolean default false,
  unique(user_id, date, item_id)
);
alter table week_item_records enable row level security;
create policy "Users own week_item_records" on week_item_records
  for all using (auth.uid() = user_id);

-- ④ 타임 테이블 블록 (시간대별 색상/라벨)
create table if not exists timetable_blocks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  hour int not null check (hour >= 0 and hour <= 23),
  label text,
  color text,
  unique(user_id, date, hour)
);
alter table timetable_blocks enable row level security;
create policy "Users own timetable_blocks" on timetable_blocks
  for all using (auth.uid() = user_id);

-- ⑤ 일간 일기
create table if not exists diary_entries (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  content text,
  unique(user_id, date)
);
alter table diary_entries enable row level security;
create policy "Users own diary_entries" on diary_entries
  for all using (auth.uid() = user_id);
