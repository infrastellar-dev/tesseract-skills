---
allowed-tools: Bash, Read
---

# Install or launch Tesseract

Run the setup script to download and launch Tesseract:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-tesseract.sh"
```

If the script fails, check:
1. Network connectivity to https://infrastellar.dev/releases
2. Disk space in ~/.tesseract/
3. On macOS, you may need to allow the app in System Preferences > Security
