-- Sanitized sample migration for portfolio review.
-- This is illustrative and intentionally incomplete.

create extension if not exists pgcrypto;

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  plan text not null default 'start',
  created_at timestamptz not null default now()
);

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  email text not null unique,
  password_hash text not null,
  role text not null default 'member',
  created_at timestamptz not null default now()
);

create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  sku text not null,
  name text not null,
  barcode text,
  units_per_box integer,
  weight_kg numeric(10,3),
  created_at timestamptz not null default now(),
  unique (company_id, sku)
);

create table if not exists shipments (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  name text not null,
  status text not null default 'draft',
  provider_code text,
  created_at timestamptz not null default now()
);

create table if not exists shipment_items (
  id uuid primary key default gen_random_uuid(),
  shipment_id uuid not null references shipments(id) on delete cascade,
  product_id uuid not null references products(id) on delete restrict,
  box_count integer not null check (box_count > 0),
  created_at timestamptz not null default now()
);

create index if not exists idx_products_company_id on products(company_id);
create index if not exists idx_shipments_company_id on shipments(company_id);
create index if not exists idx_shipment_items_shipment_id on shipment_items(shipment_id);
