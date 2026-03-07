# Guided Pages Publish Design

**Date:** 2026-03-07

**Goal:** Make the two-repo workflow feel like one repeatable command from the private source repo, while keeping publishing separate from authoring.

## Context

The private repo at `C:\matt\WEBSITES\matthewemery.com.au` is the source of truth and backup location. The sibling checkout at `C:\matt\WEBSITES\matthewemery-pages` is the public GitHub Pages repo and should only contain `index.html`, `styles.css`, and `this.jpg`.

That split is correct, but the workflow currently feels messy because publishing requires remembering a separate destination folder and then manually switching mental context into the public repo.

## Options Considered

### 1. Guided publish script in the private repo

Add `scripts/publish-pages.ps1` that:

- defaults to the public repo checkout path
- runs the existing export script
- verifies the destination is a Git repo
- shows public repo status
- optionally stages, commits, and pushes

**Pros:** one standard entry point, preserves the current architecture, keeps edits in one place
**Cons:** some duplication still exists by design

### 2. Export-only wrapper with printed next steps

Add a helper that exports and prints the exact `git` commands to run manually in the public repo.

**Pros:** lower automation risk
**Cons:** still leaves the workflow feeling split and manual

### 3. Full auto-publish with minimal prompts

Add a script that exports, commits, and pushes by default.

**Pros:** fastest
**Cons:** easiest to misuse and hides important deployment steps

## Decision

Choose option 1.

The helper should guide the publish flow from the private repo, but it should not silently push. It should make the public repo state visible and require an explicit commit message and explicit push action.

## Proposed Behavior

- New script: `scripts/publish-pages.ps1`
- Default destination: `C:\matt\WEBSITES\matthewemery-pages`
- Parameters:
  - optional destination override
  - optional commit message
  - switches to auto-stage, auto-commit, and auto-push for scripted use
- Default interactive behavior:
  - export
  - show `git status -sb`
  - ask whether to stage
  - ask whether to commit
  - ask whether to push
- Safety checks:
  - fail if destination is not a Git repo
  - fail if export script is missing
  - fail if push is requested without a commit message when changes need committing

## Testing

Add a PowerShell verification script that exercises the helper against a temporary Git repo with a local bare remote, so the workflow can be validated without touching the real public repo.

## Documentation

Update the repo guidance files to make this the standard publishing workflow:

- `docs/github-pages-export.md`
- `AGENTS.md`
- `CLAUDE.md`
