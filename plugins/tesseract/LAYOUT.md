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

## Visual verification

After placing all components and connections:

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
