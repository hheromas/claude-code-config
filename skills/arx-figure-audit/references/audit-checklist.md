# Audit Checklist

## Figures

For each figure in the paper:

### 1. Caption Self-Containedness

- Can a reader understand the figure from caption alone, without reading the body text?
- Does the caption explain all axes, colors, symbols, and abbreviations used?
- Does the caption state the key takeaway or what the reader should observe?

### 2. Label Readability at Print Size

- Are axis labels, tick marks, and legend text legible when printed at the paper's target size (typically two-column, ~3.5 inches wide)?
- Minimum recommended font size: 8pt at final print size
- Are labels cut off or overlapping?

### 3. Color Accessibility

- Is the figure interpretable in grayscale? (Many reviewers print in B&W)
- Are color choices distinguishable for colorblind readers? (Avoid red-green only distinctions)
- Are patterns, markers, or line styles used in addition to color?

### 4. Figure-Text Linkage

- Is the figure referenced in the body text? (Every figure MUST be referenced)
- Is the reference placed near the discussion of the figure's content?
- Does the body text description match what the figure actually shows?

### 5. Axis and Scale

- Are all axes labeled with units?
- Is the scale appropriate (linear vs log, range selection)?
- Are error bars, confidence intervals, or variance indicators shown where applicable?
- Is the origin shown or justified if omitted?

### 6. Legend Completeness

- Are all series/categories in the plot identified in the legend?
- Is the legend positioned to avoid obscuring data?
- Are legend entries ordered logically (e.g., matching the order of appearance in text)?

### 7. VLM-Style Assessment

For each figure, answer: "Could a reviewer understand this figure without reading the paper?"

Rate as:
- **SELF-EXPLANATORY**: Figure + caption sufficient for comprehension
- **NEEDS-CONTEXT**: Figure requires body text for interpretation but is not misleading alone
- **UNCLEAR**: Figure is ambiguous or confusing without extensive body text reference

## Tables

For each table in the paper:

### 1. Caption Position

- **IEEE**: table captions ABOVE the table, figure captions BELOW the figure
- **ACM**: same convention (captions above tables, below figures)
- Verify the venue's specific template requirements

### 2. Alignment and Formatting

- Are numeric columns right-aligned or decimal-aligned?
- Are text columns left-aligned?
- Is the table free of unnecessary gridlines (prefer minimal horizontal rules: `\toprule`, `\midrule`, `\bottomrule`)?

### 3. Significant Digits

- Are values reported to an appropriate number of significant digits?
- Are all values in the same column reported to the same precision?
- Are very small/large numbers formatted readably (scientific notation or scaled units)?

### 4. Units

- Are units stated in column headers, not repeated in every cell?
- Are units consistent within each column?

### 5. Caption Quality

- Does the table caption describe what the table contains?
- Does it note any important conditions or abbreviations?

## Diagrams (draw.io / Architecture Figures)

For draw.io or architectural diagrams:

### 1. Geometry Integrity (draw.io source files)

- Are `mxGeometry` coordinates unmodified from the intended layout?
- Are connector waypoints intact (no broken routing)?
- Are `source`/`target` attributes on edges correct?

### 2. Layer Organization

- Are logical components grouped into layers?
- Are layers named descriptively?
- Is the layer hierarchy consistent with the paper's abstraction levels?
- Is the Background layer locked?

### 3. Export Quality

- PDF export preferred over PNG for vector diagrams (scales without pixelation)
- If PNG is used, is the resolution sufficient (>= 300 DPI)?
- For PNG: "Include a copy of my diagram" enabled for recoverability?
- Are fonts embedded or converted to paths to avoid rendering issues?

### 4. Font Consistency

- Is the font family consistent across all diagram elements?
- Does the diagram font match (or complement) the paper body font?
- Are font sizes consistent for the same hierarchy level?
- Are edge labels >= 14px bold?

### 5. Visual Hierarchy

- Is the information flow direction clear (top-to-bottom, left-to-right)?
- Are primary components visually dominant over secondary elements?
- Are connection lines clear and not tangled?

### 6. Anti-AI Pattern Check

- No gradient fills on shapes?
- No drop shadows used for hierarchy?
- No glass/neumorphism effects?
- Accent colors <= 3?
- Colors encode roles, not decoration?

### 7. Color Usage

- Is the color palette consistent with other figures in the paper?
- Are colors used semantically (same color = same concept across figures)?
- Does the diagram work in grayscale?

## IEEE Two-Column Specifics

When the target venue uses IEEE two-column format:

- Single-column figures: max ~3.5 inches wide (88mm)
- Double-column figures (`figure*`): max ~7.16 inches wide (181mm)
- Verify figure placement does not orphan text
- Check that `\caption` is below figures, above tables
- Ensure `IEEEtran.cls` compatibility (no unsupported packages)
