# Logixian Agents

Shared best-practice configurations for AI coding agents used across the Logixian studio project. The goal is a single repo where the team maintains optimized, reusable setups for every supported agent — so no one has to configure from scratch.

> **Current support:** Claude Code — more agents (Gemini, Copilot, etc.) coming as the project grows.

## Repo Structure

| Path | Agent | Purpose |
|---|---|---|
| `CLAUDE.md` | Claude Code | Project-level instructions, auto-loaded by Claude Code |
| `.claude/commands/` | Claude Code | Custom slash commands for Claude Code sessions |
| `gemini/` | Gemini | _(planned)_ Agent configuration and prompt templates |
| `.github/copilot-instructions.md` | GitHub Copilot | _(planned)_ Repo-level instructions for Copilot |

## Setup

### Claude Code


**Option 1 — Project-scoped (recommended for team use)**

Clone the repo and open it in Claude Code. All settings and commands load automatically.

```bash
git clone <repo-url> logixian-agents
cd logixian-agents
claude .
```

**Option 2 — Personal user-level integration (optional)**

To make these commands available in every Claude Code session on your machine, copy them into your global config directory.

```bash
mkdir -p ~/.claude/commands

# Copy a specific command
cp .claude/commands/prompt-coach.md ~/.claude/commands/

# Or copy all commands
cp .claude/commands/*.md ~/.claude/commands/
```

> **Project-level vs. user-level:** Settings in `.claude/` apply only when Claude Code is opened inside this project. Settings in `~/.claude/` apply globally across all projects.

### Gemini

> _(planned)_ Configuration guide will be added here once Gemini support is introduced.

### GitHub Copilot

> _(planned)_ Configuration guide will be added here once Copilot support is introduced.

## Available Commands

### Claude Code

| Command | Description |
|---|---|
| `/prompt-coach` | Audits your English prompt and executes the task. Designed for non-native English speakers. |

### Gemini
> _(planned)_

### GitHub Copilot
> _(planned)_

## Resources

### Claude Code
- [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code)
- [Custom slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands)
- [CLAUDE.md reference](https://docs.anthropic.com/en/docs/claude-code/claude-md)

### Gemini
> _(planned)_

### GitHub Copilot
> _(planned)_
