# visual-grammar.md

Semantic routing from information relationship to visual form. This is
the core mechanism of the skill: given the shape of the argument, the
grammar names the visual that makes the conclusion inevitable at a
glance. Choose the form from the relationship, never from a template
gallery.

## How to use this file

At slide-composition time, name the relationship the evidence carries
(one of the rows below), then read across to the recommended visual
forms. Then read the "near-misses" column and confirm your case
belongs to this row and not to a superficially similar neighbor. If
your relationship is not listed, the closing section explains how to
derive a form from first principles.

## Semantic routing table

| If the relationship is… | Choose a visual form from… | Common near-miss to reject |
|---|---|---|
| **Comparison** — two or more items measured on the same axis, and the point is the difference | side-by-side layout, aligned bars, before-after pair, direct numeric callout | 3-column card grid (loses the axis; hides which is bigger). Pie chart (bad for comparing similar-sized shares). |
| **Sequence / time** — items ordered along an axis where the ordering itself is the point | timeline, horizontal process (chevrons or arrows), left-to-right steps, phased Gantt | 3-column cards (loses direction). Bullet list (loses horizontality). Circular diagram unless the sequence is genuinely a loop. |
| **Responsibility × phase** — who does what, when | swimlane (rows = actor, columns = phase), RACI matrix | Nested bullet lists (loses the actor × phase intersection). Org chart (encodes hierarchy, not phase). |
| **Priority along 2 dimensions** — items scored on two axes, and the point is which quadrant they land in | 2×2 matrix (accent the recommended quadrant), scatter plot with quadrant guides | Ranked list (collapses 2 dimensions to 1). Table with two numeric columns (correct but slow). |
| **Single dominant quantitative insight** — the whole slide exists to communicate one number or one trend | hero metric (giant number + one-line context), chart with direct annotation on the anchor point, single-KPI card | Multi-KPI dashboard (dilutes the one). Chart without an annotation (reader must derive the point). |
| **Composition / share** — how a whole splits into parts | stacked bar (best for comparing composition across categories), 100% stacked bar, pie chart (only when there is one dominant slice; max 4–5 segments), part-to-whole tree | Pie with many similar-sized slices (unreadable). Grouped bars (encodes comparison, not composition). |
| **Cause → mechanism → outcome** — the argument is that A produces B via a stated mechanism | causal chain (linked boxes with labeled arrows), left-to-right mechanism diagram with cause on the left and outcome on the right, before-during-after | 3-column cards (loses the causal arrows). Bullet list (loses the mechanism). |
| **Hierarchy** — items nest, parent-child, whole-part | tree diagram, layered / tiered structure, indented breakdown, org chart | Flat list (loses nesting). Sequential process (encodes time, not nesting). |
| **One assertion with one proof** — the slide states a claim and offers a single dominant piece of evidence | assertion (as headline) + dominant evidence visual (chart, photo, table), quote + attribution, statement + single data callout | 3-column cards ("here are three reasons" is a different relationship). Text-heavy justification (bury the proof). |
| **Distribution / spread** — how values are spread across a range | histogram, box plot, violin plot, dot plot, small-multiple histograms | Single mean value (throws away the distribution — the whole point). Line chart (encodes sequence, not distribution). |
| **Correlation / relationship between two variables** — the point is how A moves with B | scatter plot (with trend line if the point is the trend), connected scatter (if time-indexed), heat map for bin-vs-bin | Side-by-side bar charts (reader has to eyeball correlation). Two lines on a shared axis (works only for time-aligned pairs). |
| **Geographic distribution** — the point is where things are | choropleth map, symbol map, cartogram | Table of regions (loses the spatial pattern — which is the point). |

## IPLoT concept-encoding table (for consistency within a deck)

Once a deck adopts a channel for a concept category, hold it. The
table below is the routing between concept and encoding channel.
Choose one channel per concept for the whole deck.

| Concept category | Channels available | Pick one and hold it |
|---|---|---|
| Who (agent, group, actor) | position (row in swimlane), color of a person-marker, text label | Do not encode "who" as fill color if fill color is already used for "how" |
| What (deliverable, artifact) | shape (rectangle, folded-corner document), icon, text | Do not encode "what" as color if you use color for emphasis |
| Where (venue, location) | fill color, background tint, position on a map | Do not encode "where" and "who" both as fill color |
| Why (reason, purpose) | annotation, weight, callout | Rarely needs its own channel — usually lives in text |
| When (time, phase) | horizontal position, sequence, column | Time flows left-to-right by default |
| How (method, mechanism) | shape outline (solid vs dashed), line style | Do not encode "how" and "where" both on the fill channel |
| Importance / level | size, contrast, accent color | Accent color is reserved — one per slide |

