---
name: fullstack-engineering
description: Use for React, TypeScript, Node.js, .NET, REST APIs, SaaS architecture, multi-tenancy, testing, and full-stack implementation.
---

# Full-Stack Engineering

## Ground rules
- Inspect the repository's conventions, package manifests, and architecture before proposing changes.
- Follow existing patterns unless there is a documented reason to change them.
- Prefer simple, explicit, maintainable solutions over speculative abstractions.
- Keep TypeScript strict; preserve types at API and persistence boundaries.
- Validate inputs at trust boundaries and handle errors intentionally.
- Do not assume a framework version; inspect lockfiles and manifests.

## SaaS concerns
- Enforce tenant isolation on every tenant-scoped read and write.
- Treat tenant identity as server-validated, never trusted from client input alone.
- Check authorization independently from authentication.
- Preserve auditability and transaction boundaries.
- Consider 2FA, RBAC, JWT/session lifecycle, and file-upload security where relevant.

## Testing
- Add tests for business rules, authorization boundaries, tenant isolation, and regression cases.
- Prefer focused unit/integration tests; use browser E2E for critical user journeys.
- Run the repository's actual lint, typecheck, and test scripts.
- Report commands run and their real outcomes.
