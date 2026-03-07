# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Personal website — `matthewemery.com.au` v3. A deliberately minimal single-page static composition: one image, centred composition, dark background. Aesthetic restraint is intentional and should be preserved.

## Commands

```bash
start index.html  # Open the static page directly
```

No build step. No package manager. No test suite. No linting setup.

## Architecture

This is a no-build static site. No framework and no JavaScript.

- `index.html` — complete page markup for the composition
- `styles.css` — all active styling; uses `clamp()` for fluid sizing, mobile breakpoint at 720px
- `this.jpg` — the primary image asset loaded directly from the repo root
- `.src/` — gitignored private folder; contains `legacy/`, `docs/`, `scripts/`, and `tests/` for local reference only

## Deployment

Push to `master` → GitHub Pages serves the site automatically from the repo root.

Public repo: `https://github.com/matthendrix/matthewemery`

## Key Constraints

- Keep the composition minimal. The design is intentional, not incomplete.
- `.src/legacy/` is reference material only — treat it as immutable.
- Do not reintroduce JavaScript, package tooling, or a build process unless explicitly requested.
- The image (`./this.jpg`) must load with `fetchpriority="high"` and `decoding="async"`.
