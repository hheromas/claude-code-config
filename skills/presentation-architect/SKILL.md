---
name: presentation-architect
description: >
  Design the visual composition of individual slides once a storyline exists.
  Use whenever the user asks to compose a specific slide, choose a chart type,
  design a 2x2 for a set of items, pick a layout for a slide, critique whether
  a slide's layout supports its message, or translate a storyline into slide
  specs. Use for PowerPoint, Google Slides, Marp, Keynote, and other
  presentation formats. Do NOT use for deck-level storyline work: any request
  where a storyline, audience, or desired outcome is not yet fixed belongs to
  `deck-storyline` and MUST be handled there first. Do NOT use for PPTX file
  generation (hand off to pptx / marp / google-slides skill).
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Presentation Architect

Plan how a deck should look and read before any slide is authored. This skill
turns a message (or a raw pile of notes) into slide-level specifications:
which slide, which message, which evidence, which visual form, which
composition. It does not render slides; it emits specs for a downstream
rendering skill.

The core discipline is: **the layout is chosen from the content, not the
content shoved into a layout.**

## When to hand off to `deck-storyline` vs when to use this skill

- If the user has NOT yet decided the deck's core message, governing
  question, argument order, or action titles, invoke `deck-storyline` FIRST.
  That skill produces a written storyline plus slide-level plans.
- If a storyline already exists (from `deck-storyline` or the user), use
  THIS skill to design each slide's visual composition and emit slide specs.
- For actual PPTX / Marp / Google Slides file generation, hand off to the
  corresponding rendering skill after specs are emitted.
- For pure typography / brand color rules, hand off to a brand reference.
  Those are out of scope here.

## Workflow

### 1. Determine `presentation_mode` (FIRST — do this before anything else)

Ask the user which of the three modes applies. If they do not answer,
ask again with a 1-line explanation of why the mode matters. Do NOT
infer silently. The mode changes every downstream decision (text
density, font size, visual weight, hierarchy).

```
presentation_mode: live | leave-behind | hybrid
```

- **live**: a speaker presents to a room / screen share. The speaker is
  the main channel; slides support them. Large text, minimal words per
  slide, one dominant visual. Reading dense body text under a live
  speaker forces the audience to choose between reading and listening.
- **leave-behind**: the reader consumes the deck alone, without a
  speaker. Higher information density is acceptable and often required.
  Full sentences, tables, footnotes, and appendix cross-references are
  fine because there is no speaker to fill gaps.
- **hybrid**: presented live but also circulated as a document. Compromise
  density; each slide should stand alone as a document AND be legible in
  a room. Slightly denser than pure `live`, cleaner than pure
  `leave-behind`.

Do not default to any single mode. Do not treat "less text = better" as
universal — that rule only holds for `live`.

The chosen mode MUST appear in the output spec as
`deck.presentation_mode`. If mode is missing from a spec, the spec is
incomplete.

### 2. Confirm storyline, audience, and desired decision (hard gate)

Before any slide-level work, confirm all three exist:

