---
name: commit
description: Stage and commit changes following logixian-agents conventional commit conventions
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash(git add:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git commit:*)
---

## Your Task

Stage all relevant changes and create a conventional commit. Always draft the commit message first and wait for user approval before committing.

## Commit Format

```
<type>(<scope>): <short description>
```

- **type**: `feat` | `fix` | `chore` | `refactor` | `docs` | `test`
- **scope** (optional): `skills` | `config` | `docs` | or any meaningful module name
- **description**: imperative mood, lowercase, no trailing period, ≤72 chars

Examples:
```
feat(skills): add branch skill scaffold
fix(config): correct allowed-tools list in commit skill
docs: update README with skill usage
chore: remove unused prompt-coach draft files
```

## Rules

- Never commit `.env` or secrets
- No `Co-authored-by` lines
- No Jira ticket prefix yet — will be added when Jira integration is configured
- Scope is optional; omit if the change is truly cross-cutting

## Steps

1. Run `git status` to see what is changed
2. Run `git diff` (and `git diff --cached` if anything is already staged) to read the changes
3. Draft the commit message based on the format above
4. Show the draft to the user:
   ```
   Proposed commit:

     <type>(<scope>): <description>

   Stage and commit? (yes / edit / cancel)
   ```
5. Wait for user confirmation before proceeding
6. If the user says "edit", apply their correction and re-show the draft
7. On confirmation, stage the relevant files (`git add <files>`) and commit using a HEREDOC:
   ```
   git commit -m "$(cat <<'EOF'
   <message>
   EOF
   )"
   ```
8. Run `git status` to confirm the working tree is clean
