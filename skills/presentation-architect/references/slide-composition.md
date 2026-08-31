# slide-composition.md

Per-slide composition: turning one message into one slide whose focal
point, reading order, weight, and color all serve that message.

## The per-slide decision chain

For every slide, walk this chain in order. Do not skip forward.

1. **Message.** What single claim does this slide commit to? State it
   as one sentence. If you cannot, the slide is not ready.
2. **Evidence.** What is the single strongest piece of support — a
   number, a comparison, a diagram of a mechanism, a table? Name it.
3. **Relationship.** What is the logical shape of that evidence?
   Comparison, sequence, responsibility × phase, share, cause-chain,
   hierarchy, one assertion + one proof. See
   [visual-grammar.md](visual-grammar.md) for the routing.
4. **Visual form.** Given the relationship, choose the visual form
   from the routing table — not from a template gallery, not from
   "what looked good last time".
5. **Composition.** Place the form on the slide with a focal point, a
   reading order, a primary/secondary weight split, and a single
   emphasis. This is where composition rules below apply.

If any step's answer contradicts an earlier step, back up. Do not
paper over the mismatch with decoration.

## Focal point: exactly one per slide

A slide has one focal point. It is the element the eye lands on
first, and it should be the element that carries the message.

Common failure modes:

- Three equally-weighted cards, none dominant. The eye has nowhere to
  land, and the reader concludes the slide has no priority — even
  when the headline states one.
- A chart with all bars the same color. The chart shows data but does
  not point at the conclusion.
- A large decorative image next to a small text block that carries
  the actual message. The image wins the focal-point fight and the
  message loses.

Fix by making one element visually louder — larger, in the accent
color, in bold, higher contrast, with a direct annotation.

## Reading order: default, not law

For decks written in left-to-right languages (Japanese, English), the
default reading order is top-to-bottom then left-to-right. Place the
message-carrying element accordingly: headline at the top, primary
evidence in the upper-center or upper-left, secondary and supporting
material lower and to the right.

This is a default, not a physiological absolute. When the visual
relationship demands another structure — a radial diagram, a
mechanism with a central hub, a matrix read column-by-column — follow
the relationship, not the default. State the intended reading order
explicitly in the slide spec so downstream rendering does not
scramble it.

## Primary / secondary weight split

Every slide splits into two zones:

- **Primary (roughly 60–80% of body area):** the headline's evidence.
  A chart, a diagram, a hero table, a before/after pair. This zone
  carries the message.
- **Secondary (roughly 20–40%):** annotations, a one-line
  implication, a caption, an axis of reference, a small legend.

If a slide has three or more zones fighting for equal space, one is
usually redundant. Cut it or demote it into the secondary zone. The
"columns of equal width because there are N items" reflex is an
anti-pattern; see [anti-patterns.md](anti-patterns.md).

## Color: one emphasis per slide

Color is a semantic tool, not a decorative one. Two rules:

1. **Emphasize one thing per slide.** Use the accent color on the
   single element that carries the message. Everything else is neutral
   (black, grey, or the deck's navy). Two things emphasized means
   nothing is emphasized.
2. **Same color = same meaning within the deck.** If accent-gold
   means "the recommended option" on slide 12, it must not mean "at
   risk" on slide 18. Colors are variables; keep their bindings
   stable across the deck.

Charts follow the same rule: the bar that carries the message is in
the accent color, all others in grey. If the chart shows "10s and 20s
dominate", only the 10s and 20s bars are accented; the 30s and 40s
bars are grey — even when the raw data has four distinct series.

## Same concept, same expression

Within one deck, one concept always uses the same visual encoding.
If "responsibility" is expressed as a row in the swimlane on slide
22, it must not become a column on slide 28. If "phase" is a color
tint on one slide, it must not become a shape outline on another.

For the concept-encoding table (which channel maps to which meaning),
see [visual-grammar.md](visual-grammar.md#iplot-concept-encoding-table-for-consistency-within-a-deck).
Do not duplicate here.

## Text density: mode-dependent

Text-density rules are not universal. They depend on presentation
mode:

- **Live mode:** minimum body text. Headlines are longer (they must
  stand on their own without narration if the presenter loses the
  thread), body text is short, minimum font sizes are larger
  (18 pt+ per Microsoft's live-presentation guidance).
- **Leave-behind mode:** higher density is legitimate. Annotations,
  footnotes, and reference tables carry the load the presenter would
  otherwise carry. Smaller font sizes are acceptable in appendices.
- **Hybrid mode:** compromise; expect the presenter to skip
  appendices live and rely on them post-hoc.

Do not apply "reduce text" reflexively across modes. Ask the mode
first (`SKILL.md` step 1), then apply density rules from
[review-rubric.md](review-rubric.md).

## When a slide feels crowded

Before shrinking font or squeezing margins, run this triage:

1. Is the message actually one message, or two? Split.
2. Does every element earn its place, or is some information there
   because it was researched and felt wasteful to cut? Cut.
3. Is a decorative element (icon, color bar, gradient, accent line)
   consuming real estate? Remove; see
   [anti-patterns.md](anti-patterns.md).
4. Is a low-priority sub-argument on the same slide as the main
   argument? Move it to an appendix and place a small pointer.

Font-shrinking is the last resort, not the first.

## Composition output: slide spec

The composition step outputs a slide spec, not finished slide text.
The spec captures the decisions above in a structured form so the
downstream rendering skill (pptx / marp / google-slides) can build
the slide without re-deciding the composition.

For the full spec schema, see [spec-schema.md](spec-schema.md); for a
compact example, see [SKILL.md Output section](../SKILL.md#output).
The `role` field uses the canonical enum
`opening | context | evidence | pivot | closing | appendix` (earlier
drafts used `argument`, `transition`, `reference`, which map to
`evidence`, `pivot`, and `appendix` respectively).

Handing a spec to the rendering skill, not a finished slide, prevents
the "AI writes plausible slide text before the composition is
decided" failure mode.

See also: [SKILL.md](../SKILL.md), [storyline.md](storyline.md),
[visual-grammar.md](visual-grammar.md),
[layout-patterns.md](layout-patterns.md),
[anti-patterns.md](anti-patterns.md),
[review-rubric.md](review-rubric.md).
