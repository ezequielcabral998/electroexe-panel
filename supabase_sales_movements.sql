-- Electroexe: tablas para ventas e historial de movimientos
create table if not exists public.sales (
  id text primary key,
  date date not null,
  product_id text,
  product_name text not null default '',
  qty integer not null default 0,
  unit_price numeric not null default 0,
  total numeric not null default 0,
  profit numeric not null default 0,
  channel text not null default '',
  payment text not null default '',
  note text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.stock_movements (
  id text primary key,
  date date not null,
  type text not null default '',
  product_id text,
  product_name text not null default '',
  qty integer not null default 0,
  stock_after integer not null default 0,
  sale_id text,
  channel text not null default '',
  created_at timestamptz not null default now()
);

alter table public.sales enable row level security;
alter table public.stock_movements enable row level security;

drop policy if exists "authenticated sales access" on public.sales;
create policy "authenticated sales access" on public.sales
for all to authenticated using (true) with check (true);

drop policy if exists "authenticated stock movements access" on public.stock_movements;
create policy "authenticated stock movements access" on public.stock_movements
for all to authenticated using (true) with check (true);

create index if not exists sales_date_idx on public.sales(date);
create index if not exists sales_product_idx on public.sales(product_id);
create index if not exists stock_movements_date_idx on public.stock_movements(date);
create index if not exists stock_movements_product_idx on public.stock_movements(product_id);
