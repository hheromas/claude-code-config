---
name: deck-storyline
description: >
  Use this skill when the user needs to determine what a presentation,
  proposal, pitch, decision deck, research deck, or meeting deck should say:
  its core message, recommendation, governing question, storyline, slide
  sequence, executive summary, or action titles. Use it especially when the
  user has source material but is unsure how to structure it or what the key
  "so what" should be. Do not use it for visual composition, brand
  typography or color palette, PowerPoint mechanics, or slide rendering alone.
allowed-tools: Read, Grep, Glob, Write
---

# Deck Storyline

Design the argument before designing the slides. The goal is not to
maximize information included, but to make the audience understand the
argument and reach the intended decision, belief, or action.

## How to use this skill

Invoke once, at the start, before any slide layout or visual work. Produce
a written storyline (see `assets/storyline-template.md`) that stands on its
own as an argument. Then hand off to a slide-composition or rendering
skill. Do NOT use this skill for visual composition, layout, chart
selection, or PPTX rendering; for a deck that already has a storyline
and only needs slide polish; or for a single message or short note. For
visual composition (layout, chart selection, semantic color use, visual
grammar), use `presentation-architect`; for pure brand rules (font
families, brand color palette), consult your project's brand reference;
for slide generation, use a rendering skill (pptx, marp, google-slides).

## Workflow

### 1. Establish the communication objective

Determine:

- primary audience
- what they currently know or believe
- what decision, belief, or action should change after the deck
- presentation context and time constraints
- available evidence
- material uncertainties

Infer reasonable defaults when information is missing and state important
assumptions explicitly.

Express the objective as:

```
Audience:
Current state:
Desired outcome:
Why this matters now:
```

Do not start designing slides yet.

### 2. Determine the governing question

Identify the most important question the deck must answer.

The governing question should correspond to a real audience concern or
decision, not merely to what the author wants to report.

Use OPQ, SCQA, or another framing method when useful. Do not force a
framework when the task does not fit it. For a menu of framing methods and
when each fits, read `references/frameworks.md`. For deck-type-specific
patterns (proposal, decision, status update, research, workshop), read
`references/deck-archetypes.md`. For meeting-specific structure (agenda,
action, follow-up, ASIS/TOBE/GAP, WBS), read `references/meeting-decks.md`.

### 3. Form the governing thought

Write the best current answer to the governing question in one sentence.

It should be specific enough to disagree with.

Distinguish epistemic status:

- Fact: directly supported by evidence
- Inference: conclusion derived from evidence
- Hypothesis: plausible but not yet validated
- Unknown: material information still missing

Do not create false certainty for rhetorical strength.

### 4. Build the argument

Determine the minimum set of claims needed to support the governing thought.

Group related evidence into coherent argument blocks.

Use MECE as a diagnostic when useful, not as a requirement.

Prefer 2-5 major argument blocks when that improves comprehension, but do
not invent or remove arguments merely to reach a target count.

For every major claim ask:

1. How does this support the governing thought?
2. What evidence supports it?
3. What would a skeptical audience challenge?
4. Is the evidence a fact, inference, hypothesis, or unknown?

### 5. Build the storyline before slides

Write a sequence of short declarative messages.

Each message should advance the audience from its current understanding
toward the desired outcome.

Do not think about slide layouts yet.

Run the storyline-only test: read only the messages in order. They should
form a coherent argument without seeing any slide body. Remove messages
that do not materially advance the argument.

### 6. Convert storyline beats into slide-level plans

For each storyline beat determine:

```
Slide:
Action title:
Role in argument:
Evidence:
Best visual form:
Transition to next slide:
Epistemic status:
```

Prefer one primary message per slide. A title should usually state the
takeaway rather than merely name the topic.

Bad: `Market analysis`
Better: `Enterprise demand is shifting toward lower-cost managed services`

The slide body exists to prove or explain the title. One storyline beat
may require multiple slides when the evidence is complex. Several closely
related beats may share a slide when doing so improves clarity. Do not
optimize for an arbitrary slide count.

This step produces slide-level *plans*, not slide *designs*. Visual
composition is out of scope for this skill.

### 7. Design the opening and ending

The opening should rapidly establish enough context for the audience to
understand why the governing question matters.

For executive or approval decks, prefer answer-first communication unless
there is a strong reason not to.

The ending should make the implication explicit:

- decision requested
- recommendation
- next action
- unresolved question

Do not end simply because the evidence has run out.

### 8. Red-team the storyline

Before handing off, run these tests:

- **Story test**: do the action titles alone tell the story?
- **Question test**: does the deck actually answer the governing question?
- **Evidence test**: is every important claim traced to evidence or
  labeled as a hypothesis?
- **Audience test**: does each section help this audience make the
  intended decision?
- **Necessity test**: if a slide disappeared, would the argument
  materially weaken? If not, remove or move it to the appendix.
- **Challenge test**: are the strongest obvious objections addressed?
- **Transition test**: does each slide create a natural reason for the
  next slide to exist?

Revise until these tests pass. For worked good/bad examples see
`references/examples.md`; for failure modes see `references/anti-patterns.md`.

## Output

Fill in `assets/storyline-template.md` and return it. The template has:

- Deck thesis (audience, desired outcome, governing question, governing thought)
- Storyline table (# / action title / role / evidence / visual idea / status)
- Key objections and risks
- Appendix candidates
- Open evidence gaps

## When to hand off

This skill stops at a coherent storyline plus slide-level plans; it does
not produce slides. Hand off to `presentation-architect` for slide-level
composition (visual grammar, layout, review rubric), or to a rendering
skill (pptx, marp, google-slides, keynote) for actual slide generation.
If the user asks for visuals directly, produce the storyline first and
note that visual composition is the next skill's job.
