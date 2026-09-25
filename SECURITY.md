# Security Design & Testing — TenantVault

## Overview
TenantVault uses PostgreSQL **Row-Level Security (RLS)** as the core tenant isolation mechanism, enforced at the database layer — not just in application code. This means even if the backend had a bug, malicious input, or was bypassed entirely, the database itself refuses to return or modify another tenant's data.

## How it works
- Every tenant-scoped table has an RLS policy tied to a Postgres session variable: `app.current_tenant`
- The backend's middleware reads the `x-tenant-id` header from each request and sets `app.current_tenant` for that session before running any query
- The application connects as a **non-superuser role** (`app_user`) with `BYPASSRLS = false`, so RLS cannot be silently skipped
- RLS policies apply to `SELECT`, `INSERT`, `UPDATE`, and `DELETE` — not just reads

## Threat model & tests performed

| # | Attack scenario | Method | Result |
|---|---|---|---|
| 1 | No tenant context set | Query run without `SET app.current_tenant` | **Errors out** (fails closed — no accidental data exposure) |
| 2 | Forged/random tenant ID | `SET app.current_tenant` to a UUID that doesn't exist | 0 rows returned |
| 3 | Injected foreign tenant_id in query | `SELECT ... WHERE tenant_id = '<other-tenant>'` while session is set to a different tenant | 0 rows — RLS policy overrides the query's own WHERE clause |
| 4 | Elevated role check | Verified `app_user` role privileges | `rolsuper = false`, `rolbypassrls = false` |
| 5 | Cross-tenant write | Attempted `UPDATE` on a row belonging to another tenant while session set to a different tenant | `UPDATE 0` — write blocked, not just reads |

All 5 tests confirmed tenant isolation holds under adversarial conditions, not just the "happy path" UI flow.

## Why this matters
Application-level tenant filtering (e.g. `WHERE tenant_id = ?` in every query) is a common but fragile pattern — one missed `WHERE` clause anywhere in the codebase leaks data across tenants. RLS moves that guarantee into the database itself, so it holds regardless of application code correctness.

## Tested on
- Local Docker PostgreSQL 17 instance
- AWS RDS PostgreSQL 17 (production deployment) — see main README for architecture