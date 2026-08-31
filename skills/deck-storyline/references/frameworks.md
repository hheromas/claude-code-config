# Frameworks

Framing tools for shaping a deck's argument. Choose one that fits the task; do not force a deck into a framework that does not suit it. This file covers the frameworks named by the source material; it is not an exhaustive catalog.

## Quick reference

| Framework | Best for | Skip when |
|---|---|---|
| OPQ (Objective / Problem / Question) | Proposals where audience already has a felt problem | Audience question is unknown or the audience is not in decision mode |
| SCQA (Situation / Complication / Question / Answer) | Executive summaries, opening slides, memos | The situation is already common knowledge to the audience |
| Pyramid Principle | Any deck where governing thought → grouped evidence must be scannable | Exploratory or open-ended discussion where a single thesis has not emerged |
| MECE | Diagnostic to check whether argument blocks overlap or leave gaps | As a hard requirement; forcing MECE onto messy reality creates false neatness |
| 演繹法 (deduction) | Chains where a premise + rule yields a specific implication | Insight comes from multiple independent cases rather than a rule |
| 帰納法 (induction) | Grouping multiple observations into a summary claim | Only one datapoint exists; single-case induction is fragile |
| Epistemic labels (Fact / Inference / Hypothesis / Unknown) | Every deck; applies at the claim level, not the framework level | Never skip |

## OPQ (Objective / Problem / Question)

OPQ organizes the audience's mental state into three elements before you write anything:

| Element | Meaning | Prompt |
|---|---|---|
| **O** — Objective | The ideal state the audience is trying to reach | "What is the audience trying to achieve?" |
| **P** — Problem | The gap between the ideal and the current state | "What is blocking them?" |
| **Q** — Question | What the audience wants to know in order to close the gap | "What do they want to hear from me?" |

The answer to Q becomes the deck's governing thought (the main message of the pyramid, See also: [SKILL.md](../SKILL.md)).

**When to use.** Proposals and internal decisions where the audience has a felt problem and a concrete objective. Especially useful when the author is tempted to lead with what they investigated rather than what the audience needs to decide.

**When not to use.** When you cannot articulate the audience's Q without guessing, OPQ becomes performance. In that case, ask (or interview) before framing. Also skip when the deck is exploratory — OPQ presumes the audience has a specific question in mind.

**Common failure.** Author-owned Q ("What did my analysis find?") instead of audience-owned Q ("Which option should I approve?"). Test: does answering Q let the audience take their next action? If not, the Q is author-owned.

OPQ is a Japanese-language systematization popularized by Yamazaki (『入門 考える技術・書く技術』). Barbara Minto's original English formulation is SCQ/SCQA (below).

## SCQA (Situation / Complication / Question / Answer)

SCQA is Minto's Pyramid-Principle-native framing for openings and executive summaries:

- **Situation** — a state of affairs the audience already accepts as true
- **Complication** — something that disrupts the situation and forces action or attention
- **Question** — the question the audience naturally asks in response to the complication
- **Answer** — the governing thought that begins the pyramid

**When to use.** Openings that must earn the audience's attention in one paragraph. Written executive summaries. Any deck where "why are we in this room?" needs to be established before content.

**When not to use.** When the situation is stale or already fully known — restating it wastes the opening slot. Also skip when there is no genuine complication; SCQA fabricated onto routine updates sounds hollow.

**Common failure.** Skipping the complication or making it too abstract ("the world is changing"). A weak complication produces a weak Q, which produces a weak Answer.

## Pyramid Principle

The pyramid organizes the body of the argument:

```
[Governing thought]  (one-sentence answer to Q)
        |
   +----+----+----+
   |    |    |    |
 [A]  [B]  [C]      (2-5 supporting argument blocks)
   |    |    |
 evidence evidence evidence
```

Three rules:

1. Each layer supports the layer above it (vertical logic).
2. Elements at the same layer are MECE — mutually exclusive and collectively exhaustive as a diagnostic (horizontal logic).
3. A layer holds 2-5 elements (comprehension limit for one glance).

