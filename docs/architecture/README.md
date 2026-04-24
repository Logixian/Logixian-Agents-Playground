# Logixian Architecture Diagrams

This directory contains the [Structurizr DSL](https://docs.structurizr.com/dsl) definitions
for the Logixian Compliance Engine (C4 model).

| File | Description |
|------|-------------|
| `workspace.dsl` | Top-level workspace: Context, Containers, Components, dynamic scenarios, and deployment views |
| `workspace.json` | Auto-generated workspace state (layout, last-used view). Do not edit by hand. |
| `images/` | Exported PNG diagrams (checked in for Confluence embedding) |

## Viewing the Diagrams

### Option 1: Structurizr Lite (local Docker, recommended)

From the repo root:

```bash
docker run -it --rm -p 8080:8080 \
  -v "$(pwd)/docs/architecture":/usr/local/structurizr \
  structurizr/lite
```

Open [http://localhost:8080](http://localhost:8080). Structurizr Lite watches
`workspace.dsl` and reloads on save.

To stop: `Ctrl+C`.

### Option 2: Structurizr CLI (export PNG/SVG without a UI)

```bash
docker run --rm \
  -v "$(pwd)/docs/architecture":/usr/local/structurizr \
  structurizr/cli export -workspace workspace.dsl -format png -output images
```

Outputs `SystemContext.png`, `Containers.png`, `APIServerComponents.png` into `images/`.

### Option 3: Structurizr Online

1. Go to [structurizr.com/dsl](https://structurizr.com/dsl)
2. Paste the contents of `workspace.dsl`
3. Click **Render**

Good for quick review without Docker; no save.

### Option 4: VS Code / Cursor Extension

Install [Structurizr](https://marketplace.visualstudio.com/items?itemName=ciarant.vscode-structurizr)
for DSL syntax highlighting. Live preview still requires Structurizr Lite (Option 1).

## Editing Workflow

1. Start Structurizr Lite (Option 1)
2. Edit `workspace.dsl`
3. Refresh browser — diagrams reload automatically
4. Adjust layout in the UI; Structurizr writes positions to `workspace.json`
5. Re-export PNGs (Option 2) before committing if diagrams changed

## Notes

- `.structurizr/` is Lite's local cache (index, logs, thumbnails). Safe to delete;
  regenerated on next run.
- Commit `workspace.dsl`, `workspace.json`, and `images/`. Ignore `.structurizr/`
  if it grows noisy.
