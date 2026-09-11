# lzc-papra

Lazycat NAS `.lpk` wrapper for [Papra](https://github.com/papra-hq/papra), a minimalistic document management and archiving platform.

Replaces the third-party store package `xyz.mxue.papra` (stuck at Papra 0.2.0, April 2025).

## Architecture

```
Browser ──HTTPS──▶ Lazycat OIDC reverse proxy ──▶ papra:1221 (/app/app-data ⇄ /lzcapp/var/app-data)
```

Single service, upstream image `ghcr.io/papra-hq/papra:<version>-root` mirrored on `registry.lazycat.cloud` and referenced via `embed:papra` (LPK v2, metadata-only embed, layers pulled at install time).

The `-root` variant is used because Lazycat runs every container as root regardless of the image `USER`.

## AUTH_SECRET

Papra refuses to start without a secret of at least 32 chars. The manifest cannot generate one, so `setup_script` writes `/app/app-data/papra.config.yaml` with a random `auth.secret` on first start and leaves it alone afterwards. The file lives in the persistent bind, so sessions survive restarts and upgrades.

## Data layout (`/lzcsys/data/appvar/cloud.lazycat.app.papra/app-data` on the box)

| Path | Content |
|------|---------|
| `db/db.sqlite` | SQLite database |
| `documents/` | uploaded files |
| `papra.config.yaml` | generated auth secret, plus any override you add |

## Ingestion folder

The package declares `document.private`, so Lazycat mounts the app's private documents at `/lzcapp/documents/<uid>`, which the file manager shows as **Documents → .apps → cloud.lazycat.app.papra**. `setup_script` links that folder to `/app/ingestion` and the watcher is on.

Create a subfolder named after your organization id (from the app URL, `/organizations/org_xxx`) and drop files in it: Papra imports them into that organization, then deletes them (`INGESTION_FOLDER_POST_PROCESSING_STRATEGY=delete` upstream default; failures go to `ingestion-error/`). Single-instance app: the first uid under `/lzcapp/documents` is used.

## Upgrade to a new upstream version

```bash
# 1. mirror the new image (from PowerShell / PS interop)
lzc-cli appstore copy-image ghcr.io/papra-hq/papra:<version>-root
# 2. put the printed registry.lazycat.cloud/... ref into docker/papra/Dockerfile
# 3. bump version in papra-lzc/package.yml to <version>
# 4. build + install
cd papra-lzc && lzc-cli project build
lzc-cli app install cloud.lazycat.app.papra-v<version>.lpk
```

Papra runs its DB migrations on start (`pnpm start:with-migrations`).

## Commands

```bash
lzc-cli app status cloud.lazycat.app.papra
lzc-cli docker logs cloudlazycatapppapra-papra-1
lzc-cli app uninstall cloud.lazycat.app.papra   # destroys /lzcapp/var/app-data
```

## License

Wrapper: MIT. Papra: AGPL-3.0 (https://github.com/papra-hq/papra/blob/main/LICENSE).
