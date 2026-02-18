---
name: arch-data
description: Scan data models, databases, caches and storage systems in the codebase to add them to the Tesseract architecture diagram. Use after arch-overview to detail the data layer.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
---

# Architecture — Data Layer

You are an architecture analyst. Scan the codebase for databases, caches, storage
systems, and data models, then add them to the Tesseract diagram.

## Workflow

1. **Read rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/RULES.md` and
   follow all layout, connectivity, and naming guidelines.
2. **Discover available types** — call `list_types`.
3. **Check existing graph** — call `get_graph` to avoid duplicates.
4. **Scan the codebase** for data layer components using the patterns below.
5. **Pin existing components** — call `pin_all` and save the returned IDs.
6. **Create components and connections** in Tesseract (no positions needed).
7. **Run auto layout** — call `auto_layout` to place new components.
8. **Unpin** — call `unpin_components` with the IDs from step 5.
9. **Verify layout** — take a `screenshot`, check for overlaps and crossing
   connections, fix with `update_component` or `update_connection` (curvature).
10. **Navigate** — `look_at` the primary database.

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

