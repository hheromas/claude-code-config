# review-rubric.md

Deck- and slide-level quality tests. Each test has a pass criterion
and a concrete failure example. Run the tests in order; a failure at
an earlier test usually means later tests are premature.

## The three pillars: Simple, Clear, Memorable

Every slide should pass three concurrent bars.

- **Simple** — no unnecessary information. Every element earns its
  place. Whitespace is not the enemy.
- **Clear** — the message is unambiguous. The reader does not have
  to reconstruct the point from parts.
- **Memorable** — there is an insight the reader will retain. The
  slide gives the reader something they did not already know, framed
  so it sticks.

A slide can be Simple and Clear but not Memorable — that is a
factually-correct-but-forgettable slide. It can be Clear and Memorable
but not Simple — that is a striking but bloated slide. All three must
hold together.

---

### Test: headline-only

Pass criterion:
  Extract every slide's headline in slide order, into a plain-text
  list. Read only the list. It should read as a coherent argument
  that a reader could act on.

How to run:
  Copy headlines to a plain text file. Read straight through with no
  slide context. Check for: (a) each headline commits to a specific
  claim, (b) each headline creates a question the next headline
  answers, (c) reading only the list, a reader would leave with the
  same decision the full deck is asking for.

Failure examples:
  - Headlines are all topic titles ("Challenges", "Approach",
    "Results"). The list reads as a table of contents, not an
    argument.
  - Two adjacent headlines say the same thing in different words.
  - The list has a gap: headline 5 answers a question headline 4 did
    not raise. The intermediate slide is missing.

If this test fails, do not fix individual slides. Fix the spine.
See [storyline.md](storyline.md).

---

### Test: 1 slide, 1 message

Pass criterion:
  Every slide's message can be stated in one sentence, and that
  sentence contains no coordinating "and" that stitches two
  independent claims.

How to run:
  For each slide, ask the author (or yourself) to state the
  message in one sentence. If the sentence needs "and" to hold two
  claims, split the slide. If the author cannot state the message
  at all, the slide has no message.

Failure examples:
  - "AI adoption is accelerating, and our headcount is growing to
    match." Two messages; split.
  - "This chart shows Q1 sales." Not a message; this is a topic
    label. Restate as the conclusion the chart supports.

---

### Test: hierarchy

Pass criterion:
  Squint at the slide. One element is clearly loudest and carries
  the message. Everything else is subordinate.

How to run:
  Blur the slide (either literally, or by looking away then glancing
  back). Identify the element that draws the eye first. Ask: is that
  element the message-carrier? If two or more elements tie for
  loudest, the slide has no hierarchy.

Failure examples:
  - Three equally-sized cards, none dominant. Reader has no anchor.
  - A large decorative image next to a small text block that carries
    the message. The image wins the hierarchy fight.
  - A chart with all bars the same color. Data is present; the
    hierarchy that would point at the conclusion is not.

Fix by enforcing the primary/secondary weight split from
[slide-composition.md](slide-composition.md).

---

### Test: emphasis (one per slide)

Pass criterion:
  Exactly one element on the slide uses the accent color. That
  element is the one the message asks the reader to focus on.

How to run:
  Count uses of the accent color on the slide. Zero means the
  message has no visual anchor. Two or more means nothing is
  emphasized (competing accents cancel out).

Failure examples:
  - Chart with three colors (accent, secondary accent, warning) all
    treated as emphasis. Reader sees "colorful" not "important".
  - Bullet list where two of five bullets are bold. Which one
    matters?

---

### Test: same concept, same expression

Pass criterion:
  Across the whole deck, one concept category (who / what / where /
  when / how / importance) is encoded on exactly one visual channel.

How to run:
  Walk the deck. For each concept category, list every encoding
  used. If any category uses more than one encoding, or if any
  encoding channel carries more than one concept category, flag it.

