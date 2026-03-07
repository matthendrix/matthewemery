# Repository Guidelines

## Project Structure & Module Organization
This repository is a minimal PHP site. Production files live in `public_html/`, with `public_html/index.php` as the main entry point and static assets such as `favicon.ico`, `favicon.gif`, and `this.jpg` beside it. Use `_archive/` only for historical assets; do not reference archived files from production pages unless that is an intentional content restore.

## Build, Test, and Development Commands
There is no build pipeline in this snapshot. Use a local PHP server to preview changes:

```bash
php -S localhost:8000 -t public_html
```

Open `http://localhost:8000` to verify layout and assets. For syntax checks, run:

```bash
php -l public_html/index.php
```

If PHP is not installed locally, validate by opening the site through your normal local web stack.

## Coding Style & Naming Conventions
Keep changes small and preserve the current flat structure. Follow the existing style in `public_html/index.php`: simple PHP/HTML documents, inline CSS only when the page is intentionally self-contained, and readable indentation consistent with the file you are editing. Use lowercase file names for web assets (`favicon.ico`, `this.jpg`) and prefer descriptive names when adding new files.

## Testing Guidelines
No automated test suite is present. Minimum verification is:

1. Run `php -l` on edited PHP files.
2. Load the page locally and confirm assets render correctly.
3. Recheck responsive behavior in a narrow browser width after any HTML or CSS change.

## Commit & Pull Request Guidelines
Git history is not available in this workspace snapshot, so follow standard imperative commit messages such as `Update homepage image markup` or `Tighten body spacing`. Keep commits focused on one change. Pull requests should include a short summary, affected paths, manual verification steps, and screenshots for any visual change.

## Security & Content Notes
Avoid committing secrets, environment-specific paths, or machine-specific config. Because this site is served directly from `public_html/`, review every added file for public exposure before merging.