**When to use.** Any deck where the reader needs to scan the argument top-down and drill in only where they need to. Recommended default for decision decks, proposals, and structured reports.

**When not to use.** Exploratory decks with no settled thesis. If you are still thinking, you do not yet have a governing thought — do not fake one to fit the pyramid.

**Common failure.** Writing summary boxes as topic labels ("Cost analysis") instead of message sentences ("Materials-cost consolidation yields ¥20M annually"). A pyramid whose nodes are topic labels is a table of contents, not an argument. See also: [anti-patterns.md](anti-patterns.md#framework-abuse-forcing-opq-scqa-or-pyramid).

## MECE — as a diagnostic, not a requirement

MECE (Mutually Exclusive, Collectively Exhaustive) is useful for checking:

- **Overlap** — do two argument blocks make the same claim from different angles? If so, merge them.
- **Gaps** — is there a category of evidence the audience will notice is missing? If so, add it, or explicitly declare it out of scope.

Do not treat MECE as a construction rule. Real audiences do not need perfectly non-overlapping categories; they need the argument to hold together. Forcing every deck into MECE buckets produces contrived structures with pointless categories.

Rule of thumb: run MECE **after** the argument blocks are drafted, as a red-team pass. If a block fails MECE but improves comprehension, the block wins.

## 論理接続 — Deduction vs. Induction

The two ways evidence can support a claim:

| Pattern | Shape | Example |
|---|---|---|
| **Deduction (演繹)** | Premise + rule → specific conclusion | "Costs rising + revenue flat → margins will compress" |
| **Induction (帰納)** | Multiple observations → summary claim | "Company A, B, and C all raised prices → industry-wide cost pressure" |

Most proposal decks use induction: several concrete observations grouped into a summary message. Deduction shows up in risk arguments and forward projections.

Do not overclaim induction from one or two datapoints. If evidence is sparse, label the summary as an inference or hypothesis (see below), not a fact.

The source material describes induction as "9 out of 10 practical uses". Treat that as description, not prescription — the correct choice depends on evidence shape, not on genre.

## 相手の頭の中 — Three-element audience model

Before writing a deck, describe the audience along three dimensions:

1. **What they currently know** — the factual/contextual baseline they will bring into the room. Do not repeat this at length; use it to set the opening.
2. **What they currently believe** — their working interpretation, hypothesis, or bias. This is what the deck needs to confirm, refine, or challenge.
3. **What they will decide, believe, or do differently** — the concrete change the deck aims to produce.

The third element is the deck's success condition. If you cannot state it in one sentence, the deck's purpose is not yet defined.

This generalizes the source material's Japanese "誰を／どうさせる" formulation into a form that works for research, technical, and internal decks — not only for sales proposals.

## Epistemic labels — Fact / Inference / Hypothesis / Unknown

Every material claim carries an epistemic status. Labeling it prevents the single most damaging failure mode: fact-hypothesis混同 (See also: [anti-patterns.md](anti-patterns.md#fact-hypothesis-confusion)).

| Label | Meaning | Must include |
|---|---|---|
| **Fact** | Directly supported by primary evidence | Source, date, who verified |
| **Inference** | Conclusion derived from evidence via a stated reasoning step | The evidence + the reasoning step |
| **Hypothesis** | Plausible but not yet validated | Grounds + the assumption it depends on + planned verification |
| **Unknown** | Material information is missing | Who will confirm it, by when, and how |

Operational conventions (from the source):

- Put a legend on the deck if labels are used inline (e.g., facts in black, hypotheses in blue, unknowns in red).
- Attach labels to numbers too: "40 hours saved / month **[hypothesis, pre-field-interview]**".
- Every hypothesis in the deck should map to a specific verification action in the next-action list.

Do not create false certainty for rhetorical strength. The source material contains an internal contradiction on this point — its earlier section urges the writer to "assert with confidence" and remove hedges, while its later section demands epistemic separation. This skill adopts the later position. Confidence is expressed by labeling accurately, not by removing labels.

---

See also: [SKILL.md](../SKILL.md), [deck-archetypes.md](deck-archetypes.md), [anti-patterns.md](anti-patterns.md), [examples.md](examples.md)
