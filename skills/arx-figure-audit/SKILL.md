---
name: arx-figure-audit
description: Figure/table auditor (called by arx-paper-review).
allowed-tools: Read, Grep, Glob, Bash
---

# Figure / Table / Diagram Audit

Audit the quality of all figures, tables, and diagrams in an academic paper. This skill is **advisory only** -- it does not own any score axis. Its output feeds into the meta-review as supplementary quality information.

## Input

- Paper text (LaTeX source files or plain text sections)
- Figure/table source files (PDF, PNG, SVG, draw.io, etc.)
- `$ARGUMENTS`: `[paper_path] [--figures-dir <path>]`

## Output

Write `figure_audit_report.md` to the review output directory.

## Score Ownership

None. This skill is advisory. Its findings feed into `/arx-meta-review` as supplementary input.

## Blocker Ownership

None. This skill does not own any blockers.

---

## Design Requirements

See `references/design-requirements.md` for the full design requirements including anti-AI patterns checklist, color/contrast rules, font requirements, line width coefficients, legend rules, and golden ratio guidance.

Key principles (quick reference):
- **Anti-AI**: no gradients, no drop shadows, no glass effects, accent colors <= 3
- **WCAG contrast**: text >= 4.5:1, large text >= 3:1, non-text >= 3:1
- **Fonts**: one sans-serif, minimum 8pt at print size, edge labels >= 14px bold
- **Legend**: required for every figure using color/line style/symbols

---

## draw.io Editing Rules

### NEVER (Geometry Guard)

When editing `.drawio` files (especially programmatic XML edits):

- **NEVER** change `mxGeometry` x, y coordinates
- **NEVER** change `mxPoint` coordinates
- **NEVER** change connector (edge) waypoints
- **NEVER** change `source` / `target` attributes on edges

Violating these breaks connector routing and destroys layouts.

### Safe Changes

Only modify `style=""` attribute properties:

- `fontColor`, `strokeColor`, `fillColor`
- `strokeWidth`, `fontSize`, `fontStyle`
- `rounded`, `dashed`, `opacity`

Also safe: `value=""` (text content), `pageWidth`/`pageHeight` (canvas size only).

### Layer Structure (Recommended)

| Layer | Lock | Purpose |
|-------|------|---------|
| Background | LOCKED | Background, frames |
| Nodes | Editable | Shapes, boxes |
| Connectors | Editable | Arrows, lines |
| Annotations | Editable | Labels, legend |

Lock completed sections to prevent accidental edits.

### Connector Rules

- Connectors must snap to connection points (no free-floating endpoints)
- Arrow style changes via `style` attribute only

### Math Rendering (LaTeX/MathJax)

- Enable: `math="1"` on `mxGraphModel`
- Use `\(\large ...\)` for inline math (without `\large`, formulas render smaller than surrounding text)
- Add blank lines (`&#xa;`) between math and text for spacing

### Export Settings

| Format | Recommendation |
|--------|---------------|
| PDF | Preferred for vector diagrams |
| PNG | Enable "Include a copy of my diagram"; >= 300 DPI |
| SVG | Use "Embed Fonts" or "Convert labels to SVG" |

---

## matplotlib / Python Figures

### Style Consistency

- Use a shared style file or `rcParams` block across all figures in the paper
- Consistent font family and sizes matching the paper body
- Consistent color palette matching draw.io figures

### Recommended rcParams

```python
plt.rcParams['font.family'] = 'sans-serif'  # Match paper font
plt.rcParams['font.size'] = 10
plt.rcParams['axes.labelsize'] = 11
plt.rcParams['axes.titlesize'] = 12
plt.rcParams['legend.fontsize'] = 10
```

### Figure Size

- **IEEE two-column**: single-column ~3.5in wide, double-column ~7.16in wide
- **ACM two-column**: similar constraints
- Set `figsize` explicitly; do not rely on defaults
- Standard aspect ratios: 4:3, 16:9, or golden ratio

### Colormap

- **Sequential**: `viridis` (colorblind-safe, perceptually uniform)
- **Diverging**: `coolwarm` or `RdBu`
- **Categorical**: use the paper's accent palette (max 3 colors for consistency)
- Background shading: alpha=0.1-0.2 only

---

## Figure Creation Workflow (3-Phase)

When creating new figures, follow this iterative workflow:

### Phase 1: Style Exploration

