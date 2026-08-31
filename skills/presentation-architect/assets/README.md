# assets/

This directory is intended to hold example slide PNG images that
illustrate the layouts and compositions documented in
`references/layout-patterns.md` (swimlane, 5-step process, branching
flow, bar chart, line + KPI card, pie chart, 2x2 matrix, etc.).

## Current state

**Text-only.** This initial skill drop does NOT include PNG assets. The
skill functions using the text descriptions and annotations in
`references/layout-patterns.md` alone. PNG examples are future work.

## Convention for future contributions

When adding images:

- **Filename**: `example-<layout-name>-<message-type>.png` in kebab-case.
  Examples:
  - `example-swimlane-role-by-phase.png`
  - `example-process-5step-current-position.png`
  - `example-bar-before-after.png`
  - `example-matrix-2x2-recommended-cell.png`
- **Annotation**: for every PNG added, extend the matching entry in
  `references/layout-patterns.md` with a short `Example: assets/<filename>`
  line and a 2-3 line caption describing:
  - The message shape the example is proving
  - Which composition rule the example demonstrates
  - What NOT to imitate from the example (if anything)

## Why images help (once added)

Text descriptions of "swimlane" or "5-step process" leave enough
ambiguity that models often regress to generic 3-column cards. A single
correct example anchors the layout choice more reliably than prose. Aim
for 8-15 high-quality examples covering the layouts in
`references/layout-patterns.md`.

Do not add decorative images, stock photos, or icons here. Only real
slide compositions that are cited by a layout entry.
