# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Personal website — `matthewemery.com.au` v2. A deliberately minimal single-page art piece: one image, centred composition, dark background. Aesthetic restraint is intentional and should be preserved.

## Commands

```bash
npm run dev       # Start Vite dev server
npm run build     # Production build → dist/
npm run preview   # Preview production build locally
```

No test suite. No linting setup.

## Architecture

This is a vanilla JS single-page app built with Vite. No framework.

- `index.html` — root shell; mounts `#app` and loads `src/main.js`
- `src/main.js` — sets `app.innerHTML` directly; renders the full composition
- `src/styles.css` — all styles; uses `clamp()` for fluid sizing, mobile breakpoint at 720px
- `public/this.jpg` — the primary image asset (served at `/this.jpg`)
- `dist/` — Vite build output; not committed
- `legacy/` — frozen v1 PHP site (`legacy/public_html/`). Read-only reference. Do not modify.
- `docs/plans/` — design and implementation decision records

## Key Constraints

- Keep the composition minimal. The design is intentional, not incomplete.
- `legacy/` is reference material only — treat it as immutable.
- No framework, no build complexity beyond Vite defaults. No `vite.config.js` exists unless needed.
- The image (`/this.jpg`) must load with `fetchpriority="high"` and `decoding="async"`.
