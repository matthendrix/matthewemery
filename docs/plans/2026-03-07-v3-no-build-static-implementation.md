# V3 No-Build Static Composition Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Convert the current v2 composition into a plain static HTML/CSS site with no JavaScript and no build process.

**Architecture:** The composition markup moves directly into `index.html`, and the active stylesheet becomes a root-level `styles.css`. The active image is flattened to the repo root so the page can render directly from static files, while all app tooling and generated structure are removed after verification.

**Tech Stack:** HTML, CSS

---

### Task 1: Flatten the Active Composition Into Static Files

**Files:**
- Modify: `index.html`
- Create: `styles.css`
- Create: `this.jpg`
- Keep: `public/this.jpg`
- Reference: `src/main.js`
- Reference: `src/styles.css`

**Step 1: Inspect the current rendered structure**

Run: `Get-Content 'C:\matt\WEBSITES\matthewemery.com.au\src\main.js'`
Expected: the current composition markup is visible in the JS template string.

**Step 2: Copy the active image to the root**

Run: `Copy-Item 'C:\matt\WEBSITES\matthewemery.com.au\public\this.jpg' 'C:\matt\WEBSITES\matthewemery.com.au\this.jpg' -Force`
Expected: root-level `this.jpg` exists.

**Step 3: Write the composition directly into `index.html`**

Replace the current Vite shell with static HTML that includes the composition markup and links `styles.css` directly.

**Step 4: Move the active styling into root `styles.css`**

Create `styles.css` using the current composition rules from `src/styles.css`.

**Step 5: Commit**

```bash
git add index.html styles.css this.jpg
git commit -m "feat: flatten composition into static html and css"
```

### Task 2: Remove JavaScript and Build Structure

**Files:**
- Delete: `src/main.js`
- Delete: `src/styles.css`
- Delete: `package.json`
- Delete: `package-lock.json`
- Delete: `.gitignore`
- Delete: `.gitattributes` only if still useful solely for the old setup
- Delete: `public/this.jpg` only after root asset is verified
- Delete: `tests/v2-composition.check.mjs`
- Delete: empty directories such as `src/` and `public/`

**Step 1: Remove active JS and build-tool files**

Delete the Vite-era source and dependency files that are no longer needed for a static page.

**Step 2: Keep only files that still have value**

Retain `.gitattributes` if you still want line-ending normalization for the repo overall. Remove `.gitignore` if it only exists to ignore build artefacts that no longer apply.

**Step 3: Verify the repository shape**

Run: `Get-ChildItem 'C:\matt\WEBSITES\matthewemery.com.au' -Force | Select-Object Name`
Expected: the root is flat and centered on `index.html`, `styles.css`, `this.jpg`, `legacy/`, `docs/`, `AGENTS.md`, and `CLAUDE.md`.

**Step 4: Commit**

```bash
git add -A
git commit -m "chore: remove v2 app tooling for v3 static site"
```

### Task 3: Update Repository Notes

**Files:**
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

**Step 1: Update contributor guidance**

Change `AGENTS.md` so it documents the static no-build setup and root-level file structure.

**Step 2: Update local agent notes**

Change `CLAUDE.md` so it reflects the v3 architecture, commands, and constraints with no build process or JavaScript.

**Step 3: Commit**

```bash
git add AGENTS.md CLAUDE.md
git commit -m "docs: update notes for v3 static architecture"
```

### Task 4: Final Verification

**Files:**
- Verify: repository working tree
- Verify: static page assets

**Step 1: Open the static page directly**

Open `C:\matt\WEBSITES\matthewemery.com.au\index.html` in a browser.
Expected: the composition renders correctly without JavaScript.

**Step 2: Verify no JavaScript dependency remains**

Run: `Select-String -Path 'C:\matt\WEBSITES\matthewemery.com.au\index.html','C:\matt\WEBSITES\matthewemery.com.au\styles.css' -Pattern '<script|type="module"|src/main.js|import '`
Expected: no matches.

**Step 3: Verify final Git status**

Run: `git -C 'C:\matt\WEBSITES\matthewemery.com.au' status --short`
Expected: no unexpected uncommitted changes.

**Step 4: Verify legacy snapshot remains intact**

Run: `Get-ChildItem 'C:\matt\WEBSITES\matthewemery.com.au\legacy\public_html' -Force | Select-Object Name,Length`
Expected: original legacy files are still present.
