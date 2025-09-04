# Kothai Workspace (Melos + Flutter)

Monorepo managed by Melos.

## Structure

- `apps/kothai_app`: Host Flutter app
- `packages/core/*`: Core utilities
- `packages/domain/*`: Domain entities & use cases
- `packages/data/*`: Data layer
- `packages/ui/*`: Shared UI
- `packages/features/*`: Feature modules (keyboard, settings)
- `packages/infra/*`: Infra clients (telemetry, remote_config, model_update)

## Getting started

1. Install Melos: `dart pub global activate melos`
2. Ensure Pub cache bin is on PATH (Windows PowerShell):
   `$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"`
3. Bootstrap: `melos bootstrap`
4. Run analyze/tests:
   - `melos analyze`
   - `melos test`
