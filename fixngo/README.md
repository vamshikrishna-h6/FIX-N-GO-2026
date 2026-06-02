# Fix-N-Go monorepo

This repository is rearranged into a monorepo layout. Top-level folders:

- `apps/` — mobile/web apps (customer, technician, admin)
- `backend/` — backend services
- `packages/` — shared packages
- `infrastructure/` — Docker, nginx, CI
- `docs/` — architecture and API docs

Notes:
- Existing Flutter app was migrated to `apps/customer_app` (core files copied).
- Backend core files copied to `backend/src`.
- Some apps and infra files are placeholders. Fill and expand as needed.
