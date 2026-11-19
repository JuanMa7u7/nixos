---
name: database-engineering
description: Use for SQL Server, relational schema design, query optimization, indexing, transactions, migrations, and multi-tenant data integrity.
---

# Database Engineering

Inspect schema, constraints, indexes, query patterns, ORM behavior, and transaction boundaries before recommending changes.

Focus on:
- correctness and referential integrity
- tenant isolation
- transaction scope and concurrency
- query plans and index selectivity
- pagination and N+1 queries
- migration safety and rollback
- backward compatibility during deployments

Do not invent schema details. Distinguish observed schema from assumptions. Prefer measuring query plans and representative workloads over speculative indexing. Include migration and rollback strategy.
