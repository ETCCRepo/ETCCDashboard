# Project: ETCC Dashboard

This project uses standard prompts stored in "Z:\Backup\Websites\Web Utilities\StandardPrompts.md"

## What This App Does

A browser-based landing page for East Tennessee Corvette Club members to select and launch ETCC web applications. Deployed at `https://etccapps.com` (root index.html). Runs entirely in the browser with no backend.

---

## File Structure

```
index.html      — Entire application (single-page SPA, all JS inline)
test.html       — Regression test suite (15 tests via fetch + DOMParser)
ETCClogo.png    — ETCC logo used in header and hero
Claude.md       — This file
README.md       — Minimal placeholder
.claude/
  launch.json   — Preview server config (autoPort: true)
```

---

## Architecture

- **Single HTML file** — all styles, markup, and JS inline in `index.html`
- **No backend, no database** — purely static, no localStorage needed
- Deployed to Hostinger as the root `index.html` at `etccapps.com`

---

## Navigation / Pages

Two pages shown/hidden with `.page` / `.page.active`:

| Page ID         | Route         | Access         |
|-----------------|---------------|----------------|
| `page-home`     | Default       | Public          |
| `page-settings` | Settings nav  | Password-gated  |

Navigation via left sidebar (240px, `var(--sidebar-w)`), triggered by hamburger button in header. Sidebar slides in over content with a dark overlay; clicking overlay closes it.

---

## App Cards

| Card | Status | Link |
|------|--------|------|
| Silent Auction Manager | Live (`badge-live`) | `https://etccapps.com/apps/sam` |
| Other Apps Coming Soon | Coming Soon (`badge-soon`) | None (`.coming-soon` class disables hover/link) |

Cards use `.app-card` class. Live cards are `<a>` elements; coming-soon cards are `<div>`.

---

## Settings Page

- Accessed via the Settings nav item in the sidebar
- Password-protected: clicking Settings opens `#pwModal` password modal
- Password constant: `SETTINGS_PW` in index.html (do not log or expose)
- On success: `showPage('settings')` is called
- Settings page contains one card: **Regression Test** — runs `runRegressionTest()` against live DOM

---

## Regression Tests

- **In-browser (Settings page):** `runRegressionTest()` in `index.html` — 15 tests against `document` (live DOM). Results shown in `#test-results` table.
- **Standalone file:** `test.html` — fetches `index.html` via `fetch()`, parses with `DOMParser`, runs same 15 tests. Works both locally (via dev server) and deployed. Does NOT use an iframe (cross-origin issues on `file://`).
- Run locally: open `http://localhost:<port>/test.html` via preview server
- Run deployed: open `https://etccapps.com/test.html`
- **Always run regression tests before reporting a task complete**

---

## GitHub

- Repo: `ETCCRepo/ETCCDashboard` (GitHub org account)
- Remote URL embeds PAT to authorize pushes (ETCCRepo is not the default git user):
  ```
  https://ETCCRepo:<PAT>@github.com/ETCCRepo/ETCCDashboard.git
  ```
- Local git `user.name` set to `ETCCRepo` for this repo
- Default global git user is `C177LVR` — do not use for ETCCRepo pushes

---

## Deployment

- Host: Hostinger
- URL: `https://etccapps.com` (root — `index.html` served at `/`)
- Deploy via FTP using `deploy.ps1` in the project root (if present), or manual FTP upload
- Always clearly indicate when files have been deployed

---

## Palette

**CSS Variables (defined in `:root`)**
| Variable | Hex | Role |
|---|---|---|
| `--bg` | `#ffffff` | Page background |
| `--bg-section` | `#f5f5f7` | Section / body background |
| `--text` | `#1d1d1f` | Primary text |
| `--text-sec` | `#6e6e73` | Secondary text |
| `--text-ter` | `#86868b` | Tertiary text |
| `--accent` | `#0071e3` | Links, active nav, focus |
| `--accent-hover` | `#0077ed` | Accent hover state |
| `--border` | `#d2d2d7` | Borders, dividers |
| `--nav-bar` | `#1d1d1f` | Header and sidebar background |
| `--danger` | `#c62828` | Error states |
| `--success` | `#1a7f37` | Success states |
| `--etcc-red` | `#c0392b` | ETCC brand red |
| `--etcc-gold` | `#f0a500` | ETCC brand gold (accents, hover) |
| `--etcc-blue` | `#1a56a0` | ETCC brand blue |
| `--sidebar-w` | `240px` | Sidebar width |

> This is the ETCC blue/white/dark palette. Do NOT use the gold/brown HandmadeDesignsBySuzi palette here.

**Table headers:** `background: #dbeafe`, sticky

---

## Standard Rules (from StandardPrompts.md)

- Always read the instructions in `Z:\Backup\Websites\Web Utilities\components\table\readme.md`
- Always read the instructions in `Z:\Backup\Websites\Web Utilities\components\toolbar\readme.md`
- Protect existing working features — do not delete or rewrite large sections unless necessary
- Before coding, identify affected files and possible side effects
- Use the existing project structure and coding style (inline JS in index.html, no frameworks)
- After changes, provide a regression test checklist
- Only commit, push, or deploy when explicitly given a checkpoint command
- When a checkpoint is given: update regression tests, run them, prompt whether to commit and push
- Clearly indicate when a change has been deployed
- Instrument all code by creating an error.log
- Whenever a checkpoint prompt is given with no description, use a good short name
