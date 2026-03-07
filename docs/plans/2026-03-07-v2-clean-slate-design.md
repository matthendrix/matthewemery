# V2 Clean Slate Design

**Date:** 2026-03-07
**Risk:** Safe

## Objective
Create version two of `matthewemery.com.au` as a deliberately minimal single-page art piece while preserving version one intact for reference.

## Current State
The repository currently contains a tiny PHP site in `public_html/` plus historical assets in `_archive/`. The live experience is intentionally sparse: one page, one image, very little structure.

## Decision
Preserve the current site as a frozen legacy snapshot and start v2 from a clean frontend app structure.

## Chosen Approach
Move the current legacy folders into a new top-level `legacy/` directory:
- `legacy/public_html/`
- `legacy/_archive/`

Then create a fresh Vite-based single-page app at the repository root for v2.

## Why This Approach
- Keeps v1 fully accessible and reversible.
- Creates a hard separation between legacy material and new work.
- Avoids mixing old PHP-era files with the new frontend structure.
- Keeps deployment options open because the new app can compile to static assets.

## V2 Stack
- Vite
- HTML
- CSS
- Vanilla JavaScript

## Initial Scope
- No aesthetic redesign yet.
- Preserve the current minimal tone.
- Focus first on clean repository structure and modern app baseline.

## Proposed Repository Shape
```text
legacy/
  _archive/
  public_html/

docs/plans/
public/
src/
index.html
package.json
vite.config.js
```

## Constraints
- Do not redesign the piece during migration.
- Keep diffs reversible.
- Treat `legacy/` as reference material, not active app code.

## Validation
- Confirm the legacy files exist unchanged under `legacy/`.
- Confirm the new app boots locally with Vite.
- Confirm the repository root is cleanly organized around v2.
