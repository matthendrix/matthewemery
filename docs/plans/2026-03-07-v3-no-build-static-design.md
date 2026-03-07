# V3 No-Build Static Composition Design

**Date:** 2026-03-07
**Risk:** Safe

## Objective
Prepare version three of `matthewemery.com.au` by removing the app/build layer and returning the project to a plain static web page built from HTML and CSS only.

## Direction
V3 should preserve the current minimal composition while stripping away unnecessary tooling. The project should stop behaving like an app and instead become a direct web artifact: one HTML file, one stylesheet, one image, no JavaScript, and no build process.

## Approved Decisions
- Remove the framework/tooling layer entirely.
- Remove JavaScript entirely.
- Keep the current visual intent unless changed later in a separate design pass.
- Keep `legacy/` untouched as the frozen v1 reference.

## Architecture
The current DOM rendered by `src/main.js` should be written directly into `index.html`. The current CSS should move into a root-level `styles.css`. The active image should become a direct static asset in the root so the site can be opened and served without any build step or runtime dependency.

## Proposed Repository Shape
```text
index.html
styles.css
this.jpg
legacy/
docs/plans/
AGENTS.md
CLAUDE.md
```

## Constraints
- No JavaScript in v3.
- No `package.json`, `package-lock.json`, `node_modules/`, or `dist/` as part of the active setup.
- No Vite-specific structure should remain once migration is complete.
- Preserve the composition-first tone; this is a structural simplification, not an aesthetic reset.

## Validation
- Opening `index.html` directly renders the composition correctly.
- The page requires no build step.
- The repository layout becomes flatter and easier to read.
- `legacy/` remains unchanged.
