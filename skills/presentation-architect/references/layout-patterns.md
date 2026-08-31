# layout-patterns.md

A gallery of completed slide layouts. Each pattern describes when it
fits, the message shape it carries, how it should be composed, and
when to reject it. Use this file after
[visual-grammar.md](visual-grammar.md) has named the visual form —
these patterns are the concrete realizations.

Layouts are chosen from the message, not the other way around. Never
open this file first and shop for a layout to fit an ill-defined
message; that is the "form-first" failure mode that produces
generic-looking decks.

PNG assets for these patterns are deferred; the descriptions below
are precise enough that a rendering skill can build the slide from
them alone.

---

## Pattern: horizontal process (3–7 steps)

Use when:
  The message is that a process advances through a fixed sequence of
  stages, and the reader needs to grasp the order.

Message shape:
  "X progresses through A → B → C → D." Or: "Our approach: A, then B,
  then C." Or: "We are currently at stage 3 of 5."

Composition:
  - Chevrons or arrows across the horizontal midline of the slide
  - Steps read left-to-right, uniform width
  - Current step (if any) accented; all others in neutral color
  - One-line label per step; short verb phrase, not a full sentence
  - Secondary annotation beneath if needed; do not stack labels above

Do not use when:
  Steps are not sequential; steps have branches; the message is about
  responsibility or resources per step (use swimlane instead).

Example:
  "Approach: identify problem → analyze root cause → **design fix** →
  execute → verify" — with "design fix" accented as the current stage.

---

## Pattern: swimlane (responsibility × phase)

Use when:
  The message is who does what, when — two orthogonal axes must be
  read together.

Message shape:
  "In this project, actor A leads phase 1, actor B leads phase 2, and
  actor C leads phase 3." Or: "The handoffs happen at these
  boundaries."

Composition:
  - Rows = actors (sales / engineering / management / customer)
  - Columns = phases (left-to-right time)
  - Cells contain the actor's activity for that phase
  - Primary activities in accent color, supporting in grey, empty
    cells left blank (do not fill with dashes or NA)
  - Judgment / decision points as diamonds within cells
  - Optional shading distinguishes internal from external actors

Do not use when:
  The process is linear with one actor (use horizontal process); the
  actors and phases are not both structured (use a table or list).

Example:
  Rows: customer, sales, tech, management. Columns: intake → scoping
  → quote → approval → delivery. Accent color marks the critical path.

---

## Pattern: 2×2 matrix

Use when:
  Items are scored on two independent dimensions and the point of the
  slide is which quadrant they occupy.

Message shape:
  "Along impact × feasibility, X and Y are the top priorities." Or:
  "The recommended quadrant is the top-right — start there."

Composition:
  - Two perpendicular axes, labeled at both ends of each axis
  - Quadrant labels inside the four boxes (not outside)
  - The recommended quadrant is accented (fill or border)
  - Items placed by their scores; if there are no items, only the
    quadrant framework is shown
  - A brief "how to read" note at the bottom or right

Do not use when:
  Only one dimension matters (use a bar chart); more than two
  dimensions matter (use a small-multiples layout); items don't
  actually vary along both axes.

Example:
  Impact (high–low) × feasibility (easy–hard). Top-right accented
  labeled "Start here", top-left "Roadmap later", bottom-right
  "Quick wins", bottom-left "Cut".

---

## Pattern: before / after comparison

Use when:
  The message is that a specific change caused a specific measurable
  improvement.

Message shape:
  "After introducing X, metric M moved from A to B (–N%)."

Composition:
  - Two paired visuals of the same type on the same axis
  - "Before" on the left, "after" on the right
  - The "after" value or bar is the only accented element
  - A delta annotation between or beneath (arrow + percentage)
  - Everything grey except the accented after-value

Do not use when:
  Comparison is between two peers with no change over time (use
  side-by-side aligned bars, no "before/after" framing); the metric
  moved but the change did not cause the movement (do not imply
  causation you cannot support).

Example:
  Processing time. Before: 28 min (grey long bar). After: 9 min
  (accent short bar). Delta arrow: "▼ 68%".

---

## Pattern: bar chart with hero annotation

Use when:
  The message is one specific bar or group of bars is the point of
  the slide; the rest is context.

Message shape:
  "In month M, metric spiked to V." Or: "Segment S is 3× the next
  largest."

Composition:
  - All bars in grey except the anchor bar(s), which are in accent
  - Numeric value labeled at the top of the anchor bar
  - Callout arrow or annotation on the anchor with the one-line
    conclusion
  - Axis labels minimal; drop non-essential gridlines
  - No legend if a single accent + one narrative annotation suffice

Do not use when:
  All bars carry roughly equal narrative weight (use a table
  instead); the message is about the trend rather than a specific bar
  (use a line chart with an annotation).

Example:
  Monthly count Jan–May. May bar accented, "▲ New pipeline live",
  numeric label "48".

---

## Pattern: line chart with KPI callout

Use when:
  The message is a trend over time, and the reader also needs the
  current-state KPI value.

Message shape:
  "Metric M is on an upward trend; current value is V (+N% YoY)."

Composition:
  - Line chart occupies primary space (roughly 60–70%)
  - Current year in solid accent line, prior year in dashed grey
  - Anchor point (last data point or peak) annotated with callout
  - A KPI card or row below or to the right: current value, delta,
    peer comparators
  - Y-axis truncated to make the trend readable; state truncation

Do not use when:
  There is no time series (use a bar chart); the KPI is a single
  spot value with no trend (use a hero metric).

Example:
  Monthly sales line, this year vs prior year. "28.4M — highest on
  record" annotated on the anchor peak. KPI row: 28.4M (+22% YoY),
  36 new customers, 1.2% churn.

