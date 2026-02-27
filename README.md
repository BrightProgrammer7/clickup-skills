# ClickUp Agent Skills

A library of Agent Skills for managing ClickUp workspaces via direct REST API calls. Each skill follows the [Agent Skills open standard](https://github.com/anthropics/agent-skills), for compatibility with coding agents such as Claude Code, Gemini CLI, Cursor, and others.

## Installation & Discovery

Install any skill from this repository using the `skills` CLI. This command will automatically detect your active coding agents and place the skill in the appropriate directory.

```bash
# List all available skills in this repository
npx skills add BrightProgrammer7/clickup-skills --list

# Install the ClickUp skill globally
npx skills add BrightProgrammer7/clickup-skills --skill clickup --global
```

## Available Skills

### clickup

Interact with ClickUp workspaces using direct REST API calls (`curl`). No MCP server required — just a personal API token stored in `CLICKUP_TOKEN`.

**Capabilities:**
- Workspace, space, folder, and list management
- Task CRUD operations (create, read, update, delete)
- Subtask creation and management
- Comments and custom fields
- Time tracking (entries, timers)
- Member and tag management
- Goals and webhooks
- Pagination and rate limit handling

```bash
npx skills add BrightProgrammer7/clickup-skills --skill clickup --global
```

### Prerequisites

1. Go to **ClickUp > Settings > Apps > API Token** and generate a personal token
2. Export the token:
   ```bash
   export CLICKUP_TOKEN="pk_YOUR_TOKEN_HERE"
   ```

## Repository Structure

```text
skills/clickup/
├── SKILL.md                    — Agent instructions and API reference
├── clickup-api-reference.md    — Full endpoint documentation
└── clickup.sh                  — Helper script for common operations
```

## Adding New Skills

All new skills should follow the standardized structure:

```text
skills/[category]/
├── SKILL.md           — The "Mission Control" for the agent
├── scripts/           — Executable helpers and utilities
├── resources/         — Knowledge base (checklists, guides)
└── examples/          — Reference implementations
```

### Great candidates for new skills
- **Automation**: Skills that create workflows triggered by ClickUp webhooks
- **Reporting**: Skills that aggregate task data into summaries and dashboards
- **Integration**: Skills that sync ClickUp with other tools (GitHub, Slack, etc.)
- **Bulk Operations**: Skills that perform batch updates across tasks and lists

## License

[Apache 2.0](LICENSE)
