# Logixian Agent — Claude Setup

This repo is the AI workflow layer for the Logixian studio project.
It orchestrates context-aware agent configurations across multiple AI providers
(Claude, Gemini, Copilot, etc.) so team members can share optimized setups.

## Available Skills

| Skill | Purpose |
|---|---|
| `/prompt-coach` | Activates the Prompt Coach persona — audits every English prompt for grammar, Chinglish, and engineering precision before executing the task. Designed for non-native English speakers. |
| `/architect [task]` | Activates the System Architect persona — drafts ADRs, reviews system boundaries and API contracts, and posts findings to Confluence. |
| `/pm [task]` | Activates the Project Manager persona — sprint summary, blocker tracking, risk register maintenance via Jira + Confluence. |
| `/commit` | Stage and commit changes following conventional commit conventions (`type(scope): message`). |
| `/pr` | Push the current branch and open a pull request into `main`. |
| `/branch <goal>` | Create and switch to a new branch from `main`, named from the goal description. |

## Getting Started

1. Clone the repo
2. Open it in Claude Code: `claude .`
3. Run `/prompt-coach` to activate the coaching workflow
