# Repository Guidelines

## Project Structure & Module Organization
This repository now has two clear zones. Active v2 work lives at the root: `index.html`, `package.json`, `src/main.js`, and `src/styles.css`. Static public assets belong in `public/`. Legacy v1 files are preserved under `legacy/public_html/` and `legacy/_archive/`; treat that directory as read-only reference material unless you are intentionally restoring old content.

## Build, Test, and Development Commands
Install dependencies with:

```bash
npm install
```

Run the local development server with:

```bash
npm run dev
```

Create a production build with:

```bash
npm run build
```

Preview the built site locally with:

```bash
npm run preview
```

## Coding Style & Naming Conventions
Use plain HTML, CSS, and vanilla JavaScript. Keep the composition minimal and avoid adding framework abstractions unless the project direction changes. Follow the existing style in `src/`: small files, direct DOM logic, and readable formatting with consistent indentation. Use lowercase, hyphen-free asset names where possible, and keep file names descriptive.

## Testing Guidelines
There is no automated test suite yet. Minimum verification for each change:

1. Run `npm run build` and confirm it succeeds.
2. Run `npm run dev` and check the page in a browser.
3. Recheck the composition at narrow and wide viewport widths after layout changes.

## Commit & Pull Request Guidelines
Use short imperative commit messages such as `feat: adjust landing composition` or `chore: move legacy assets`. Keep commits focused and reversible. Pull requests should include a concise summary, the commands used for verification, and screenshots or short recordings for visual changes.

## Security & Content Notes
Do not commit secrets, local machine paths, or generated artefacts such as `node_modules/` or `dist/`. Review anything placed in `public/` carefully because it will be shipped as a public asset.