---

## Pattern: part-to-whole (stacked bar / pie)

Use when:
  The message is composition — how a total splits into named parts.

Message shape:
  "Segment X accounts for N% of the total; the composition needs to
  shift toward Y." Or: "Y is the dominant slice."

Composition:
  - For 4–5 parts with one clear leader: pie chart. Leader in accent,
    the rest in navy/grey shades ordered by size, "Other" last and
    lightest.
  - For 6+ parts or for comparing composition across categories:
    stacked bar (100% stacked if the point is the share ratio).
  - Numeric label on every segment large enough to hold text; small
    segments called out with leader lines.
  - Legend to the right or embedded in the labels (prefer embedded).

Do not use when:
  Segments are all similar in size (pie becomes unreadable — use a
  bar chart); the point is comparison rather than composition (use
  aligned bars).

Example:
  Revenue mix: services 46% (accent), SaaS 24%, consulting 16%,
  other 14%. Annotation: "Services dominance is the risk; lift SaaS
  above 30%."

---

## Pattern: hero metric single slide

Use when:
  The entire slide exists to communicate one number, and the number
  is the message.

Message shape:
  "The number is V, and here is what it means."

Composition:
  - Number rendered very large (occupies 40–60% of body area)
  - Units and time frame directly beneath in smaller text
  - One-line context above or below ("+22% year-over-year",
    "highest since 2019")
  - Optional supporting sparkline or comparator to the side, deeply
    subordinate in size
  - No other content on the slide

Do not use when:
  There are multiple KPIs to show at once (use a KPI card row); the
  number needs context that exceeds one line (use a chart with
  annotation).

Example:
  "9 minutes" occupying the center. Below: "average processing time
  after pipeline redesign". Above: "▼ 68% vs prior architecture".

---

## Pattern: assertion + dominant evidence

Use when:
  The slide's job is to make a claim and offer one dominant piece of
  proof for it.

Message shape:
  "We claim C; here is the single strongest evidence for C."

Composition:
  - Headline states the claim as an action title
  - Body dominated (70%+) by one evidence element: a chart, a photo,
    a table, a quote card, a diagram
  - Secondary zone: one short annotation reinforcing the read
  - No secondary charts, no supporting bullet columns

Do not use when:
  Multiple pieces of evidence together carry the claim (use a
  compound slide or split across two slides); the claim needs
  qualification that would balance the evidence visually.

Example:
  Headline: "Users complete the task 40% faster on the new flow."
  Body: bar chart of task completion time, new vs old, with the new
  bar accented. Annotation: "n=124, statistically significant at
  p<0.01."

---

## Pattern: tree / hierarchy

Use when:
  The message is that items nest — a whole breaks into parts, which
  break into sub-parts.

Message shape:
  "Our approach has three pillars; each pillar has two workstreams."

Composition:
  - Root at the top, children beneath, connected by lines
  - Uniform sibling spacing at each level
  - Levels visually distinguished by size or fill, not by color
  - Emphasis (accent color) reserved for the branch under discussion
  - Maximum depth 3 levels on one slide; deeper trees need
    splitting or an appendix

Do not use when:
  The relationship is not nesting (use the appropriate form from
  [visual-grammar.md](visual-grammar.md)); the tree is too wide to
  read (split by branch across multiple slides).

Example:
  Top: "Q4 initiatives". Middle: growth / retention / cost. Bottom:
  two concrete projects under each. Retention branch accented as the
  slide's focus.

---

## Pattern: causal chain

Use when:
  The message asserts a mechanism: A leads to B leads to C.

Message shape:
  "A causes B via mechanism M, resulting in C."

Composition:
  - Left-to-right boxes: cause → mechanism → outcome
  - Labeled arrows between boxes state the causal relation
  - Boxes uniform size unless the message is about the magnitude
  - Outcome box accented as the takeaway
  - Optional feedback loop as a return arrow if the mechanism cycles

Do not use when:
  The three steps are independent items rather than a chain (use
  three cards or a comparison instead — but only if genuinely
  independent); the mechanism is disputed (state the epistemic
  status).

Example:
  "New pricing → higher trial-to-paid conversion → 20% revenue
  lift." Middle arrow labeled "via reduced friction at checkout".

---

## Pattern: text-dominant leave-behind reference

Use when:
  Mode is leave-behind, the slide is a reference the reader will
  read closely on their own, and a visual would not add over
  well-structured text.

Message shape:
  "For reference, here is the full breakdown of X."

Composition:
  - Headline still states the takeaway, not the topic
  - Body organized as a compact table or as clearly indented text
    blocks
  - Consistent typographic hierarchy (headings, subheadings, body)
  - Footnotes for sources and caveats
  - Minimum body font size larger than the deck's absolute floor —
    a leave-behind reference is not a license for 8pt text

Do not use when:
  Mode is live (dense text on live slides is a known failure); a
  diagram or table would carry the content faster.

Example:
  A one-page methodology reference in an appendix: assumptions,
  variables, data sources, exclusions. Prose organized under four
  bold subheadings.

---

## Choosing among patterns

If two patterns both fit, prefer the one that:

1. Requires the fewest decorative elements to look complete
2. Encodes the message more directly (fewer inference steps for the
   reader)
3. Reuses a pattern already used elsewhere in the deck for the same
   type of message (consistency serves the reader more than variety)

Reusing a layout for the same semantic structure is a strength, not
laziness. See [anti-patterns.md](anti-patterns.md) on variety-for-
variety.

See also: [SKILL.md](../SKILL.md), [visual-grammar.md](visual-grammar.md),
[slide-composition.md](slide-composition.md),
[anti-patterns.md](anti-patterns.md).
