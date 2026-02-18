---
name: arch-services
description: Scan services and APIs in the codebase to add them to the Tesseract architecture diagram. Use after arch-overview to add detail to the services layer.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
---

# Architecture — Services & APIs

You are an architecture analyst. Scan the codebase for services and API layers,
then add them to the Tesseract diagram.

## Workflow

1. **Read rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/RULES.md` and
   follow all layout, connectivity, and naming guidelines.
2. **Discover available types** — call `list_types`.
3. **Check existing graph** — call `get_graph` to avoid duplicates.
4. **Discover service directories** — use `Glob` to find directories matching
   the "What to scan" patterns below. Build a list of distinct service roots.
5. **Scan services in parallel** — if there are multiple service directories,
   use the `Task` tool to launch one agent per service. Send all `Task` calls
   in a **single message** so they run concurrently. Each agent should:
   - Read routes, controllers, middleware, and client calls in its directory
   - Identify the service name, type, layer, tech, endpoints, and connections
   - Return a structured summary
   Use `subagent_type: "Explore"` and keep each agent focused on its own
   directory. For small codebases with 1-2 services, scan sequentially instead.
6. **Merge results** — collect agent outputs, deduplicate, and identify
   inter-service connections.
7. **Pin existing components** — call `pin_all` and save the returned IDs.
8. **Create components and connections** in Tesseract (no positions needed).
9. **Run auto layout** — call `auto_layout` to place new components.
10. **Unpin** — call `unpin_components` with the IDs from step 7.
11. **Verify layout** — take a `screenshot`, check for overlaps and crossing
    connections, fix with `update_component` or `update_connection` (curvature).
12. **Navigate** — `look_at` the main API component.

## What to scan

- `**/routes/**`, `**/router/**`, `**/controllers/**` — REST route definitions
- `**/api/**`, `**/endpoints/**` — API endpoint files
- `**/*.proto` — gRPC service definitions
- `**/graphql/**`, `**/*.graphql`, `**/schema.graphql` — GraphQL schemas
- `**/openapi.*`, `**/swagger.*` — API specifications
- `**/middleware/**` — middleware layers
- HTTP client usage: `fetch`, `axios`, `got`, `http.Client`, `requests`
- Queue consumers/producers: `amqplib`, `kafkajs`, `bullmq`, `celery`
- WebSocket handlers

## Component type mapping

| Code pattern | Tesseract type |
|---|---|
| Express/Fastify/Koa REST server | API/API Server |
| FastAPI/Flask/Django REST | API/API Server |
| Gin/Echo/Fiber REST | API/API Server |
| gRPC service definition | API/gRPC Service |
| GraphQL server | API/GraphQL |
| API Gateway / reverse proxy | Gateway/API Gateway |
| Background worker / consumer | Compute/Worker |
| Cron job / scheduler | Compute/Scheduler |
| WebSocket server | API/WebSocket |

## Rules

All common rules (layers, external nodes, naming, connectivity, protocols) are
in `RULES.md` — read it first. Skill-specific rules:

- Describe connections with what data flows through them (not just the protocol).
- For protocol mapping, see `RULES.md` § 6 Connections.
