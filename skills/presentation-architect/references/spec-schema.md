# spec-schema.md

The contract between `presentation-architect` and any rendering skill
(`pptx`, `marp`, `google-slides`, `keynote`, etc.). Rendering skills
MUST accept these field names verbatim. Adding new optional fields is
allowed; redefining existing values is not.

If a spec is missing a required field, it is incomplete and the
rendering skill should reject it rather than infer.

## Top-level structure

A spec output is a YAML document with a `deck` block (metadata for the
whole deck) followed by one or more `slide` blocks.

```yaml
deck:
  presentation_mode: live | leave-behind | hybrid   # REQUIRED
  audience: "<primary audience>"                    # optional
  desired_outcome: "<what should change after>"     # optional
  time_budget: "<e.g. 15 min live>"                 # optional

slide:
  slide_number: 1                                   # REQUIRED
  role: evidence                                    # REQUIRED
  message: "<one-sentence takeaway>"                # REQUIRED
  ...
```

If `deck.presentation_mode` is absent, the spec is incomplete.

## `role` enum (authoritative)

The `role` field classifies what job a slide does in the deck. This
enum is the SKILL-side authoritative choice; rendering skills MUST
support all six values.

| Value | Description |
|---|---|
| `opening` | Title / agenda / framing slide. Sets the question or the room. |
| `context` | Background, definitions, or setup the audience needs before evidence lands. |
| `evidence` | Presents data, examples, or proof that carries the argument. |
| `pivot` | Section break, transition, or reframing slide between argument phases. |
| `closing` | Recommendation, call-to-action, or summary of what was concluded. |
| `appendix` | Reference-only backup material; not part of the main flow. |

## `visual.grammar` enum

The `visual.grammar` value names the semantic form the slide takes.
The canonical list lives in `visual-grammar.md` as the row headings of
the semantic routing table. The values below match those rows:

| Value | Row in `visual-grammar.md` |
|---|---|
| `comparison` | Comparison |
| `before-after` | (specialization of comparison across time) |
| `sequence` | Sequence / time |
| `timeline` | (specialization of sequence with date axis) |
| `swimlane` | Responsibility × phase |
| `matrix-2x2` | Priority along 2 dimensions |
| `hero-metric` | Single dominant quantitative insight (number form) |
| `chart-with-annotation` | Single dominant quantitative insight (chart form) |
| `part-to-whole` | Composition / share |
| `causal-chain` | Cause → mechanism → outcome |
| `hierarchy` | Hierarchy |
| `assertion-plus-evidence` | One assertion with one proof |
| `distribution` | Distribution / spread |
| `correlation` | Correlation / relationship between two variables |
| `geographic` | Geographic distribution |

If none fit, use the closest match and add a `visual.notes` field
explaining the deviation. Do not invent new grammar values silently.

## `visual.primary_visual` enum

Concrete rendering hint that narrows `grammar` to a specific artifact.
Examples: `horizontal-bar-comparison`, `paired-bars`, `chevron-flow`,
`arrow-boxes`, `pie-chart`, `stacked-bar`, `100-stacked-bar`, `scatter`,
`heatmap`, `swimlane-grid`, `tree-diagram`, `hero-number`, `line-chart`,
`callout-annotation`, `choropleth`, `table`.

Rendering skills may extend this list. Values are lower-kebab-case.

## `evidence.type` enum

Present when `role` is `evidence` or `context`. Values:

- `quantitative-comparison` — numeric before/after or A/B
- `quantitative-trend` — series over time
- `distribution` — spread of values
- `qualitative-quote` — verbatim customer / SME statement
- `case-example` — a single narrative instance
- `swimlane` — actor × phase matrix data
- `matrix` — items scored on 2 dimensions
- `composition` — parts of a whole
- `hierarchy` — nested items
- `causal` — cause / mechanism / outcome triple
- `reference-table` — full parameter or lookup table

`evidence.data` is required alongside `evidence.type` and holds the
raw values (a dict, list, or a `source:` pointer).

## Field requirements

### Required at deck level

- `deck.presentation_mode`

### Required at slide level (every slide)

- `slide_number` — integer, 1-indexed, unique per deck
- `role` — one of the six enum values
- `message` — one sentence stating what the audience should take away

### Required per role

- When `role` is `evidence` or `context`: `evidence.type` AND
  `evidence.data`
- When `role` is `evidence`: `visual.grammar` AND
  `visual.primary_visual`
- When `role` is `opening`, `pivot`, `closing`, or `appendix`:
  `evidence` is optional

### Required for any slide with a visual

- `composition.focal_point` — the one element the eye lands on first
- `composition.reading_order` — the reader's traversal path

### Optional (recommended)

- `speaker_notes` — verbatim or bullet points for the presenter
- `data_source` — provenance of chart data (URL, file, query, date)
- `composition.layout` / `composition.emphasis` /
  `composition.supporting_text`
- `dependencies` — list of prior `slide_number` values this slide
  builds on
- `avoid` — list of anti-patterns explicitly rejected for this slide

## Full example (3-slide deck)

```yaml
deck:
  presentation_mode: live
  audience: "engineering leadership"
  desired_outcome: "approve pipeline redesign for Q4"
  time_budget: "10 min live + Q&A"

slide:
  slide_number: 1
  role: opening
  message: "The pipeline redesign cut processing time by 68%; approve rollout."
  composition:
    focal_point: "headline"
    reading_order: "headline → subhead"

slide:
  slide_number: 2
  role: evidence
  message: "Processing time dropped from 28 min to 9 min after the redesign."
  evidence:
    type: quantitative-comparison
    data:
      before: 28 min
      after: 9 min
    source: "prod telemetry, weeks 12-20"
  visual:
    grammar: before-after
    primary_visual: horizontal-bar-comparison
  composition:
    focal_point: "9 min / -68%"
    reading_order: "headline → before/after bars → implication"
    layout: "chart 70%, explanation 30%"
    emphasis: "after value only"
    supporting_text: "1 short implication"
  data_source: "prod telemetry dashboard export 2026-08-24"
  speaker_notes: "Emphasize this is measured, not projected."
  avoid:
    - three equal cards
    - decorative icon

slide:
  slide_number: 3
  role: closing
  message: "Approve Q4 rollout; owner: platform team; go-live: 10-15."
  dependencies: [2]
  composition:
    focal_point: "decision line"
    reading_order: "decision → owner → date"
```
