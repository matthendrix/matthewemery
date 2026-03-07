# GitHub Pages Export

Keep this repository private if you want `docs/`, planning notes, and legacy materials to stay off the public internet. Publish the website from a separate public GitHub Pages repository that contains only the deployable site files.

## Public files

The export workflow copies only:

- `index.html`
- `styles.css`
- `this.jpg`

## Export command

Run the export into a separate checkout of your public Pages repository:

```powershell
& '.\scripts\export-pages.ps1' -Destination 'C:\path\to\your-public-pages-repo'
```

After the export:

1. Review the public repo working tree.
2. Commit the copied site files in the public repo.
3. Push from the public repo when you are ready to publish.

## Why this workflow

- Private source repo keeps notes, docs, and backups out of the public site repo.
- Public Pages repo stays minimal and deployable.
- Export is allow-listed, so internal repo files are not copied by mistake.
