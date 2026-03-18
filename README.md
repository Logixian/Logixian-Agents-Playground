# Logixian Agents

Shared best-practice configurations for AI coding agents used across the Logixian studio project. The goal is a single repo where the team maintains optimized, reusable setups for every supported agent — so no one has to configure from scratch.

> **Current support:** Claude Code — more agents (Gemini, Copilot, etc.) coming as the project grows.

## Repo Structure

| Path | Agent | Purpose |
|---|---|---|
| `CLAUDE.md` | Claude Code | Project-level instructions, auto-loaded by Claude Code |
| `.claude/skills/` | Claude Code | Custom slash skills for Claude Code sessions |
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

To make these skills available in every Claude Code session on your machine, copy them into your global config directory.

```bash
mkdir -p ~/.claude/skills

# Copy a specific skill
cp -r .claude/skills/prompt-coach ~/.claude/skills/

# Or copy all skills
cp -r .claude/skills/. ~/.claude/skills/
```

> **Project-level vs. user-level:** Settings in `.claude/` apply only when Claude Code is opened inside this project. Settings in `~/.claude/` apply globally across all projects.

**MCP Servers**

MCP (Model Context Protocol) servers extend Claude Code with live external context. The project-level MCP config is in `.claude/settings.json` and loads automatically — but each person must authenticate individually on first use.

| Server | Purpose | Auth |
|---|---|---|
| Atlassian (`mcp-atlassian-api`) | Read/write Confluence pages and Jira issues | OAuth via Atlassian account |

To authenticate, open Claude Code in this project and run `/mcp`, then follow the OAuth prompt for each server.

### Gemini

> _(planned)_ Configuration guide will be added here once Gemini support is introduced.

### GitHub Copilot

> _(planned)_ Configuration guide will be added here once Copilot support is introduced.

## Available Skills

### Claude Code

| Skill | Description |
|---|---|
| `/prompt-coach` | Audits every English prompt for grammar, Chinglish, and engineering precision before executing the task. Designed for non-native English speakers. |
| `/commit` | Stage and commit changes following conventional commit conventions (`type(scope): message`). Jira integration planned. |
| `/pr` | Push the current branch and open a pull request into `main`. Jira integration planned. |
| `/branch <goal>` | Create and switch to a new branch from `main`, named from the goal description. |

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
