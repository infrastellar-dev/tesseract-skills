# Tesseract Architecture Rules

Follow these rules when building architecture diagrams to produce clean,
readable, and accurate results.

---

## 1. Layout

### Golden rule: trust auto_layout

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

### Recommended workflow

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

### Adding components to an existing diagram

When adding new components to a diagram that already has a good layout:

1. **`pin_all()`** — pin every existing component. Save the returned IDs.
2. **Add components and connections** — create new nodes (no positions).
3. **`auto_layout()`** — only the new unpinned components are repositioned.
4. **`unpin_components(ids)`** — pass the IDs from step 1 to restore the
   original unpinned state.
5. **Screenshot** to verify.

### Connection routing

- Connections are routed automatically as straight lines.
- When two components have multiple connections between them, curvature is
  auto-assigned to separate the lines.
- After layout, if connections cross or clip through components, use
  `update_connection` with `curvature` (-1 to 1) to bend them around obstacles.
- Only adjust curvature **after** auto_layout and **after** verifying with a
  screenshot.

### Visual verification

Always call `screenshot` after making changes. The isometric 3D view can be
unintuitive — what looks correct in coordinates may overlap visually.

**Bad pattern**: make 10 changes -> screenshot -> discover problems -> redo

**Good pattern**: auto_layout -> screenshot -> adjust 1 component -> screenshot -> done

### Coordinate reference

Components need approximately **6-8 units** of separation on the x-axis to avoid
visual overlap. The exact amount depends on the component's label length.
This is handled automatically by `auto_layout` — only relevant when fine-tuning.

---

## 2. Layers

Every diagram must define these standard layers (top to bottom):

| Layer | Color | Purpose |
|-------|-------|---------|
| `external` | `#FFFFFF` (white) | External actors and systems (users, third-party APIs, partners) |
| `frontend` | (default) | Browser apps, CLIs, mobile |
| `api` | (default) | API gateways, BFFs, GraphQL |
| `services` | (default) | Backend services, workers, cron jobs |
| `data` | (default) | Databases, caches, queues, storage |

Add custom layers if the codebase warrants it (e.g. `infrastructure`,
`messaging`). Call `reorder_layers` to set the correct top-to-bottom order.

**Always create the `external` layer** with color `#FFFFFF`.

---

## 3. External nodes

### Top-level graph

At the root level, create external nodes for actors and systems that interact
with the architecture but are not part of it:

- **Users / Clients** — browsers, mobile apps, CLI tools
- **Third-party APIs** — payment providers, auth services, analytics
- **External data sources** — partner feeds, public APIs, webhooks

Use type `External/Service` (or the closest match from `list_types`). Place them
on the `external` layer. Connect them to the components they interact with.

External nodes are typically **sources** (they only produce data — e.g. users,
webhooks) or **sinks** (they only consume data — e.g. analytics, logging
services). Having a single connection (inbound or outbound) is expected for
external nodes.

### Subgraphs

When drilling into a component, the subgraph must include **one external node
for each connection** the parent component has in the parent graph. These
external nodes represent the interface between the component and the rest of
the system.

**Example:** If a `Dashboard` component has 3 connections in the parent graph
(to `API Gateway`, `Auth Service`, and `WebSocket Server`), then its subgraph
must contain 3 external nodes named after those connected components.

**Workflow for subgraph external nodes:**

1. Before creating sub-components, call `get_graph` at root (or parent level)
   to find all connections involving the target component.
2. For each connected component, create an external node inside the subgraph
   with `parent_path` set to the target component.
3. Connect these external nodes to the relevant internal sub-components.

This ensures every subgraph is self-contained and clearly shows how data enters
and leaves the component.

---

## 4. Connectivity

### Every component must be connected

A component with zero connections is an error. Every component must have at
least one connection (inbound, outbound, or bidirectional).

### Inputs, outputs, and pass-through

Components fall into three connectivity patterns:

| Pattern | Description | Examples |
|---------|-------------|---------|
| **Source** | Output(s) only | Users, webhook producers, external data feeds |
| **Sink** | Input(s) only | Analytics services, log aggregators, monitoring |
| **Pass-through** | At least one input AND at least one output | API gateways, backend services, middleware |

Most internal components (services, APIs, gateways) should be **pass-through** —
they receive data and forward or transform it. A service with only inputs or
only outputs is suspicious and should be verified.

### Dead-end analysis

When a component has connections in only one direction (all inbound or all
outbound), verify it is intentional:

- **Legitimate dead-ends:** standalone microservices that produce data without
  consuming any (e.g. random number generator, metrics exporter), or terminal
  sinks (e.g. data warehouse, log storage).
- **Suspicious dead-ends:** a backend service with only inputs (where does its
  output go?) or an API with only outputs (where does it get its data?).

For suspicious dead-ends, trace the data flows to find the missing connection.
Ask the user if the flow is unclear.

### External nodes are sinks or sources

External nodes (`external` layer) typically have a single connection direction.
This is expected — they represent the system boundary. Do not flag external
nodes as dead-ends.

---

## 5. Components

### Naming

- Name components after their actual name in the codebase (service name,
  package name, module name).
- Do NOT create duplicate components — always check `get_graph` first.

### Types

- Always call `list_types` before creating components to get valid types.
- Use the technology stack found in the code for the `tech` field.

### Sizing

- Aim for **8-20 components** at the top level — enough to show the architecture
  clearly without clutter.
- Keep subgraphs focused — **4 to 8 internal components** is ideal.
- If the codebase is a monolith, identify logical modules rather than creating
  a single giant component.

### Descriptions

- Every component must have a `description` — a one-line summary of its purpose.
- Every connection must have a `description` — what data flows through it.

---

## 6. Connections

### Protocols

Use the actual protocol found in the code:

| Pattern | Protocol |
|---------|----------|
| REST / HTTP client calls | `HTTPS` |
| gRPC / protobuf | `gRPC` |
| GraphQL queries | `GraphQL` |
| WebSocket connections | `WebSocket` |
| Server-sent events | `HTTP/SSE` |
| SQL database access | `SQL` |
| Redis commands | `Redis` |
| MongoDB queries | `MongoDB` |
| Message queue pub/sub | `AMQP` / `Kafka` |
| S3 / object storage | `S3 API` |

### Direction

- Connect components based on actual imports, API calls, or config references
  found in the code.
- Use `bidirectional: true` only for protocols that genuinely flow both ways
  (e.g. WebSocket, some gRPC streams).

---

## 7. General rules

- **Always create an `external` layer** (white, `#FFFFFF`) with external nodes.
- **Always call `screenshot`** after layout to verify visually.
- **Never guess** — if a connection or component purpose is unclear, ask the user.
- **Use `parent_path`** when adding sub-components inside a subgraph.

---

## Quick reference

| Rule | Value |
|------|-------|
| Set positions during creation | **No** — omit them |
| Primary layout method | `auto_layout` |
| Preserve existing positions | `pin_all` -> add -> `auto_layout` -> `unpin_components` |
| Connection curvature range | -1 to 1 (0 = straight) |
| Verify with | `screenshot` tool |
| Fine-tune scope | 1-3 components max, with screenshot between each |
| External layer | Always create, white `#FFFFFF` |
| Subgraph external nodes | One per parent connection, on `external` layer |
| Top-level component count | 8-20 |
| Subgraph component count | 4-8 |
| Every component connected | Yes — zero connections is an error |
| External nodes | Typically source or sink (one direction OK) |
| Internal dead-ends | Verify intentional, trace flows if suspicious |
