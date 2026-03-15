# Logixian Agents

AI workflow configurations for the Logixian studio project. This repo provides shared Claude Code settings and custom slash commands that team members can use as-is or integrate into their personal setup.

## What's in This Repo

| Path | Purpose |
|---|---|
| `CLAUDE.md` | Project-level instructions loaded automatically by Claude Code |
| `.claude/commands/` | Custom slash commands available inside Claude Code sessions |

## Usage

### Option 1 — Project-scoped (recommended for team use)

Clone the repo and open it directly in Claude Code. All settings and commands are loaded automatically.

```bash
git clone <repo-url> logixian-agents
cd logixian-agents
claude .
```

Any slash command in `.claude/commands/` is immediately available (e.g., `/prompt-coach`).

### Option 2 — Personal user-level integration (optional)

If you want these commands available in **every** Claude Code session on your machine, copy them into your global Claude config directory.

**On macOS/Linux:**

```bash
# Create the global commands directory if it doesn't exist
mkdir -p ~/.claude/commands

# Copy a specific command
cp .claude/commands/prompt-coach.md ~/.claude/commands/

# Or copy all commands
cp .claude/commands/*.md ~/.claude/commands/
```

After copying, the commands are available globally — no need to be inside this repo.

> **Note:** Personal user-level settings live in `~/.claude/`. Project-level settings in `.claude/` only apply when Claude Code is opened inside that project directory. User-level settings apply everywhere.

## Available Commands

| Command | Description |
|---|---|
| `/prompt-coach` | Audits your English prompt and executes the task. Designed for non-native English speakers. |

## Claude Code Docs

- [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code)
- [Custom slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)
- [CLAUDE.md reference](https://docs.anthropic.com/en/docs/claude-code/claude-md)
