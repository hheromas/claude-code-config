# Design Requirements

## Anti-AI Patterns Checklist

Figures must not look AI-generated. Check for these patterns:

| Pattern | Problem | Fix |
|---------|---------|-----|
| Gradient fills on shapes | AI-generated appearance | Use solid fills only |
| Drop shadows for hierarchy | Dashboard aesthetic | Use line weight and whitespace |
| Glass / neumorphism effects | Decorative excess | Flat design only |
| More than 3 accent colors | Visual noise | Limit to 3 semantic accent colors |
| Color used as decoration | Arbitrary palette | Color must encode a role/meaning |

**10-Second AI Check** (run on every figure):

- No gradient dominating the area?
- Hierarchy expressed by lines and whitespace, not shadows?
- Each color maps to a fixed role (same role = same color)?
- Readable in grayscale print (sufficient contrast)?
- No excessive diagonal lines or crossings (clear flow direction)?
- Accent colors 3 or fewer?

## Color and Contrast

- **Accent colors**: maximum 3 per figure, each with a fixed semantic role
- **Hierarchy**: express with line style (solid/dashed/dotted), whitespace, and nesting -- not color
- **Fill vs Stroke**: prefer stroke (outline) over fill for color; keep fills white or very light
- **Palette**: use a consistent palette across all figures (e.g., Catppuccin, Material, Tol, or venue-specific)
- **WCAG contrast**: text >= 4.5:1, large text/bold >= 3:1, non-text elements (lines, icons) >= 3:1

## Font Requirements

- **Consistent family**: one sans-serif font throughout (e.g., Arial, Helvetica)
- **Minimum size**: 10px for print readability; 8pt absolute minimum at final print size
- **Edge/arrow labels**: 14px bold minimum for draw.io diagrams
- **Hierarchy**: title 16-18px bold, headings 14-16px bold, body 12-14px, annotations 10-12px
- **Bold for visibility**: prefer bold for labels in diagrams to ensure print legibility

## Line Width

Scale-based strokeWidth for diagrams (not fixed values):

```
strokeWidth = element_diameter(px) * coefficient
```

| Target | Coefficient | Notes |
|--------|-------------|-------|
| Paper PDF | 0.01-0.012 | Print-ready |
| Slides | 0.015-0.02 | Projector-ready |

Minimum 1pt for any line (thinner lines vanish in print/projection). Limit to 3 tiers (thin/normal/bold) for consistency.

## Legend

- **Required** for every figure using color, line style, or symbols
- **Position**: bottom or lower-right of the figure
- **Content**: explain all colors, arrow types, line styles, and abbreviations
- **Ordering**: match the order of appearance in the body text

## Golden Ratio (Optional)

For visual balance in conceptual/Venn diagrams, golden ratio (1.618) may guide element spacing and proportions. Not mandatory.
