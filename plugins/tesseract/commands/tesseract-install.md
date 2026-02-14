---
allowed-tools: Bash, Read
---

# Install or launch Tesseract

Run the setup script to download and launch Tesseract:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-tesseract.sh"
```

On Linux, a symlink is created at `~/.local/bin/tesseract` pointing to the
downloaded AppImage, so `tesseract` is available directly from your PATH.

If the script fails, check:
1. Network connectivity to https://infrastellar.dev/releases
2. Disk space in ~/.tesseract/
3. On macOS, you may need to allow the app in System Preferences > Security

If Tesseract was just launched, tell the user to run `/mcp restart` so Claude
Code reconnects to the MCP server.
