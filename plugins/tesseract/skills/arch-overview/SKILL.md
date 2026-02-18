---
name: arch-overview
description: Scan a codebase and generate a high-level Tesseract architecture diagram showing the main components and their relationships. Use when the user wants to visualize their project architecture.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
---

# Architecture Overview — High-Level Diagram

You are an architecture analyst. Scan the current codebase and generate a
high-level Tesseract architecture diagram showing the main components and their
relationships.

## Workflow

1. **Read rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/RULES.md` and
   follow all layout, connectivity, and naming guidelines.
2. **Discover available types** — call `list_types` to get valid component types.
3. **Check existing graph** — call `get_graph` at root to see what already exists.
4. **Discover packages** — use `Glob` to find top-level project roots
   (`**/package.json`, `**/go.mod`, `**/pyproject.toml`, `**/Cargo.toml`,
   `**/docker-compose*.yml`). Build a list of directories to scan.
5. **Scan packages in parallel** — use the `Task` tool to launch one agent per
   package/directory. Send all `Task` calls in a **single message** so they run
   concurrently. Each agent should:
   - Read the package's entry points, config files, and dependencies
   - Identify the component name, type (from the type mapping below), layer,
     technologies, and any connections to other packages it can detect
   - Return a structured summary (name, type, layer, tech, description,
     connections)
   Use `subagent_type: "Explore"` and include the "What to scan" patterns in
   each agent's prompt. Keep each agent focused on its own directory.
6. **Merge results** — collect all agent outputs and deduplicate. Identify
   cross-package connections from imports, API calls, and config references.
7. **Present a summary** to the user: list each component you plan to create with
   its name, type, layer, and technologies. Wait for confirmation before creating.
8. **Pin existing components** — if the graph already has components, call
   `pin_all` and save the returned IDs so existing positions are preserved.
9. **Create components and connections** using the Tesseract MCP tools.
   No need to specify positions — `auto_layout` will handle placement.
10. **Run auto layout** — call `auto_layout` to position all unpinned components.
11. **Unpin** — call `unpin_components` with the IDs from step 8 to restore the
    original state.
12. **Verify layout** — take a `screenshot`, check for overlaps and crossing
    connections, fix with `update_component` or `update_connection` (curvature).
13. **Navigate** — call `look_at` on the most important component so the user
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

## Rules

All common rules (layers, external nodes, naming, connectivity, protocols) are
in `RULES.md` — read it first. Skill-specific rules:

- After identifying internal components, identify external actors (users,
  third-party APIs, data sources) and create them on the `external` layer.
- Connect components based on actual imports, API calls, or config references
  you find in the code.
