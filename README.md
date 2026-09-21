# TenantVault

A secure multi-tenant database platform for co-working space management — built to demonstrate production-grade PostgreSQL DBA and security practices.

## The Problem

Companies like WeWork or Innov8 need to serve multiple client organizations (tenants) from a single system, while guaranteeing that one tenant can never see another tenant's data — even if application code has a bug.

## Key Features

- **Row-Level Security (RLS)** — Database-enforced tenant isolation. Even a raw SQL query cannot cross tenant boundaries.
- **Audit Logging (pgAudit)** — Every write operation (INSERT/UPDATE/DELETE) and schema change is logged automatically.
- **Backup & Restore** — Automated `pg_dump` backups with a tested restore procedure.
- **Tenant-aware API** — Node.js middleware sets database session context per request based on tenant identity.
- **Admin Panel** — React dashboard to browse tenant data with live tenant switching.

## Architecture

React Admin Panel (Vite + Tailwind)
│
▼
Node.js/Express API (tenant middleware)
│
▼
PostgreSQL 17 (Row-Level Security + pgAudit)


## Tech Stack

- **Database:** PostgreSQL 17, Row-Level Security, pgAudit
- **Backend:** Node.js, Express, node-postgres
- **Frontend:** React (Vite), Tailwind CSS
- **Infra:** Docker Compose (local), AWS (planned: RDS, EC2/ECS, Secrets Manager)

## Local Setup

```bash
git clone <repo-url>
cd tenantvault
docker-compose up -d --build

cd backend
npm install
node server.js
```

In a separate terminal:

```bash
cd frontend
npm install
npm run dev
```

Visit `http://localhost:5173`

## Security Design

Two demo tenants (Innov8 Hub, WorkNest) share the same database and schema. Every table carries a `tenant_id` column, and PostgreSQL RLS policies enforce that a session can only see rows matching its `app.current_tenant` session variable. This variable is set by the backend middleware on every incoming request, based on the `x-tenant-id` header.

The application connects as a non-superuser role (`app_user`), since PostgreSQL superusers bypass RLS entirely — a critical detail for correct enforcement.

## Audit Logging

pgAudit is compiled into a custom Postgres image (see `db/Dockerfile`) and configured to log all write and DDL operations:

pgaudit.log = write,ddl


Read-only queries (SELECT) are intentionally excluded to keep logs focused on data-changing events, matching common production practice.

## Backup & Recovery

```powershell
.\db\backup.ps1
.\db\restore.ps1 -BackupFile <path-to-backup>
```

Backups are timestamped `pg_dump` exports. Restoring into a non-empty database will conflict on existing rows (`COPY` is all-or-nothing) — restore into a clean database or use point-in-time recovery for selective restores.

## Project Structure

tenantvault/
├── db/
│ ├── Dockerfile # Postgres 17 + pgAudit
│ ├── schema.sql # Tables, indexes, RLS policies
│ ├── seed.sql # Demo tenant data
│ ├── backup.ps1
│ └── restore.ps1
├── backend/
│ ├── server.js # Express API + tenant middleware
│ └── db.js # Connection pool
├── frontend/
│ └── src/App.jsx # Admin panel UI
└── docker-compose.yml


## Roadmap

- [ ] AWS deployment (RDS in private subnet, EC2/ECS, Secrets Manager, CloudWatch)
- [ ] CI/CD pipeline
- [ ] Point-in-time recovery demo