- Generate 3-5 color/style variants on the same layout
- Only change `strokeColor`, `fontColor`, `fillColor` (no geometry changes)
- Validate: accent colors <= 3, WCAG contrast met, no anti-AI patterns

### Phase 2: Layout Exploration

- Using the selected style, generate 3-5 layout variants
- Validate: all required elements present, terminology matches paper text, logical structure correct

### Phase 3: Refinement Iteration

- Iteratively refine based on feedback
- Generate 3-4 options per issue for user selection
- Final validation: PDF export, print readability, cross-figure consistency

### Self-Critique Checkpoints

| After | Verify |
|-------|--------|
| Phase 1 | Accent colors <= 3, geometry unchanged, anti-AI pass |
| Phase 2 | All required elements present, terminology matches paper |
| Phase 3 | PDF renders correctly, print-readable, figures consistent |

---

## Audit Checklist

See `references/audit-checklist.md` for the full audit checklist covering:
- **Figures** (7 checks): caption self-containedness, label readability, color accessibility, figure-text linkage, axis/scale, legend completeness, VLM-style assessment
- **Tables** (5 checks): caption position, alignment/formatting, significant digits, units, caption quality
- **Diagrams** (7 checks): geometry integrity, layer organization, export quality, font consistency, visual hierarchy, anti-AI patterns, color usage
- **IEEE two-column specifics**: column width constraints, caption placement, IEEEtran.cls compatibility

## Output Format

```markdown
# Figure Audit Report: [Paper Title]

## Summary

- Total figures: N
- Total tables: N
- Total diagrams: N
- Issues found: N (X critical, Y major, Z minor)

## Figure Audit

### Figure N: [caption excerpt]

| Check | Status | Notes |
|-------|:------:|-------|
| Caption self-contained | PASS/FAIL | ... |
| Labels readable at print | PASS/FAIL | ... |
| Color accessibility | PASS/FAIL | ... |
| Referenced in text | PASS/FAIL | ... |
| Axes labeled with units | PASS/FAIL | ... |
| Legend complete | PASS/FAIL | ... |
| VLM assessment | SELF-EXPLANATORY/NEEDS-CONTEXT/UNCLEAR | ... |

**Overall**: N/7 checks passed
**Severity**: NONE / MINOR / MAJOR / CRITICAL

### Figure M: ...

## Table Audit

### Table N: [caption excerpt]

| Check | Status | Notes |
|-------|:------:|-------|
| Caption position | PASS/FAIL | ... |
| Alignment | PASS/FAIL | ... |
| Significant digits | PASS/FAIL | ... |
| Units in headers | PASS/FAIL | ... |
| Caption quality | PASS/FAIL | ... |

**Overall**: N/5 checks passed
**Severity**: NONE / MINOR / MAJOR / CRITICAL

## Diagram Audit (if draw.io or architecture figures present)

### Diagram N: [description]

| Check | Status | Notes |
|-------|:------:|-------|
| Geometry integrity | PASS/FAIL/N/A | ... |
| Layer organization | PASS/FAIL | ... |
| Export quality | PASS/FAIL | ... |
| Font consistency | PASS/FAIL | ... |
| Visual hierarchy | PASS/FAIL | ... |
| Anti-AI patterns | PASS/FAIL | ... |
| Color usage | PASS/FAIL | ... |

**Overall**: N/7 checks passed

## Cross-Figure Consistency

- Color palette consistent across figures: YES/NO
- Font sizes consistent across figures: YES/NO
- Style consistent (all figures look like they belong to the same paper): YES/NO
- Anti-AI patterns clean across all figures: YES/NO

## Top Issues (prioritized)

1. [Most impactful issue with figure/table reference]
2. [Second most impactful issue]
3. ...
```

## Iteration Policy

- **1 round only** (single-pass audit)
- This skill does not iterate. Its findings are consumed by the meta-reviewer.

## Review Depth

This skill operates in **analytical mode** by default. Assessments must go beyond checklist verification to evaluate whether figures effectively communicate the paper's message.

## Hard Rules

- Do NOT suggest redesigning figures unless there is a clear readability or correctness issue.
- Do NOT penalize stylistic choices that are venue-appropriate.
- Every finding must reference a specific figure, table, or diagram by number.
- Distinguish between "incorrect" (data mismatch, wrong labels) and "suboptimal" (could be better but not wrong).
- If source files are not available (only compiled PDF), note limited audit scope for diagram internals.
- When editing draw.io XML: NEVER touch geometry/coordinates; style attributes ONLY.
