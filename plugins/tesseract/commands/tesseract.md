---
allowed-tools: Bash, Read
---

# Launch Tesseract

Start the Tesseract desktop app and its MCP server.

## Steps

1. Run the setup script (downloads if needed, skips if already running):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-tesseract.sh"
```

2. Check the output:
   - If it says "Tesseract is already running" — you're good, the MCP tools are available.
   - If it says "Tesseract is ready!" — the app was just launched.
     **Tell the user to run `/mcp restart` so Claude Code reconnects to the Tesseract MCP server.**
   - If it fails — check the error message and report it to the user.

## Important

Claude Code does not automatically reconnect to MCP servers that start after
the session begins. If Tesseract was just launched (not already running), the
user **must** run `/mcp restart` for the `mcp__tesseract__*` tools to become
available.
