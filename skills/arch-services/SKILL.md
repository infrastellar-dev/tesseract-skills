---
name: arch-services
description: Scan services and APIs in the codebase to add them to the Tesseract architecture diagram. Use after arch-overview to add detail to the services layer.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload
---

# Architecture — Services & APIs

You are an architecture analyst. Scan the codebase for services and API layers,
then add them to the Tesseract diagram.

## Workflow

1. **Discover available types** — call `list_types`.
2. **Check existing graph** — call `get_graph` to avoid duplicates.
3. **Scan the codebase** for services and APIs using the patterns below.
4. **Present a summary** — list each service/API you found with name, type,
   layer, endpoints, and technologies. Wait for confirmation.
5. **Create components and connections** in Tesseract.
6. **Navigate** — `look_at` the main API component.

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

## Connection protocols

Use the actual protocol found in the code:
- `HTTPS` for REST calls
- `gRPC` for protobuf services
- `GraphQL` for GraphQL
- `WebSocket` for WS connections
- `AMQP` / `Kafka` for message queues
- `SQL` for database connections

## Rules

- Do NOT create duplicate components — check `get_graph` first.
- Name services after their actual name in the codebase.
- Describe connections with what data flows through them.
- Always confirm with the user before creating components.
