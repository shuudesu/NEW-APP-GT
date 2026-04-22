-- ═══════════════════════════════════════════════
-- OS TRACKER — Schema Supabase
-- Cole este SQL no Supabase: SQL Editor → New Query
-- ═══════════════════════════════════════════════

-- Tabela de ordens de serviço
create table if not exists ordens (
  id           bigserial primary key,
  numero_os    text,
  data_emissao text,
  fornecedor   text not null,
  cnpj_fornecedor text,
  comprador    text,
  descricao_servico text,
  valor_total  numeric(12,2) default 0,
  condicao_pagamento text,
  num_parcelas integer default 1,
  data_entrega text,
  arquivo      text,
  criado_em    timestamptz default now()
);

-- Tabela de parcelas (relacionada a ordens)
create table if not exists parcelas (
  id           bigserial primary key,
  ordem_id     bigint not null references ordens(id) on delete cascade,
  numero       integer not null,
  label        text not null,
  valor        numeric(12,2) not null,
  vencimento   text not null,
  pago         boolean default false,
  pago_em      timestamptz
);

-- Índices para performance
create index if not exists idx_parcelas_ordem on parcelas(ordem_id);
create index if not exists idx_ordens_criado on ordens(criado_em desc);

-- ─── Row Level Security ───────────────────────
-- Por enquanto deixamos aberto (app familiar, sem login)
-- Se quiser adicionar autenticação no futuro, ajuste aqui.
alter table ordens  enable row level security;
alter table parcelas enable row level security;

-- Políticas: acesso público total (anon key)
create policy "acesso publico ordens"  on ordens  for all using (true) with check (true);
create policy "acesso publico parcelas" on parcelas for all using (true) with check (true);
