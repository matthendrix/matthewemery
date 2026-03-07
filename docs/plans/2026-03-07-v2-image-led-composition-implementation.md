# V2 Image-Led Composition Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refine the current v2 SPA into a single full-screen image-led composition that shows only `this.jpg` on first load.

**Architecture:** The active image is moved into the Vite app's public asset surface so the composition no longer depends on archived paths. The page remains a one-screen SPA with a single mounted composition, and CSS does most of the work through layout, scale, spacing, and restrained motion.

**Tech Stack:** Vite, HTML, CSS, Vanilla JavaScript

---

### Task 1: Promote the Active Image Into V2 Assets

**Files:**
- Create: `public/this.jpg`
- Keep: `legacy/public_html/this.jpg`
- Modify: `src/main.js`

**Step 1: Confirm the current image source**

Run: `Get-Content 'C:\matt\WEBSITES\matthewemery.com.au\src\main.js'`
Expected: the image currently points to `/legacy/public_html/this.jpg`.

**Step 2: Copy the active image into the public asset folder**

Run: `Copy-Item 'C:\matt\WEBSITES\matthewemery.com.au\legacy\public_html\this.jpg' 'C:\matt\WEBSITES\matthewemery.com.au\public\this.jpg' -Force`
Expected: `public/this.jpg` exists and `legacy/public_html/this.jpg` remains unchanged.

**Step 3: Update the app to load the active image from `public/`**

Change `src/main.js` so the rendered image source becomes `/this.jpg`.

**Step 4: Verify the change**

Run: `npm run build`
Expected: successful build with the app now using the public asset.

**Step 5: Commit**

```bash
git add public/this.jpg src/main.js
git commit -m "feat: promote active image into v2 assets"
```

### Task 2: Refine the Composition Layout

**Files:**
- Modify: `src/main.js`
- Modify: `src/styles.css`

**Step 1: Keep the markup intentionally minimal**

Update `src/main.js` so it renders only the composition shell and image wrapper, with no visible text and no extra interface elements.

**Step 2: Adjust the composition styling**

Update `src/styles.css` to create a more deliberate full-screen image composition:
- controlled viewport centering
- generous but intentional padding
- image max-height and width rules for desktop and mobile
- dark background field
- subtle entrance motion only

**Step 3: Guard against layout collapse**

Ensure the layout still renders as a stable dark field if the image is slow to load or unavailable.

**Step 4: Verify visually and with build**

Run: `npm run build`
Expected: build passes.

Run: `npm run dev`
Expected: page serves locally and the first load shows only the image.

**Step 5: Commit**

```bash
git add src/main.js src/styles.css
git commit -m "feat: refine image-led v2 composition"
```

### Task 3: Final Verification

**Files:**
- Verify: repository working tree
- Verify: built output

**Step 1: Re-run the production build**

Run: `npm run build`
Expected: successful Vite build.

**Step 2: Check repository status**

Run: `git -C 'C:\matt\WEBSITES\matthewemery.com.au' status --short`
Expected: no unexpected uncommitted files.

**Step 3: Confirm the legacy snapshot still exists**

Run: `Get-ChildItem 'C:\matt\WEBSITES\matthewemery.com.au\legacy\public_html' -Force | Select-Object Name,Length`
Expected: legacy image and legacy page files remain intact.
