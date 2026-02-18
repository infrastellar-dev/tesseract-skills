---
name: arch-detail
description: Zoom into a specific component in the Tesseract diagram and create a detailed subgraph showing its internal structure. Use to drill down into a service's internals.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, Task, mcp__tesseract__list_types, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__add_component, mcp__tesseract__update_component, mcp__tesseract__remove_component, mcp__tesseract__add_connection, mcp__tesseract__update_connection, mcp__tesseract__remove_connection, mcp__tesseract__look_at, mcp__tesseract__annotate, mcp__tesseract__update_project, mcp__tesseract__screenshot, mcp__tesseract__export_mermaid, mcp__tesseract__import_mermaid, mcp__tesseract__list_layers, mcp__tesseract__add_layer, mcp__tesseract__update_layer, mcp__tesseract__remove_layer, mcp__tesseract__reorder_layers, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow, mcp__tesseract__prepare_download, mcp__tesseract__confirm_download, mcp__tesseract__prepare_upload, mcp__tesseract__auto_layout, mcp__tesseract__pin_all, mcp__tesseract__unpin_components
argument-hint: "<component name>"
---

# Architecture Detail — Component Subgraph

You are an architecture analyst. Zoom into a specific existing component in the
Tesseract diagram and create a detailed subgraph showing its internal structure.

The user provides the component name as argument: `/arch-detail <component name>`

## Workflow

1. **Read layout rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/LAYOUT.md` and
   follow all placement and connection routing guidelines.
2. **Discover available types** — call `list_types`.
3. **Check existing graph** — call `get_graph` at root to find the target
   component and **all its connections in the parent graph**. If the component
   doesn't exist, tell the user and suggest running `/arch-overview` first.
4. **Identify external nodes** — for each connection the target component has in
   the parent graph, note the other component's name. These will become external
   nodes in the subgraph (see "External nodes for subgraphs" below).
5. **Identify the component's code** — find the relevant source directory using
   Glob/Grep based on the component name.
6. **Scan the component's internals** using the patterns below.
7. **Present a summary** — list each sub-component (including external nodes)
   with name, type, layer, and internal connections. Wait for confirmation.
8. **Create external nodes** inside the parent using `parent_path`, on the
   `external` layer, using type `External/Service`.
9. **Create internal sub-components** inside the parent using `parent_path`
   (no positions needed).
10. **Connect** external nodes to the internal sub-components that handle those
    interactions, and connect internal sub-components to each other.
11. **Run auto layout** — call `auto_layout` with the parent path to position
    sub-components inside the subgraph.
12. **Verify layout** — take a `screenshot`, check for overlaps and crossing
    connections, fix with `update_component` or `update_connection` (curvature).
13. **Navigate** — call `look_at` with action `enter` to drill into the subgraph.

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

## External nodes for subgraphs

Every subgraph must include **one external node for each connection** the parent
component has in the parent graph. These represent the interface between the
component's internals and the rest of the system.

**Example:** If `Dashboard` has connections to `API Gateway`, `Auth Service`, and
`WebSocket Server` in the parent graph, the Dashboard subgraph must contain 3
external nodes: `API Gateway`, `Auth Service`, `WebSocket Server`.

- Place external nodes on the `external` layer (white, `#FFFFFF`). Create this
  layer inside the subgraph if it doesn't exist.
- Use type `External/Service` (or the closest match from `list_types`).
- Name each external node after the connected component in the parent graph.
- Connect each external node to the internal sub-component(s) that handle the
  corresponding interaction.

This ensures the subgraph is self-contained and clearly shows how data flows in
and out of the component.

## Rules

- The target component MUST already exist in the graph.
- Use `parent_path` (e.g. `/My Service`) when adding sub-components.
- Do NOT create duplicate sub-components — check `get_graph` at the parent path.
- Name sub-components after their actual module/class names.
- Keep the subgraph focused — 4 to 8 internal components is ideal.
- **Always create external nodes** for each connection the parent has.
- Always confirm with the user before creating components.
