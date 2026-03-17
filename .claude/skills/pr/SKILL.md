---
name: pr
description: Push the current branch and open a pull request into main
user-invocable: true
disable-model-invocation: true
allowed-tools:
  - Bash(git status:*)
  - Bash(git branch:*)
  - Bash(git push:*)
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(gh pr create:*)
  - Bash(gh pr view:*)
---

## Your Task

Push the current branch to origin and open a pull request targeting `main`.

## Rules

- Never run on `main` directly — stop and tell the user if they are on `main`
- Never force push
- Check for an existing open PR before creating a new one (`gh pr view`) — if one exists, print the URL and stop
- No `Co-authored-by` lines
- No Jira ticket link yet — will be added when Jira integration is configured

## PR Body Format

```
## Summary
- <bullet summarizing what changed>
- <bullet summarizing why>

## Test plan
- [ ] <manual or automated check>
- [ ] <edge case or regression to verify>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Steps

1. Run `git branch` to confirm you are not on `main`; abort if you are
2. Run `gh pr view` to check for an existing open PR; if found, print the URL and stop
3. Run `git log main..HEAD --oneline` and `git diff main...HEAD` to understand all commits in this branch
4. Draft the PR title (≤70 chars, conventional style: `type(scope): description`) and body
5. Show the draft to the user and wait for confirmation before proceeding
6. Run `git push -u origin <branch>` if the branch is not yet on remote
7. Run `gh pr create` with the confirmed title and body using a HEREDOC
8. Print the PR URL
