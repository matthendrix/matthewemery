# Guided Pages Publish Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a guided publish helper in the private repo that exports to the public Pages repo and can optionally stage, commit, and push from one standard command.

**Architecture:** A new PowerShell script will wrap the existing export script and then operate on the public repo checkout with explicit safety checks. A dedicated verification script will create a temporary Git repo and bare remote so the publish helper can be exercised end-to-end without touching the real public repo.

**Tech Stack:** PowerShell, Git, static HTML/CSS assets

---

### Task 1: Add Verification First

**Files:**
- Create: `tests/publish-pages.check.ps1`

**Step 1: Write the failing verification script**

Create a PowerShell check that:
- creates a temporary destination repo and a temporary bare remote
- copies or reuses the source public files from the private repo
- runs `scripts/publish-pages.ps1` against the temporary destination
- verifies the destination repo ends with only the public site files
- verifies commit creation and push behavior when explicit flags are used

**Step 2: Run the verification before implementation**

Run: `pwsh -File .\tests\publish-pages.check.ps1`
Expected: FAIL because `scripts/publish-pages.ps1` does not exist yet.

### Task 2: Implement the Guided Publish Script

**Files:**
- Create: `scripts/publish-pages.ps1`

**Step 1: Add the minimal wrapper**

Implement a PowerShell script that:
- defaults the destination to `C:\matt\WEBSITES\matthewemery-pages`
- runs `scripts/export-pages.ps1`
- validates the destination contains a Git repo
- prints `git status -sb`
- supports `-Stage`, `-CommitMessage`, and `-Push`
- stages only when requested
- commits only when requested and a message is provided
- pushes only when requested

**Step 2: Re-run the new verification**

Run: `pwsh -File .\tests\publish-pages.check.ps1`
Expected: PASS

### Task 3: Update Workflow Notes

**Files:**
- Modify: `docs/github-pages-export.md`
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

**Step 1: Document the standard publish command**

Document:
- the default local destination
- the recommended publish command
- the rule that all edits happen in the private repo and the public repo is publish-only

### Task 4: Final Verification

**Files:**
- Verify: script outputs
- Verify: git status

**Step 1: Run both verification scripts**

Run: `pwsh -File .\tests\export-pages.check.ps1`
Run: `pwsh -File .\tests\publish-pages.check.ps1`
Expected: PASS

**Step 2: Verify working tree**

Run: `git status -sb`
Expected: only the new helper script, test, plan docs, and note updates are present before commit.
