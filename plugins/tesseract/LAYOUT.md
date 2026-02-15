# Layout Guidelines

Follow these rules when placing components and creating connections to produce
clean, readable architecture diagrams.

## Component spacing

- **Minimum 6 units** between any two components (`position_x` / `position_z`).
- Group related components together but keep clear gaps between groups.
- Align components in rows or columns when they share the same layer.
- Prefer grid-aligned positions (multiples of 6) for a tidy layout.

## Positioning strategy

1. **Plan positions before creating** — sketch a mental grid:
   - X axis = horizontal spread within a layer
   - Z axis = depth (front-to-back, affects visual stacking)
2. **Center the main component** at (0, 0) and place others relative to it.
3. **Avoid clusters** — if you have 6+ components, spread them in a wider pattern
   (e.g. two rows of 3 rather than a single row of 6).
4. **Symmetric layouts** look best — mirror left/right when possible.

## Connection routing

- **Connections must not cross** other connections if avoidable. Reposition
  components or use `curvature` to separate crossing paths.
- **Connections must not pass through components**. If a straight line would
  clip a component, use `curvature` (-1 to 1) to bend the connection around it.
- When two components have multiple connections between them, curvature is
  auto-assigned. Override with explicit values if the result looks crowded.
- Use `update_connection` to adjust curvature after creation if needed.

## Auto Layout

Instead of manually positioning every component, use `auto_layout` to
automatically arrange the diagram. The layout algorithm avoids connection
crossings and enforces minimum spacing.

### Basic usage

After creating all components and connections, call `auto_layout` once:

```
auto_layout()
```

### Adding to an existing diagram (pin/layout/unpin workflow)

When a diagram already has user-placed components, use this workflow to add new
components without disturbing existing positions:

1. **`pin_all()`** — pin every existing component. Save the returned IDs.
2. **Add components and connections** — create new nodes (they start at 0,0).
3. **`auto_layout()`** — runs the layout algorithm. Pinned components stay
   fixed; only the new (unpinned) ones are repositioned.
4. **`unpin_components(ids)`** — pass the IDs from step 1 to restore the
   original unpinned state.

This is the **recommended approach** when extending a diagram that already has
components placed by the user or by a previous layout pass.

### When to use manual positioning instead

- Precise pixel-perfect placement is required.
- The diagram has very few components (1–3) where manual placement is trivial.
- You need a specific non-standard layout shape (e.g. circular, diagonal).

## Visual verification

After placing all components and connections (or after `auto_layout`):

1. Call `screenshot` to capture the current view.
2. Check for:
   - Overlapping components (reposition if needed)
   - Crossing connections (add curvature or reposition)
   - Connections clipping through components (add curvature)
   - Uneven spacing (adjust positions)
3. Fix any issues found, then take a final screenshot to confirm.

## Quick reference

| Rule | Value |
|------|-------|
| Min component spacing | 6 units |
| Grid alignment | multiples of 6 |
| Connection curvature range | -1 to 1 (0 = straight) |
| Ideal components per row | 3–4 |
| Verify with | `screenshot` tool |
| Auto layout | `auto_layout` tool |
| Preserve positions | `pin_all` → add → `auto_layout` → `unpin_components` |
