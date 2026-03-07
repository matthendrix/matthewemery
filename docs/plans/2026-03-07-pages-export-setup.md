# GitHub Pages Export Setup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a safe export workflow that copies only the public static site files from this private source repo into a separate GitHub Pages repo or folder.

**Architecture:** A PowerShell export script will copy an allow-listed set of deployable files from the repo root into a user-supplied destination folder. A verification script will exercise that export into a temporary directory and fail unless only the approved public files are produced and their contents match the source files.

**Tech Stack:** PowerShell, static HTML/CSS assets

---

### Task 1: Add Verification First

**Files:**
- Create: `tests/export-pages.check.ps1`

**Step 1: Write the failing verification script**

Create a PowerShell check that:
- creates a temporary destination directory
- runs `scripts/export-pages.ps1` against that directory
- asserts the destination contains exactly `index.html`, `styles.css`, and `this.jpg`
- asserts `docs/`, `legacy/`, `AGENTS.md`, and `CLAUDE.md` are absent
- asserts copied files match source file hashes

**Step 2: Run the verification before implementation**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\export-pages.check.ps1`
Expected: FAIL because `scripts/export-pages.ps1` does not exist yet.

### Task 2: Implement the Export Script

**Files:**
- Create: `scripts/export-pages.ps1`

**Step 1: Add a destination-driven export script**

Implement a PowerShell script that:
- requires `-Destination`
- resolves the repository root from the script location
- creates the destination directory if missing
- copies only `index.html`, `styles.css`, and `this.jpg`
- removes any stale copies of those three files before recopying
- prints a concise exported file list

**Step 2: Re-run verification**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\export-pages.check.ps1`
Expected: PASS

### Task 3: Document the Workflow

**Files:**
- Create: `docs/github-pages-export.md`
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

**Step 1: Add a short operator doc**

Document:
- why the repo should stay private
- why the public Pages repo should contain only exported files
- how to run the export script into a separate checkout

**Step 2: Update repo guidance**

Mention the export script and two-repo workflow in `AGENTS.md` and `CLAUDE.md`.

### Task 4: Final Verification

**Files:**
- Verify: script outputs
- Verify: git status

**Step 1: Run the verification script again**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\export-pages.check.ps1`
Expected: PASS

**Step 2: Verify working tree**

Run: `git status --short`
Expected: only the new workflow files and doc updates are present before commit.
