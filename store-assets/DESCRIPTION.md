# Store Descriptions (English)

## Short description (1 line)

> Minimalistic, self-hosted document management and archiving: upload, tag, search and share your documents from your NAS.

## Extended description

**Papra** is a minimalistic document management and archiving platform, designed to be simple and usable by everyone. Think of it as a digital archive for your long-term documents: invoices, contracts, receipts, certificates.

### What you can do

- **Upload anything** — PDF, images, office files; drag and drop or via the API/CLI
- **Full-text search** — content is extracted (OCR for images and scanned PDFs)
- **Tags and tagging rules** — organise automatically by content or filename
- **Organizations** — separate archives for family, business, projects; invite members
- **Sharing links** — password-protected, expiring links to single documents
- **Trash with retention** — deleted documents are kept 30 days before hard delete
- **Ingestion folder, webhooks, API keys, mobile app** — optional integrations

### Why this build

- **Always the current upstream release** — pinned to an immutable image digest
- **Persistent storage** — database, documents and config in `/lzcapp/var/app-data`
- **Zero setup** — the auth secret is generated automatically on first start
- **Open source** — AGPL-3.0 upstream, MIT wrapper

### Access model

Lazycat OIDC sits in front of the app; Papra has its own accounts on top (create yours at first visit, then disable registration via `auth.isRegistrationEnabled: false` in `papra.config.yaml` if you want).

### Resources

- Upstream project: https://github.com/papra-hq/papra
- Documentation: https://docs.papra.app
- Wrapper repo: https://github.com/f-liva/lzc-papra
