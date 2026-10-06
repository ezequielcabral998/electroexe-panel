-- Electroexe: Productos + Stock
-- Ejecutar una sola vez en Supabase > SQL Editor.

create table if not exists public.products (
  id text primary key,
  name text not null,
  cost numeric not null default 0,
  price numeric not null default 0,
  stock integer not null default 0,
  brand text default '',
  description text default '',
  category text default '',
  published boolean not null default true,
  featured boolean not null default false,
  image text default '',
  local_image text default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.stock_movements (
  id text primary key,
  product_id text not null references public.products(id) on delete cascade,
  product_name text default '',
  type text not null,
  qty integer not null,
  stock_after integer not null,
  note text default '',
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.stock_movements enable row level security;

revoke all on table public.products from anon;
revoke all on table public.stock_movements from anon;

grant select, insert, update, delete on table public.products to authenticated;
grant select, insert, update, delete on table public.stock_movements to authenticated;

drop policy if exists "admin users can manage products" on public.products;
create policy "admin users can manage products"
on public.products for all
to authenticated
using (true)
with check (true);

drop policy if exists "admin users can manage stock movements" on public.stock_movements;
create policy "admin users can manage stock movements"
on public.stock_movements for all
to authenticated
using (true)
with check (true);

create index if not exists products_category_idx on public.products(category);
create index if not exists stock_movements_product_idx on public.stock_movements(product_id);
create index if not exists stock_movements_created_idx on public.stock_movements(created_at desc);

-- Mantiene updated_at automáticamente.
create or replace function public.set_products_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_updated_at on public.products;
create trigger products_updated_at
before update on public.products
for each row execute function public.set_products_updated_at();
