# Layout Guidelines

Follow these rules when building architecture diagrams to produce clean,
readable results.

## Golden rule: trust auto_layout

The force-directed layout algorithm uses connection topology and layer
assignments to position components. It avoids edge crossings and enforces
minimum spacing automatically.

- **Never specify `position_x` / `position_z` when creating components.**
  Let components be auto-placed, then call `auto_layout` after all components
  and connections exist.
- **Never bulk-reposition components after auto_layout.** Moving many components
  without visual feedback between each move produces worse results than the
  algorithm.
- **Fine-tuning is for individual components only.** If one specific component
  overlaps or is poorly placed, move that one component and screenshot to verify.

## Recommended workflow

1. **Setup** — `update_project` (title/description), `add_layer` / `reorder_layers`
   if custom layers are needed.
2. **Add components** — call `add_component` for each component. Focus on choosing
   the correct `type` (call `list_types` first), `layer`, `tech`, and `description`.
   **Omit position parameters.**
3. **Add connections** — call `add_connection` for all data flows.
4. **Layout** — call `auto_layout` once.
5. **Verify** — call `screenshot` with `zoom_to_fit: true` to check the result.
6. **Fine-tune** (optional) — if 1-3 components need adjustment, use
   `update_component` to reposition them individually. Screenshot after each move.

## Adding components to an existing diagram

When adding new components to a diagram that already has a good layout:

1. **`pin_all()`** — pin every existing component. Save the returned IDs.
2. **Add components and connections** — create new nodes (no positions).
3. **`auto_layout()`** — only the new unpinned components are repositioned.
4. **`unpin_components(ids)`** — pass the IDs from step 1 to restore the
   original unpinned state.
5. **Screenshot** to verify.

## Connection routing

- Connections are routed automatically as straight lines.
- When two components have multiple connections between them, curvature is
  auto-assigned to separate the lines.
- After layout, if connections cross or clip through components, use
  `update_connection` with `curvature` (-1 to 1) to bend them around obstacles.
- Only adjust curvature **after** auto_layout and **after** verifying with a screenshot.

## Visual verification

Always call `screenshot` after making changes. The isometric 3D view can be
unintuitive — what looks correct in coordinates may overlap visually.

**Bad pattern**: make 10 changes -> screenshot -> discover problems -> redo

**Good pattern**: auto_layout -> screenshot -> adjust 1 component -> screenshot -> done

## Coordinate reference

Components need approximately **6-8 units** of separation on the x-axis to avoid
visual overlap. The exact amount depends on the component's label length.
Components with long names need more space. This is handled automatically by
`auto_layout` — only relevant when fine-tuning individual positions.

## External layer and external nodes

Every diagram should include an **external** layer (white, `#FFFFFF`) to represent
inputs and outputs — the boundary between the system and the outside world.

### Top-level graph

At the root level, create external nodes for actors and systems that interact with
your architecture but are not part of it:

- **Users / Clients** — browsers, mobile apps, CLI tools
- **Third-party APIs** — payment providers, auth services, analytics
- **External data sources** — partner feeds, public APIs

Use type `External/Service` (or the closest match from `list_types`). Place them
on the `external` layer. Connect them to the components they interact with.

### Subgraphs

When drilling into a component with `/arch-detail`, the subgraph must include
**one external node for each connection** the parent component has in the parent
graph. These external nodes represent the interface between the component and the
rest of the system.

**Example:** If a `Dashboard` component has 3 connections in the parent graph
(to `API Gateway`, `Auth Service`, and `WebSocket Server`), then its subgraph
must contain at least 3 external nodes named after those connected components
(`API Gateway`, `Auth Service`, `WebSocket Server`). These external nodes sit on
the `external` layer and connect to the internal sub-components that actually
handle those interactions.

**Workflow for subgraph external nodes:**

1. Before creating sub-components, call `get_graph` at root (or parent level) to
   find all connections involving the target component.
2. For each connected component, create an external node inside the subgraph with
   `parent_path` set to the target component.
3. Connect these external nodes to the relevant internal sub-components.

This ensures every subgraph is self-contained and clearly shows how data enters
and leaves the component.

## Quick reference

| Rule | Value |
|------|-------|
| Set positions during creation | **No** — omit them |
| Primary layout method | `auto_layout` |
| Preserve existing positions | `pin_all` -> add -> `auto_layout` -> `unpin_components` |
| Connection curvature range | -1 to 1 (0 = straight) |
| Verify with | `screenshot` tool |
| Fine-tune scope | 1-3 components max, with screenshot between each |
| External layer | Always create, white `#FFFFFF`, for inputs/outputs |
| Subgraph external nodes | One per parent connection, on `external` layer |
