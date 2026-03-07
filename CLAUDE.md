# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Personal website — `matthewemery.com.au` v3. A deliberately minimal single-page static composition: one image, centred composition, dark background. Aesthetic restraint is intentional and should be preserved.

## Commands

```bash
start index.html  # Open the static page directly
pwsh -File .\scripts\export-pages.ps1 -Destination C:\path\to\pages-repo  # Export only public site files
```

No build step. No package manager. No test suite. No linting setup.

## Architecture

This is a no-build static site. No framework and no JavaScript.

- `index.html` — complete page markup for the composition
- `styles.css` — all active styling; uses `clamp()` for fluid sizing, mobile breakpoint at 720px
- `this.jpg` — the primary image asset loaded directly from the repo root
- `scripts/export-pages.ps1` — copies only the deployable public files into a separate Pages repo or folder
- `tests/export-pages.check.ps1` — verifies the export allow-list and file integrity
- `legacy/` — frozen v1 PHP site (`legacy/public_html/`). Read-only reference. Do not modify.
- `docs/plans/` — design and implementation decision records
- `docs/github-pages-export.md` — notes for the two-repo private-source/public-pages workflow

## Key Constraints

- Keep the composition minimal. The design is intentional, not incomplete.
- `legacy/` is reference material only — treat it as immutable.
- Do not reintroduce JavaScript, package tooling, or a build process unless explicitly requested.
- The image (`./this.jpg`) must load with `fetchpriority="high"` and `decoding="async"`.
- Keep public deployment separate from this repo when privacy matters; export only the allow-listed site files.
