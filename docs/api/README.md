# Logixian API Spec

This directory contains the design-first OpenAPI specification for the Logixian integration API.

| File | Description |
|------|-------------|
| `logixian-integration.yaml` | Top-level integration contract (IRA-89) |

## Viewing the Spec

### Option 1: Swagger Editor (online, zero setup)

1. Go to [editor.swagger.io](https://editor.swagger.io)
2. **File > Import file** and select `logixian-integration.yaml`
3. The spec renders with interactive docs on the right panel

### Option 2: Swagger UI (local Docker, recommended)

```bash
docker run -p 8080:8080 \
  -e SWAGGER_JSON=/spec/logixian-integration.yaml \
  -v $(pwd)/docs/api:/spec \
  swaggerapi/swagger-ui
```

Open [http://localhost:8080](http://localhost:8080).

### Option 3: Redocly (local, best-looking output)

```bash
npx @redocly/cli preview-docs docs/api/logixian-integration.yaml
```

Opens a browser at `http://127.0.0.1:8080` with Redocly's three-panel view.

To generate a static HTML file:

```bash
npx @redocly/cli build-docs docs/api/logixian-integration.yaml -o docs/api/index.html
```

### Option 4: VS Code Extension

Install [OpenAPI (Swagger) Editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi) (also available in Cursor):

1. Open `logixian-integration.yaml`
2. Click the preview icon in the top-right corner (or `Cmd+Shift+P` > "OpenAPI: Show Preview")

### Option 5: Stoplight Studio (desktop app)

1. Download [Stoplight Studio](https://stoplight.io/studio)
2. Open the project directory
3. Navigate to the YAML file — renders with form-based editor + preview

## Linting

To validate the spec against OpenAPI rules:

```bash
npx @redocly/cli lint docs/api/logixian-integration.yaml
```

## FastAPI Integration

When we implement the FastAPI server, this spec serves as the design contract.
FastAPI generates its own OpenAPI schema at runtime (`/openapi.json`). To verify
alignment between the design spec and the implementation:

```bash
# Export FastAPI's generated spec
curl http://localhost:8000/openapi.json > generated.json

# Compare (requires openapi-diff)
npx openapi-diff docs/api/logixian-integration.yaml generated.json
```
