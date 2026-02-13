---
name: arch-data
description: Scan data models, databases, caches and storage systems in the codebase to add them to the Tesseract architecture diagram. Use after arch-overview to detail the data layer.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__get_graph, mcp__tesseract__add_component, mcp__tesseract__add_connection, mcp__tesseract__remove_component, mcp__tesseract__remove_connection, mcp__tesseract__update_component, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__list_components
---

# Architecture — Data Layer

You are an architecture analyst. Scan the codebase for databases, caches, storage
systems, and data models, then add them to the Tesseract diagram.

## Workflow

1. **Discover available types** — call `list_types`.
2. **Check existing graph** — call `get_graph` to avoid duplicates.
3. **Scan the codebase** for data layer components using the patterns below.
4. **Present a summary** — list each data store with name, type, tech, and
   which services connect to it. Wait for confirmation.
5. **Create components and connections** in Tesseract.
6. **Navigate** — `look_at` the primary database.

## What to scan

- `**/models/**`, `**/entities/**`, `**/schema/**` — ORM models
- `**/migrations/**`, `**/alembic/**`, `**/prisma/**` — migration files
- `**/prisma/schema.prisma` — Prisma schema
- `**/drizzle/**`, `**/knex/**`, `**/typeorm/**` — ORM config
- SQL files: `**/*.sql`
- Database connection strings in config/env files
- Redis usage: `redis`, `ioredis`, `redis-py`
- MongoDB usage: `mongoose`, `mongodb`, `pymongo`
- S3/storage usage: `@aws-sdk/client-s3`, `boto3`, `minio`
- Elasticsearch: `@elastic/elasticsearch`, `elasticsearch-py`

## Component type mapping

| Code pattern | Tesseract type |
|---|---|
| PostgreSQL / pg / psycopg | Database/PostgreSQL |
| MySQL / mysql2 | Database/MySQL |
| MongoDB / mongoose | Database/MongoDB |
| Redis / ioredis | Database/Redis |
| Elasticsearch | Database/Elasticsearch |
| SQLite | Database/SQLite |
| S3 / MinIO | Storage/S3 |
| Local file storage | Storage/Filesystem |

## Rules

- Do NOT create duplicate components — check `get_graph` first.
- Name databases after their actual name/purpose (e.g. "Users DB", "Cache").
- Place all data components in the `data` layer.
- Connect each service that uses a data store with the appropriate protocol
  (SQL, Redis protocol, S3 API, etc.).
- Always confirm with the user before creating components.
