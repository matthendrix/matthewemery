# Repository Guidelines

## Project Structure & Module Organization
This repository now has two clear zones. Active v3 work is a flat static site at the root: `index.html`, `styles.css`, and `this.jpg`. Legacy v1 files are preserved under `legacy/public_html/` and `legacy/_archive/`; treat that directory as read-only reference material unless you are intentionally restoring old content.

If you publish via GitHub Pages, keep this repo private and export only the public site files into a separate public Pages repo with `scripts/export-pages.ps1`.

## Build, Test, and Development Commands
There is no build step and no dependency install.

```bash
start index.html
```

For a browser check with JavaScript disabled by architecture, open the page directly from disk:

```bash
start C:\matt\WEBSITES\matthewemery.com.au\index.html
```

If you want to serve the static files over HTTP for a secondary check, use any simple local static server, but do not add build tooling back into the repo.

To prepare files for a separate public GitHub Pages repository:

```bash
pwsh -File .\scripts\export-pages.ps1 -Destination C:\path\to\pages-repo
```

The standard publish flow from this private repo is:

```bash
pwsh -File .\scripts\publish-pages.ps1
```

To stage, commit, and push the public repo in one run:

```bash
pwsh -File .\scripts\publish-pages.ps1 -Stage -CommitMessage "Publish site update" -Push
```

## Coding Style & Naming Conventions
Use plain HTML and CSS only. Keep the composition minimal and avoid introducing JavaScript, frameworks, or a build pipeline unless the project direction explicitly changes. Follow the existing root-level file structure, keep formatting readable, and use descriptive lowercase asset names where possible.

## Testing Guidelines
Minimum verification for each change:

1. Open `index.html` directly in a browser and confirm the composition renders.
2. Verify the page still works with JavaScript disabled or unavailable.
3. Recheck the composition at narrow and wide viewport widths after layout changes.
4. If the Pages export workflow changes, run `pwsh -File .\tests\export-pages.check.ps1`.
5. If the guided publish workflow changes, run `pwsh -File .\tests\publish-pages.check.ps1`.

## Commit & Pull Request Guidelines
Use short imperative commit messages such as `feat: flatten site to static html` or `docs: update static site notes`. Keep commits focused and reversible. Pull requests should include a concise summary, the exact verification steps used, and screenshots for visual changes when relevant.

## Security & Content Notes
Do not commit secrets, local machine paths, or generated artefacts. Review any root-level asset carefully because it will ship directly with the site. Preserve `legacy/` untouched unless a task explicitly targets historical content.
Treat the sibling repo at `C:\matt\WEBSITES\matthewemery-pages` as publish-only; edit the site in this private repo.
