# V2 Image-Led Composition Design

**Date:** 2026-03-07
**Risk:** Safe

## Objective
Refine v2 into a deliberate single-page composition that remains image-led, using `this.jpg` as the only visible element on first load.

## Direction
The page should function like a quiet image shrine rather than a conventional landing page. It should feel authored through framing, spacing, scale, and restraint, not through interface furniture or marketing copy.

## Approved Decisions
- Use the current v2 SPA baseline.
- Keep `this.jpg` as the dominant visual.
- Show no visible text on first load.
- Use a single full-viewport composition.
- Keep motion minimal and understated.

## Layout And Behavior
The page fills the viewport with a dark field and centers the image in a controlled frame. The composition should feel intentional, with enough breathing room that the image reads as placed rather than merely inserted. On mobile, the image should keep its composed presence rather than collapsing into an awkward thumbnail.

A small entrance motion is acceptable, such as a soft fade-in or gentle settle, but there should be no overt interface effect, no hover gimmick, and no copy competing with the image.

## Implementation Shape
Keep the implementation small:
- `src/main.js` renders one `main` container and one image wrapper.
- `src/styles.css` handles centering, spacing, scale, and subtle motion.
- Move the active image into `public/` so v2 does not depend on `legacy/` paths.

## Constraints
- Do not add navigation, buttons, overlays, or extra sections.
- Do not introduce text on first load.
- Do not redesign the image itself; only redesign its presentation.

## Validation
- `npm run build` succeeds.
- `npm run dev` serves correctly.
- The first screen shows only the image.
- The layout feels stable at desktop and mobile widths.
- The page remains visually minimal and quiet.
