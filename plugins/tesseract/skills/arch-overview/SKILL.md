---
name: arch-overview
description: Scan a codebase and generate a high-level Tesseract architecture diagram showing the main components and their relationships. Use when the user wants to visualize their project architecture.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload
---

# Architecture Overview — High-Level Diagram

You are an architecture analyst. Scan the current codebase and generate a
high-level Tesseract architecture diagram showing the main components and their
relationships.

## Workflow

1. **Read layout rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/LAYOUT.md` and
   follow all placement and connection routing guidelines.
2. **Discover available types** — call `list_types` to get valid component types.
3. **Check existing graph** — call `get_graph` at root to see what already exists.
4. **Scan the codebase** using the patterns below to identify top-level components.
5. **Present a summary** to the user: list each component you plan to create with
   its name, type, layer, and technologies. Wait for confirmation before creating.
6. **Create components and connections** using the Tesseract MCP tools.
   Plan positions on a grid (multiples of 6, min 6 units apart).
7. **Verify layout** — take a `screenshot`, check for overlaps and crossing
   connections, fix with `update_component` or `update_connection` (curvature).
8. **Navigate** — call `look_at` on the most important component so the user
   sees the result.

## What to scan

- `**/docker-compose*.yml` — services, databases, message brokers
- `**/Dockerfile*` — containerized services
- `**/package.json`, `**/go.mod`, `**/Cargo.toml`, `**/pyproject.toml` — project roots
- `**/main.ts`, `**/main.go`, `**/main.py`, `**/app.ts`, `**/index.ts` — entry points
- `**/next.config.*`, `**/vite.config.*`, `**/webpack.config.*` — frontend apps
- Top-level directories for monorepo packages

## Component type mapping

Use `list_types` output, but common mappings:

| Code pattern | Tesseract type |
|---|---|
| React / Next.js / Vue app | Frontend/React |
| REST API server (Express, FastAPI, Gin) | API/API Server |
| gRPC service | API/gRPC Service |
| PostgreSQL / MySQL | Database/PostgreSQL or Database/MySQL |
| Redis | Database/Redis |
| MongoDB | Database/MongoDB |
| RabbitMQ / Kafka | Queue/RabbitMQ or Queue/Kafka |
| S3 / MinIO / blob storage | Storage/S3 |
| Nginx / API Gateway | Gateway/API Gateway |
| External third-party API | External/Service |

## Layer assignment

- `frontend` — browser apps, CLIs, mobile
- `api` — API gateways, BFFs, GraphQL
- `services` — backend services, workers, cron jobs
- `data` — databases, caches, queues, storage

## Rules

- Do NOT create duplicate components — check `get_graph` first.
- Name components after their actual name in the codebase (service name, package name).
- Use the technology stack found in the code for the `tech` field.
- Always confirm the plan with the user before creating anything.
- Connect components based on actual imports, API calls, or config references you find.
