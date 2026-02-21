---
name: arch-flow
description: Trace and visualize a data flow through the Tesseract architecture diagram. Creates flow paths at each graph level (root and subgraphs) with consistent colors. Use when the user wants to trace how data moves through the system.
disable-model-invocation: true
allowed-tools: Glob, Grep, Read, Bash, mcp__tesseract__list_components, mcp__tesseract__get_graph, mcp__tesseract__get_user_context, mcp__tesseract__look_at, mcp__tesseract__screenshot, mcp__tesseract__highlight_path, mcp__tesseract__clear_highlights, mcp__tesseract__save_flow, mcp__tesseract__list_flows, mcp__tesseract__show_flow, mcp__tesseract__update_flow, mcp__tesseract__delete_flow
argument-hint: "<flow description>"
---

# Architecture Flow — Trace Data Paths

You are an architecture analyst. Trace a data flow through the existing
Tesseract architecture diagram and visualize it as a highlighted path.

The user provides a flow description as argument:
`/arch-flow <description>`

Examples:
- `/arch-flow user login`
- `/arch-flow order placement from checkout to payment`
- `/arch-flow webhook delivery pipeline`

## Workflow

1. **Read rules** — `Read` the file `${CLAUDE_PLUGIN_ROOT}/RULES.md` and
   follow all connectivity and naming guidelines.
2. **Understand the graph** — call `get_graph` at root to see all components
   and connections. Note which components have children (subgraphs).
3. **Identify the flow** — based on the user's description, determine:
   - The **entry point** (where the flow starts — usually an external node)
   - The **intermediate components** (services, APIs, queues it passes through)
   - The **exit point** (where the flow ends — a data store, external sink, or
     response back to the entry point)
4. **Plan paths per level** — for each component in the flow that has a
   subgraph, drill into it with `get_graph` at that path to determine the
   internal route. Build one path per level (no cross-level mixing):
   - **Root-level path**: the high-level flow across top-level components
   - **Subgraph paths**: one separate path per subgraph, using external nodes
     as entry/exit points
5. **Choose a color palette** — pick a base color for the flow and use it
   consistently across all levels (see "Color consistency" below).
6. **Create the flow paths** — use `save_flow` (preferred) or `highlight_path`
   (fallback). See "Flow creation strategy" below.
7. **Verify** — take a `screenshot` at root level. Then `look_at` each
   subgraph with `action: "enter"` and screenshot to verify internal paths.

## Flow creation strategy

### Preferred: save_flow (persistent)

Use `highlight_path` to create all paths for the flow, then `save_flow` to
persist them. Saved flows survive graph reloads and can be toggled on/off.

```
1. clear_highlights                          — start clean
2. highlight_path (root-level path, color)   — creates highlight #1
3. highlight_path (subgraph path, color)     — creates highlight #2 (repeat per subgraph)
4. save_flow (label: "<user's description>") — persists all active highlights
5. clear_highlights                          — clean up
```

### Fallback: highlight_path only

If `save_flow` returns an error (feature not available), use `highlight_path`
alone. The highlights are temporary but still visible.

```
1. clear_highlights
2. highlight_path (root-level path, color)
3. highlight_path (subgraph path, color, parent_path)
```

Inform the user that highlights are temporary and will disappear on reload.

## Multilevel flows

Flows should be **multilevel by default**. When the root-level flow passes
through a component that has a subgraph, always trace the internal path too.
Each path must stay at a **single graph level** — use separate paths for
different levels (root, subgraph, nested subgraph).

**Example:** A "user login" flow at root level might be:

```
Root:      Users → API Gateway → Auth Service → PostgreSQL
```

If `Auth Service` has a subgraph, also trace:

```
/Auth Service:  API Gateway → JWT Handler → User Repository → PostgreSQL
```

(Here `API Gateway` and `PostgreSQL` are external nodes inside the Auth Service
subgraph — they are auto-generated virtual references to the same parent-level
components, marked with `external: true` in the `get_graph` output.)

### How to build subgraph paths

1. Call `get_graph` at the subgraph path (e.g. `/Auth Service`) — external
   nodes appear automatically (flagged `external: true`)
2. Identify the external nodes matching the root-level predecessor and successor
3. Trace the internal route from the entry external node through internal
   components to the exit external node
4. Use `highlight_path` with the `parent_path` parameter set to the subgraph

## Color consistency

Use the **same color** for all paths belonging to the same flow, across all
levels. This makes it visually obvious that paths at different levels are part
of the same flow.

**Color palette for multiple flows** (when the user traces several flows):

| Flow # | Color | Name |
|--------|-------|------|
| 1 | `#ff6b6b` | Red |
| 2 | `#4ecdc4` | Teal |
| 3 | `#ffa726` | Orange |
| 4 | `#7c4dff` | Purple |
| 5 | `#66bb6a` | Green |
| 6 | `#42a5f5` | Blue |

Check existing flows with `list_flows` before choosing a color to avoid
duplicates.

When creating all `highlight_path` calls for a single flow, always pass the
same `color` parameter. This ensures root-level and subgraph-level paths have
matching colors.

## Rules

All common rules are in `RULES.md` — read it first. Skill-specific rules:

- **Multilevel by default** — always trace through subgraphs when they exist.
- **One path per level** — never mix connections from different graph levels in
  the same path. Use separate paths for root and each subgraph.
- **One color per flow** — consistent across all levels.
- **Persist when possible** — use `save_flow` to make flows permanent.
- **Verify at every level** — screenshot root + each subgraph.
- **Don't modify components** — this skill only reads the graph and creates
  flow visualizations. Never add, remove, or modify components or connections.
- **Ask when ambiguous** — if the flow could take multiple paths (e.g. through
  a load balancer), ask the user which route to trace.
- **Label clearly** — use the user's description as the flow label.