Failure examples:
  - Grey means "our team" on slide 22 and "online meeting" on slide
    28. Two concepts on one channel.
  - "Responsibility" is encoded as a row on slide 22 and as a column
    on slide 28. One concept on two channels.

Fix by picking one channel per concept for the whole deck and
enforcing it. See [visual-grammar.md](visual-grammar.md).

---

### Test: mode-appropriateness

Pass criterion:
  The slide is legible and comprehensible in its intended mode.

How to run:
  - **Live mode:** view the slide at the size it will be projected,
    from the back of the room (or approximate: shrink the slide to
    thumbnail and stand 3 meters away). Is the headline readable?
    Is the body text readable? Can the visual be read in the seconds
    the presenter will spend on it?
  - **Leave-behind mode:** read the slide with no narrator. Do you
    understand the message from the slide alone? Are the annotations
    and captions sufficient to carry what the presenter would have
    said aloud?
  - **Hybrid mode:** both tests must pass.

Failure examples:
  - Live slide with 14-point body text and dense bullets. Reader
    cannot read; presenter competes with the slide for attention.
  - Leave-behind slide with a chart but no annotation stating the
    conclusion. Reader sees data, must derive the point.

---

### Test: storyline coherence (adjacent-slide test)

Pass criterion:
  Each slide creates a question the next slide answers.

How to run:
  Read slide N. Note the question it implicitly raises ("So what?"
  or "How?" or "Which one?" or "Why?"). Read slide N+1. Does it
  answer that question?

Failure examples:
  - Slide 5 shows a problem. Slide 6 shows a chart of unrelated
    metrics. The reader has to bridge on their own.
  - Slide 12 makes a claim. Slide 13 makes the same claim from a
    different angle without new evidence. Redundant.

---

### Test: necessity

Pass criterion:
  Remove any single slide. Does the argument still hold, and does
  the reader still reach the same conclusion?

How to run:
  For each slide, mentally excise it and re-read the deck. If the
  argument survives intact, the slide is not necessary — move it to
  an appendix or cut. If the argument breaks, the slide is load-
  bearing; keep it.

Failure examples:
  - A "context" slide that restates what the audience already knows.
    Cut.
  - A slide showing methodology detail that the executive audience
    will not use for the decision. Move to appendix.

Necessity is a strong test but a harsh one. Slides that fail the
necessity test are not always deletable — some serve pacing,
transition, or emphasis. Weigh those benefits against the cost of
attention explicitly, and default to cutting if the benefit is
unclear.

---

### Test: anti-pattern sweep

Pass criterion:
  No slide exhibits any of the patterns listed in
  [anti-patterns.md](anti-patterns.md).

How to run:
  Walk the deck once with the anti-patterns file open. Flag each
  instance.

The most common flags in AI-drafted decks: 3-column card grids,
decorative icons, decorative accent lines, all-equal-weight regions,
topic titles, variety-for-variety layout changes.

---

## Review order

Run tests in this order. Do not skip forward:

1. Headline-only (spine defects sink everything downstream)
2. 1 slide, 1 message (message defects sink hierarchy)
3. Storyline coherence (adjacency defects)
4. Necessity (cut before polishing)
5. Hierarchy (per slide)
6. Emphasis (per slide)
7. Same concept, same expression (deck-wide)
8. Mode-appropriateness (per slide, mode-dependent)
9. Anti-pattern sweep (final polish)

A pass on the anti-pattern sweep alone is not a passing review. All
of 1–8 must hold as well.

## Reviewer's stance

Reviewing a deck well means reading it as the audience will, not as
the author did. When in doubt, ask: what does the audience have to
work to reconstruct? Everything they reconstruct is friction; every
reduction in friction is a win. The reviewer's job is to spot the
friction the author has stopped noticing.

See also: [SKILL.md](../SKILL.md), [storyline.md](storyline.md),
[slide-composition.md](slide-composition.md),
[visual-grammar.md](visual-grammar.md),
[anti-patterns.md](anti-patterns.md).
