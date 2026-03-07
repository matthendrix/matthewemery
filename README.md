# matthewemery.com.au

Public website repository for `matthewemery.com.au`.

## Structure

- Repo root contains the deployable site: `index.html`, `styles.css`, and `this.jpg`
- `.src/` is gitignored and holds private local-only working material such as docs, scripts, tests, legacy reference files, and worktrees

## Philosophy

- Keep the public site simple and directly versioned at the repo root
- Keep non-public working material out of Git in `.src/`
- Use local or Google Drive backup for `.src/`; use Git history for the public site

## Publish

GitHub Pages serves the site directly from this repository root.