- a storyline (headline-only text of each slide's takeaway)
- primary audience
- what decision, belief, or action should change after the deck

If any of the three is missing or materially uncertain, HALT and invoke
`deck-storyline`. Do not infer, improvise, or "capture a minimum" — the
storyline pass belongs to `deck-storyline`, and slide composition on
top of an unclear objective is the largest single source of wasted
downstream work.

### 3. Deck-level pass (storyline check)

Read `references/storyline.md`. Then:

- Confirm the storyline exists as headline-only text (each slide reduced
  to its takeaway sentence).
- Run the **headline-only test**: read only the headlines in order. They
  must form a coherent argument on their own. If they do not, no visual
  composition will rescue them — return to `deck-storyline` first.
- Confirm the 1-slide-1-message rule and check for buried or merged
  messages that should be split.

### 4. Slide-level pass (composition mapping)

For each slide, read `references/slide-composition.md` and
`references/visual-grammar.md`, then decide in this order:

1. **Message**: what one sentence must the audience take away.
2. **Evidence**: what fact / data / example proves the message.
3. **Relationship**: what is the semantic shape of the evidence
   (comparison, sequence, matrix, hierarchy, part-to-whole, causal
   chain, single dominant number, etc.).
4. **Visual form**: which visual grammar matches that relationship
   (from `visual-grammar.md` semantic routing table).
5. **Composition**: focal point, reading order, region weights.

Do not skip step 3. Choosing a visual form without naming the
relationship is the most common source of "3 icons + 3 columns" default.

### 5. Layout selection (choose from content, not from template inventory)

Read `references/layout-patterns.md`. The layouts there are annotated
with `Use when` / `Message shape` / `Do not use when`.

- Match the semantic relationship from step 4 to a layout with a
  matching `Use when`.
- If none matches cleanly, prefer a simpler custom composition over
  forcing content into a nearly-fitting template.
- Layouts may be reused when the semantic structure genuinely repeats.
  Do not vary layouts for variety's sake.

Short illustration: three sequential steps is NOT three cards. It is a
horizontal flow. Three independent findings can be three cards, but only
if they are truly independent (no order, no dependency).

### 6. Self-review

Read `references/anti-patterns.md` and `references/review-rubric.md`.
Run both against every slide spec before emitting:

- Anti-patterns are hard rejections (e.g., decorative icons, meaningless
  accent lines, topic-only titles, forced 3-column grids).
- Review rubric checks Simple / Clear / Memorable and reading order.

Fix violations by revising the spec, not by adding decoration.

### 7. Emit slide specs and hand off

Emit one spec per slide in the format below. Do not draft the finished
slide text or open the rendering tool. Hand the spec set off to the
appropriate rendering skill (`pptx`, `marp`, `google-slides`, etc.).

## Slide spec output format

Emit the spec as YAML: one top-level `deck` block followed by one
`slide` block per slide. This is the contract with the downstream
rendering skill. The full field list, enum values, and required-vs-
optional rules live in `references/spec-schema.md` — read that file
before emitting.

```yaml
deck:
  presentation_mode: live          # live | leave-behind | hybrid (REQUIRED)
  audience: "engineering leadership"
  desired_outcome: "approve pipeline redesign"

slide:
  slide_number: 2
  role: evidence          # opening | context | evidence | pivot | closing | appendix
  message: "導入後、処理時間は約68%短縮した"

  evidence:
    type: quantitative-comparison
    data:
      before: 28 min
      after: 9 min

  visual:
    grammar: before-after
    primary_visual: horizontal-bar-comparison

  composition:
    focal_point: "9 min / -68%"
    reading_order: "headline → before/after bars → implication"
    layout: "chart 70%, explanation 30%"
    emphasis: "after value only"
    supporting_text: "1 short implication"

  avoid:
    - three equal cards
    - decorative icon
    - unrelated stock image
```

Required top-level: `deck.presentation_mode`. Required per slide:
`slide_number`, `role`, `message`. Required per role and other field
rules: see `references/spec-schema.md`.

## Reference files

Progressive disclosure — load only what step 3-6 needs.

| File | Purpose |
|---|---|
| `references/storyline.md` | Deck-level storyline rules, 1-slide-1-message, headline-only test |
| `references/slide-composition.md` | Message → evidence → visual form mapping |
| `references/visual-grammar.md` | Semantic routing table (relationship → visual form) |
| `references/layout-patterns.md` | Annotated layout catalogue with Use-when / Do-not-use-when |
| `references/anti-patterns.md` | Hard-rejection patterns (3-column default, generic icon, topic titles, etc.) |
| `references/review-rubric.md` | Simple / Clear / Memorable checks; reading-order test |
| `references/spec-schema.md` | Slide-spec contract: field list, enum values, required-vs-optional rules |
| `assets/README.md` | Placeholder for example PNGs (future work) |

## Anti-pattern quick summary

Full list is in `references/anti-patterns.md`. Top offenders:

- Choosing a 3-column card grid because there happen to be three bullets.
- Adding an icon that communicates no information.
- Making all regions equal visual weight when the message has a clear
  priority.
- Using decoration (accent stripe, gradient, thin underline) as a
  substitute for hierarchy.
- Adding a chart when no quantitative relationship is being communicated.
- Titling a slide `課題` / `結果` / `アプローチ` / `Overview` / `Approach`.
  State the actual conclusion.
- Varying layout for the sake of variety when the semantic structure
  actually repeats.
- Reducing text under `leave-behind` mode because "less text is better"
  (that rule is for `live` only).

## Related skills

- `deck-storyline` — upstream. Use FIRST when the storyline is not yet
  fixed. This skill assumes a storyline already exists.
- `pptx` / `marp` / `google-slides` — downstream rendering skills. This
  skill emits specs; rendering skills produce the file.
- (Future) `presentation-reviewer` — independent hostile review of a
  finished deck. Out of scope here.
