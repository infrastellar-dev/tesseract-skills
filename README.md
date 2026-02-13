# Tesseract Skills

Claude Code plugin marketplace for [Tesseract](https://infrastellar.dev) architecture generation.

Scan any codebase and generate interactive 3D architecture diagrams directly from Claude Code.

## Installation

### Via Claude Code plugin system (recommended)

```
/plugin marketplace add infrastellar-dev/tesseract-skills
/plugin install tesseract@tesseract-skills
```

### Via npx (manual fallback)

```bash
npx tesseract-skills              # install globally
npx tesseract-skills --project    # install in current project
```

## What's included

### Skills

| Skill | Description |
|-------|-------------|
| `/arch-overview` | Generate a high-level architecture diagram from a codebase |
| `/arch-services` | Scan and map services, APIs, and their connections |
| `/arch-data` | Discover databases, caches, and storage systems |
| `/arch-infra` | Map CI/CD, containers, proxies, and cloud infrastructure |
| `/arch-detail` | Drill into a component to reveal its internal structure |

### Commands

| Command | Description |
|---------|-------------|
| `/tesseract-install` | Download and launch the Tesseract desktop app |

### MCP server

The plugin auto-configures the Tesseract MCP server at `http://localhost:7440/mcp`, giving Claude access to all diagram tools (components, connections, layers, flows, screenshots, mermaid export, etc.).

## Requirements

- [Claude Code](https://claude.ai/code) with plugin support
- [Tesseract](https://infrastellar.dev) desktop app (auto-installed via `/tesseract-install`)

## How it works

1. Install the plugin from the marketplace
2. The Tesseract MCP server is auto-configured
3. Use `/arch-overview` to scan your codebase and generate a diagram
4. Refine with `/arch-services`, `/arch-data`, `/arch-infra`
5. Drill into components with `/arch-detail <component>`

If Tesseract isn't running, use `/tesseract-install` to download and launch it automatically.

## License

MIT
