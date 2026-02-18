---
name: arch-codemap
description: Analyze a codebase end-to-end and generate a complete Tesseract architecture diagram with all layers, connections, and external boundaries. The all-in-one architecture mapping skill.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
---

# Architecture Codemap — Full Codebase Analysis

You are an architecture analyst. Perform a comprehensive analysis of the current
codebase and generate a complete Tesseract architecture diagram covering all
layers: external actors, frontends, APIs, services, data stores, and
infrastructure.

This is the all-in-one skill — it replaces running `arch-overview`,
`arch-services`, `arch-data`, and `arch-infra` separately.

## Workflow

### Phase 1: Setup

1. **Read layout rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/LAYOUT.md` and
   follow all placement and connection routing guidelines.
2. **Discover available types** — call `list_types` to get valid component types.
3. **Check existing graph** — call `get_graph` at root to see what already exists.
4. **Set project metadata** — call `update_project` with the project name and a
   one-line description derived from the codebase.

### Phase 2: Codebase discovery

5. **Identify project structure** — use `Glob` to find:
   - `**/package.json`, `**/go.mod`, `**/Cargo.toml`, `**/pyproject.toml` — package roots
   - `**/docker-compose*.yml`, `**/Dockerfile*` — containerized services
   - `**/next.config.*`, `**/vite.config.*`, `**/webpack.config.*` — frontend apps
   - `**/k8s/**`, `**/terraform/**`, `**/.github/workflows/**` — infrastructure
   - Top-level directories for monorepo packages

   Build a list of distinct package/service directories to analyze.

### Phase 3: Parallel deep scan

6. **Launch parallel agents** — use the `Task` tool to scan all discovered
   directories concurrently. Send all `Task` calls in a **single message**.

   Launch one agent per package/service directory with `subagent_type: "Explore"`.
   Each agent's prompt must include:

   ```
   Analyze the directory <path> and return a structured architecture summary.

   For each component you find, provide:
   - name: the service/app/module name
   - type: one of [Frontend, API Server, gRPC Service, GraphQL, Worker,
     Scheduler, Database, Cache, Queue, Storage, Gateway, External Service]
   - layer: one of [external, frontend, api, services, data]
   - tech: comma-separated technologies (e.g. "Node.js, Express, TypeScript")
   - description: one-line purpose
   - connections: list of {target, protocol, description} for outbound calls

   Look for:
   - Entry points (main.ts, index.ts, app.py, main.go, etc.)
   - Framework usage (React, Next.js, Express, FastAPI, Gin, etc.)
   - Database connections (PostgreSQL, Redis, MongoDB, Elasticsearch)
   - Message queues (RabbitMQ, Kafka, BullMQ)
   - HTTP/gRPC/GraphQL client calls to other services
   - Storage usage (S3, MinIO, filesystem)
   - External API integrations (Stripe, Auth0, SendGrid, etc.)
   - Environment variables referencing other services or databases
   - Docker/docker-compose service definitions
   - Infrastructure config (Nginx, Traefik, Kubernetes, CI/CD)

   Return ONLY a JSON object with this structure:
   {
     "components": [...],
     "connections": [...]
   }
   ```

   Also launch a dedicated agent for infrastructure if infra files were found
   (Dockerfiles, k8s manifests, terraform, CI/CD configs).

### Phase 4: Merge and deduplicate

7. **Merge all agent results** — combine the component and connection lists from
   all agents. Deduplicate by name (prefer the richer description when merging).
   Resolve cross-package connections: if Service A calls Service B, ensure both
   exist and the connection is recorded.

8. **Identify external actors** — from the merged results, identify systems
   outside the codebase boundary:
   - Users / browsers / mobile clients
   - Third-party APIs (payment, auth, email, analytics)
   - External data sources and webhooks

   Add these as components on the `external` layer.

### Phase 5: Present and confirm

9. **Present the full architecture plan** to the user as a table:

   | Component | Type | Layer | Tech | Connections |
   |-----------|------|-------|------|-------------|
   | ... | ... | ... | ... | ... |

   Wait for user confirmation before creating anything.

### Phase 6: Build the diagram

10. **Create layers** — ensure these layers exist (create if needed):
    - `external` (color `#FFFFFF`)
    - `frontend`
    - `api`
    - `services`
    - `data`

    Add custom layers if the codebase warrants it (e.g. `infrastructure`,
    `messaging`). Call `reorder_layers` to set the correct top-to-bottom order.

11. **Pin existing components** — if the graph already has components, call
    `pin_all` and save the returned IDs.

12. **Create all components** — call `add_component` for each component.
    Omit positions. Use exact types from `list_types`.

13. **Create all connections** — call `add_connection` for each connection.
    Use the actual protocol (HTTPS, gRPC, SQL, Redis, AMQP, WebSocket, etc.).

14. **Run auto layout** — call `auto_layout` to position everything.

15. **Unpin** — call `unpin_components` with the IDs from step 11.

16. **Verify layout** — take a `screenshot` with `zoom_to_fit: true`. Check for:
    - Overlapping components
    - Crossing connections
    - Misplaced layers
    Fix issues with `update_component` (position) or `update_connection`
    (curvature). Screenshot after each fix.

17. **Navigate** — call `look_at` on the central component (usually the main
    API or gateway) so the user sees the result.

## Component type mapping

Use `list_types` output, but common mappings:

| Code pattern | Tesseract type |
|---|---|
| React / Next.js / Vue / Svelte app | Frontend/React |
| REST API server (Express, FastAPI, Gin) | API/API Server |
| gRPC service | API/gRPC Service |
| GraphQL server | API/GraphQL |
| WebSocket server | API/WebSocket |
| Background worker / consumer | Compute/Worker |
| Cron job / scheduler | Compute/Scheduler |
| PostgreSQL / MySQL | Database/PostgreSQL or Database/MySQL |
| Redis | Database/Redis |
| MongoDB | Database/MongoDB |
| Elasticsearch | Database/Elasticsearch |
| RabbitMQ / Kafka | Queue/RabbitMQ or Queue/Kafka |
| S3 / MinIO / blob storage | Storage/S3 |
| Nginx / Traefik / API Gateway | Gateway/API Gateway |
| Load balancer | Gateway/Load Balancer |
| CI/CD pipeline | Compute/CI/CD |
| Kubernetes cluster | Compute/Kubernetes |
| External third-party API | External/Service |

## Connection protocols

Use the actual protocol found in the code:

| Pattern | Protocol |
|---|---|
| REST / HTTP client calls | `HTTPS` |
| gRPC / protobuf | `gRPC` |
| GraphQL queries | `GraphQL` |
| WebSocket connections | `WebSocket` |
| SQL database access | `SQL` |
| Redis commands | `Redis` |
| MongoDB queries | `MongoDB` |
| Message queue pub/sub | `AMQP` / `Kafka` |
| S3 / object storage | `S3 API` |
| Server-sent events | `HTTP/SSE` |

## Rules

- Do NOT create duplicate components — check `get_graph` first.
- Name components after their actual name in the codebase.
- Use the technology stack found in the code for the `tech` field.
- Always confirm the full plan with the user before creating anything.
- Connect components based on actual imports, API calls, or config references.
- **Always create an `external` layer** (white, `#FFFFFF`) and add external nodes.
- Prefer fewer, well-chosen components over an exhaustive list. Aim for
  8-20 components at the top level — enough to show the architecture clearly
  without clutter.
- If the codebase is a monolith, identify logical modules rather than creating
  a single giant component.