The single most common consistency defect in real decks is two concept
categories competing for the same channel — "grey means our team on
slide 22, but grey means online meeting on slide 28". At deck-review
time, pick one channel per concept and enforce it across the deck.

## Deriving a form when the relationship isn't listed

If your evidence's relationship isn't listed above, do not fall back
on a card grid. Ask instead: **what is the audience supposed to
conclude?** Then choose the form that makes that conclusion inevitable
at a glance.

- If the conclusion is "X is bigger than Y", the form must make the
  size difference dominant. Aligned bars, not two boxes with numbers.
- If the conclusion is "X caused Y", the form must show the arrow.
  Boxes with labeled connectors, not two cards side by side.
- If the conclusion is "these three phases must happen in order", the
  form must show the order. Chevrons or arrows, not three cards.
- If the conclusion is "this is the recommended option", the form must
  visually single it out. Accent-color highlight in a 2×2 or matrix,
  not a bullet marked "recommended".

The relationship comes from the message, not from the number of items
in the evidence. Three items in the evidence do not imply three cards.
Three items along a shared axis are a comparison. Three items in
sequence are a process. Three items nested under a common parent are a
hierarchy. Three items in three unrelated buckets are the only case
where cards are actually the honest answer — and even then, the cards
should not be equal-weight unless the items are genuinely equal in
importance.

## Anti-patterns tied to this file

- Choosing a chart because "there is data" instead of because there
  is a quantitative relationship the chart is uniquely fit to show
  (see [anti-patterns.md](anti-patterns.md)).
- Choosing a 3-column card grid because there happen to be three
  bullets, when the actual relationship is sequence, comparison, or
  causal chain (see [anti-patterns.md](anti-patterns.md)).
- Choosing an icon because it "fills the space" instead of because it
  encodes a distinction the reader has to make.
- Choosing a pie chart when the shares are all similar in size — the
  human eye cannot compare pie slices of similar size, so use a bar.

## Worked examples

Concrete walk-throughs of the routing in action. Each shows the
message, the relationship inferred, the form chosen, and the near-
misses actively rejected.

**Example 1 — quarterly sales.**
Message: "Q3 sales dropped 12%, driven entirely by the SMB segment."
Relationship: comparison across segments, plus one dominant
quantitative insight (the drop). Two candidate forms: (a) a bar
chart of segment contributions with the SMB bar accented and a
delta annotation, (b) a hero metric ("–12%") with a small
supporting bar for context. Choice depends on audience: for
analysts, (a); for an executive, (b). Rejected: 3-column card
grid ("SMB / Mid / Enterprise") — collapses the magnitude
information into equal-weight boxes.

**Example 2 — project handoffs.**
Message: "Engineering owns the design phase; product owns the
scoping; both share the launch." Relationship: responsibility ×
phase. Form: swimlane, rows = actor, columns = phase. Rejected:
nested bullet list under phase headings — loses the actor-
intersection view that is the whole point.

**Example 3 — three initiatives to rank.**
Message: "Of our three candidate initiatives, X is the strongest
along both dimensions." Relationship: priority along 2 dimensions.
Form: 2×2 matrix with X in the accented quadrant. Rejected:
ranked list ("1. X, 2. Y, 3. Z") — collapses two dimensions to
one and hides the reasoning; and the 3-column card grid trap
"three initiatives → three cards" was avoided because the message
is about ranking, not enumeration.

**Example 4 — mechanism explanation.**
Message: "Cache warming cuts p99 latency because it eliminates the
cold-fetch penalty." Relationship: cause → mechanism → outcome.
Form: causal chain, left-to-right boxes with the mechanism labeled
on the arrow. Rejected: two side-by-side charts (before / after
latency) — shows the outcome but not the mechanism, so the reader
would have to infer causation from correlation.

**Example 5 — reference table.**
Message (leave-behind appendix): "Full parameter list for the
production model." Relationship: reference lookup, no single
insight. Form: text-dominant reference table with clear typographic
hierarchy. Rejected: any chart form — no quantitative relationship
is being communicated; forcing one is decorative.

## Handoff to composition

Once the visual form is chosen from this table, hand off to
[slide-composition.md](slide-composition.md) to decide focal point,
reading order, primary/secondary weight, and the single per-slide
emphasis. The form choice from this file does not by itself specify
the composition — a bar chart can still be laid out well or badly.

See also: [SKILL.md](../SKILL.md), [slide-composition.md](slide-composition.md),
[layout-patterns.md](layout-patterns.md),
[anti-patterns.md](anti-patterns.md).
