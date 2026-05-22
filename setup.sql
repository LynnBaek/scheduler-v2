-- ============================================================
-- scheduler-v2 Supabase 테이블 설정
-- Supabase > SQL Editor 에서 실행하세요
-- ============================================================

-- 일별 목표/실적 기록
create table if not exists goal_records (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date text not null,
  group_name text not null,
  category text not null,
  is_important boolean default false,
  target text,
  actual text,
  created_at timestamptz default now(),
  unique(user_id, date, category)
);
alter table goal_records enable row level security;
create policy "Users own goal_records" on goal_records for all using (auth.uid() = user_id);

-- 월간 Key Results
create table if not exists key_results (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  month text not null,          -- YYYY-MM
  name text not null,
  unit text default '',
  target_value numeric default 0,
  actual_value numeric default 0,
  sort_order int default 0,
  created_at timestamptz default now()
);
alter table key_results enable row level security;
create policy "Users own key_results" on key_results for all using (auth.uid() = user_id);

-- 시간가계부 기록
create table if not exists time_records (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date text not null,
  main_cat text not null,
  sub_cat text not null,
  target_min int default 0,
  actual_min int default 0,
  created_at timestamptz default now(),
  unique(user_id, date, main_cat, sub_cat)
);
alter table time_records enable row level security;
create policy "Users own time_records" on time_records for all using (auth.uid() = user_id);

-- gratitudes 테이블은 기존 scheduler 프로젝트와 공유합니다.
-- 이미 존재한다면 아래는 실행하지 마세요.
create table if not exists gratitudes (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date text not null,
  text text not null,
  created_at timestamptz default now()
);
alter table gratitudes enable row level security;
create policy "Users own gratitudes" on gratitudes for all using (auth.uid() = user_id);
