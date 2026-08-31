# Meeting Decks

Meeting decks are not read-later decks. The audience is in the room, the deck is a discussion scaffold, and the deliverable of the meeting is a decision — not a completed reading experience. This file collects the design differences.

## Meeting deck vs. read-later deck

| Dimension | Meeting deck | Read-later deck |
|---|---|---|
| Information density per slide | Sparse — the presenter fills in the rest live | Dense — the slide must stand alone |
| Argument load | Carried by discussion + slides together | Carried entirely by slides |
| Purpose | Aligns the room and produces a decision | Transfers a completed argument to an absent reader |
| Optimal length | Only as long as the agenda supports | As long as the argument requires |
| Ending | Decisions taken + next actions logged | Recommendation + ask |
| Appendix | Larger — anticipates discussion detours | Smaller — off-argument material is deleted |

A single deck cannot serve both modes well. If the same file must play both roles, decide which mode it optimizes for and treat the other as a fallback. Common compromise: build the meeting deck sparse, then produce a read-later summary (or annotated version) after the meeting.

## Agenda alignment is the deck's spine

A meeting deck's structure must map onto the agenda one-to-one. When the deck's structure and the agenda drift apart, the room loses track of where they are.

The source material's "4-block" structure encodes this:

| Block | Content | Purpose |
|---|---|---|
| **① 前回の振り返り** — Recap | What was decided last time, what happened since | Restore shared context |
| **② 今回のミーティングゴール** — Goal | Who should be moved to do what by the end of this meeting (1-2 lines) | Declare the point of the meeting |
| **③ 本論** — Body | Whole picture → today's branch, options, decision points | Provide decision material |
| **④ ネクストアクション** — Next actions | Who, what, by when | Prevent post-meeting drift |

Skipping ① or ② produces the "status-report trap" — a meeting that shares information but decides nothing. Skipping ④ produces "who was going to do that?" the following week.

Put all four blocks on the opening slide before entering the body.

## Whole-picture → today's branch

At the start of the body, show the whole-picture map with "you are here" marked. Even one line will do:

```
Phase 1 [done] → Phase 2 [in progress, today's topic] → Phase 3 [not started]
```

The audience has been context-switching between meetings and other work; they need 30 seconds to re-enter this project's map. Skipping this step produces "wait, which decision are we making again?" three slides in.

## Announce which "type" you are discussing

The source names seven meeting-type roles (ASIS / TOBE-current / GAP / TOBE-target / Roadmap / Schedule / Team). The reason to know them is not the taxonomy itself — it is that **a meeting derails when different participants think they are discussing different types**.

Example (from source, アジカ食品):

> - CEO: "So when do we go live?" (asking about ⑥ Schedule)
> - IT: "Right now purchase orders are paper and fax..." (talking about ① ASIS)
> - You: "The ideal is direct ERP integration..." (talking about ④ TOBE-target)
>
> Three people, three types, no convergence.

Fix: at the meeting's opening, name the type — "today we align on ④ TOBE-target and ⑤ Roadmap; ① ASIS was closed last time." Then a participant who drifts into a different type is visibly off-agenda.

## Live-vs-read-later information density

Because the presenter fills in the rest live, meeting-deck slides can be sparse — often just an action title plus a chart, table, or 3-bullet skeleton. Fully-written prose on a meeting slide competes with the presenter for the audience's attention.

Read-later decks invert this: every slide must be readable without narration, so density rises.

If the same deck must survive both modes, add a densifying appendix or presenter notes rather than compressing everything onto each slide. The slide the audience sees during the meeting should stay sparse; the read-later version pulls detail up from notes.

## Action items and follow-ups

Every meeting deck ends with a next-action block, not with "any questions?". The block has three columns:

| Owner | Action | Due |

Rules:

- Every action has exactly one owner (a name, not a team).
- "Discuss with X" is not an action — the action is "get X's decision on Y by Z".
- Actions carried over from the last meeting appear in the recap block (①) with their current status. Carry-over that never resolves is a symptom; surface it explicitly.

For status decks that report progress: each RAG-colored (green / yellow / red) status item must pair with an action or a decision request. Red items with no ask are noise. See also: [deck-archetypes.md](deck-archetypes.md#update--status-deck-progress-report-to-a-standing-forum).

## Relationship to meeting minutes

Two common patterns:

- **Deck-as-minutes**: The deck is annotated live during the meeting (decisions, owners, dates written on the slides), and the annotated deck is the record. Works when the meeting's outputs fit on the existing slides.
- **Deck-then-minutes**: The deck drives discussion; a separate short minutes doc captures decisions and actions afterward. Works when the meeting produces outputs the deck did not anticipate.

Pick one convention per recurring meeting and stick to it. Mixing produces "was the decision on the deck or in the minutes?" ambiguity a week later.

Whichever convention: decisions and actions must be captured in **writing** during the meeting, not from memory afterward. The failure mode is not "we forgot to write things down" — it is "we wrote them down in a form only the note-taker can decode".

## Hypotheses vs. facts in a meeting context

The Fact / Hypothesis / Unknown labels (See also: [frameworks.md](frameworks.md#epistemic-labels--fact--inference--hypothesis--unknown)) matter more in meeting decks than in read-later decks, because the room will make decisions based on what appears on the slide.

- A hypothesis presented as a fact → the meeting takes a decision on a shaky premise → the decision gets re-litigated once the premise fails.
- A fact treated as a hypothesis → the meeting reopens settled decisions → progress stalls.

Convention: declare status before each numbered claim ("this is a confirmed fact / this is my current hypothesis"). Attach labels to numbers too — "40 hours saved / month **[hypothesis, pre-interview]**".

Every hypothesis on a meeting deck should map to a next-action item that says who will verify it, by when.

## When not to hold the meeting at all

The source contains a diagnostic worth keeping: **if you cannot write in one line what will be decided in the meeting, do not hold it — send an email or a dashboard update instead.**

Applied to deck design: draft slide ② (the goal / decision block) first. If you cannot draft it, the meeting is unnecessary. If you can draft it, the rest of the deck aligns to it.

---

See also: [SKILL.md](../SKILL.md), [frameworks.md](frameworks.md), [deck-archetypes.md](deck-archetypes.md), [anti-patterns.md](anti-patterns.md), [examples.md](examples.md)
