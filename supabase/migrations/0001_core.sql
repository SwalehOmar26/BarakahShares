-- BarakahShares core tables. Identity images and private statements are not columns.
-- Store a review status and a document fingerprint only.

create table if not exists investors (
  id text primary key,
  name text not null,
  phone text not null unique,
  role text not null check (role in ('youth_investor', 'business_owner')),
  kyc_status text not null check (kyc_status in ('not_started', 'pending', 'verified', 'failed')),
  created_at timestamptz not null default now()
);

create table if not exists businesses (
  id text primary key,
  name text not null,
  location text not null,
  owner_name text not null,
  category text not null,
  summary text not null,
  monthly_profit_kes integer not null,
  target_kes integer not null,
  share_price_kes integer not null,
  total_shares integer not null,
  filled_shares integer not null default 0,
  equity_offered numeric not null,
  investor_pool numeric not null,
  campaign_status text not null check (campaign_status in ('funding', 'funding_soon', 'funded')),
  shariah_status text not null default 'pending',
  audit_status text not null default 'pending',
  halal_status text not null default 'pending',
  cma_status text not null default 'pending'
);

create table if not exists investments (
  id text primary key,
  investor_id text not null references investors (id),
  business_id text not null references businesses (id),
  amount_kes integer not null check (amount_kes > 0),
  share_count integer not null check (share_count > 0),
  ownership_percent numeric not null,
  certificate_code text not null unique,
  tx_hash text,
  invested_at timestamptz not null default now()
);

create table if not exists evidence_fingerprints (
  id text primary key,
  business_id text not null references businesses (id),
  title text not null,
  category text not null,
  amount_kes integer,
  sha256 text not null,
  ipfs_cid text,
  is_private boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists profit_distributions (
  id text primary key,
  business_id text not null references businesses (id),
  period_label text not null,
  gross_sales_kes integer not null,
  expenses_kes integer not null,
  owner_percent numeric not null,
  investor_pool_percent numeric not null,
  status text not null check (status in ('pending', 'disbursed'))
);

alter table investors enable row level security;
alter table businesses enable row level security;
alter table investments enable row level security;
alter table evidence_fingerprints enable row level security;
alter table profit_distributions enable row level security;

-- No anon policies yet. Add investor-owned select policies when auth.uid() is mapped.
-- Do not add a policy that selects ID images; those files do not belong in this schema.
