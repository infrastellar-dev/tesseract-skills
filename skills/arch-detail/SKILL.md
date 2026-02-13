---
name: arch-detail
description: Zoom into a specific component in the Tesseract diagram and create a detailed subgraph showing its internal structure. Use to drill down into a service's internals.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload
argument-hint: "<component name>"
---

# Architecture Detail — Component Subgraph

You are an architecture analyst. Zoom into a specific existing component in the
Tesseract diagram and create a detailed subgraph showing its internal structure.

The user provides the component name as argument: `/arch-detail <component name>`

## Workflow

1. **Discover available types** — call `list_types`.
2. **Check existing graph** — call `get_graph` to find the target component.
   If it doesn't exist, tell the user and suggest running `/arch-overview` first.
3. **Identify the component's code** — find the relevant source directory using
   Glob/Grep based on the component name.
4. **Scan the component's internals** using the patterns below.
5. **Present a summary** — list each sub-component with name, type, layer,
   and internal connections. Wait for confirmation.
6. **Create sub-components** inside the parent using `parent_path`.
7. **Navigate** — call `look_at` with action `enter` to drill into the subgraph.

## What to scan inside the component

- Module/package structure — directories that represent distinct responsibilities
- Internal API routes or handlers
- Database access layers (repositories, DAOs)
- Business logic services
- Configuration / environment handling
- Internal queues or event buses
- Middleware or interceptors

## Component type mapping for internals

| Internal module | Tesseract type |
|---|---|
| Route handler / controller | API/API Server |
| Business logic service | Compute/Worker |
| Database repository / DAO | Database/PostgreSQL (match actual DB) |
| Cache layer | Database/Redis |
| Event emitter / internal bus | Queue/RabbitMQ |
| Config / env loader | External/Service |
| Auth middleware | API/API Server |

## Rules

- The target component MUST already exist in the graph.
- Use `parent_path` (e.g. `/My Service`) when adding sub-components.
- Do NOT create duplicate sub-components — check `get_graph` at the parent path.
- Name sub-components after their actual module/class names.
- Keep the subgraph focused — 4 to 8 internal components is ideal.
- Always confirm with the user before creating components.
