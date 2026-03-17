---
name: branch
description: Create and switch to a new branch from main
user-invocable: true
disable-model-invocation: true
allowed-tools:
  - Bash(git status:*)
  - Bash(git checkout:*)
  - Bash(git branch:*)
  - Bash(git diff:*)
  - Bash(git pull:*)
argument-hint: "<goal description>"
---

## Your Task

Create and switch to a new branch from `main`, named from the goal description provided as an argument.

## Branch Naming

Format: `<type>/<kebab-scope>`

- **type**: `feat` | `fix` | `chore` | `refactor` | `docs` | `test`
- **scope**: short kebab-case description derived from the goal (≤4 words)

Examples:
```
feat/jira-integration
fix/commit-skill-tools
docs/readme-skills-table
chore/cleanup-prompt-coach
```

No ticket prefix yet — will be added when Jira integration is configured.

## Steps

1. Derive a branch name from the goal argument using the format above
2. Show the proposed branch name to the user and ask for confirmation before creating it
3. Run `git status` to check for uncommitted changes
   - If changes exist, run `git diff` to inspect them:
     - **Related to the goal** → create the branch directly with `git checkout -b <branch>` (carries changes over; skip step 4). Note this to the user.
     - **Unrelated to the goal** → stop, list the conflicting files, and ask the user to commit, stash, or discard them before continuing. Do NOT stash automatically.
4. _(Clean working tree only)_ Checkout `main` and pull latest: `git checkout main && git pull origin main`
5. Create and switch to the new branch: `git checkout -b <branch>`
6. Confirm success with `git branch`
