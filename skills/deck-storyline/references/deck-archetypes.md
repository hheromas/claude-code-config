# Deck Archetypes

Deck-shaped work varies more than one framework can hold. This file names six recurring archetypes, and for each gives the audience's real question, what a governing thought looks like, the structural shape that usually works, and the failure mode to watch for.

Choose the archetype that matches the audience's decision context, not the archetype that matches the material you happen to have.

## Quick reference

| Archetype | Audience Q | Structural shape |
|---|---|---|
| Proposal | "Which option should I approve?" | OPQ or SCQA → recommendation → evidence → risks → ask |
| Decision | "Which choice is best, and why now?" | Decision question → options → criteria → recommendation |
| Update / Status | "What changed, and what do you need from me?" | What changed → implication → risks/asks → next actions |
| Kickoff | "What are we doing, who is doing it, and by when?" | Purpose → scope → plan → roles → decisions needed |
| Research / Technical | "What did you find, and how much should I trust it?" | Question → method → finding → implication → limitations |
| Review / Retrospective | "What worked, what didn't, and what changes next time?" | Objective vs. outcome → drivers → lessons → next-cycle actions |

## Proposal deck (client or internal)

**Audience Q.** "Given the situation, which option should I approve — and what am I approving exactly?" The audience is in a position to say yes or no. They are not interested in your analytic journey.

**Governing thought shape.** A one-sentence recommendation that names the action and its expected outcome: "Concentrate cost-reduction investment on raw materials to save ¥20M annually." Answer-first.

**Structural shape.** OPQ or SCQA opening → recommendation → 2-3 argument blocks (grouped evidence) → risks and mitigations → ask (decision requested, by when, by whom). See also: [frameworks.md](frameworks.md#opq-objective--problem--question), [frameworks.md](frameworks.md#scqa-situation--complication--question--answer).

**Failure mode.** "Author-owned narrative": leading with what you investigated ("we analyzed cost drivers"), then trickling toward the recommendation at the end. The audience closes the deck before you get there.

## Decision deck (executive approval, choice between named options)

**Audience Q.** "Which of these choices is best, given our criteria? What am I trading off if I pick differently?"

**Governing thought shape.** A named option plus a compressed reason: "Recommend Option B: highest 3-year ROI at acceptable execution risk." The reason must reference the criteria the audience cares about, not the criteria most convenient to measure.

**Structural shape.** Decision question → options (usually 2-4, including status-quo as an explicit option) → criteria (explicit, with weights if the audience will contest them) → scored comparison → recommendation → what changes if the audience overrides the recommendation.

**Failure mode.** Presenting only one option, or presenting a "recommended" option next to two obvious strawmen. Executives detect this immediately and lose trust in the analysis. Include at least one option that is defensible even if not preferred.

## Update / Status deck (progress report to a standing forum)

**Audience Q.** "What has changed since I last checked in, what does it imply for the plan, and what do you need from me right now?" The audience does not need the raw activity log — they need the delta plus the ask.

**Governing thought shape.** Not always a single sentence — often a change summary plus a decision request: "Development is 2 weeks behind due to X; recovery requires either +1 engineer or 1-week scope cut; need decision by Friday."

**Structural shape.** What changed (delta from last checkpoint) → business or plan implication → risks and open questions → asks (decisions or resources needed) → next actions.

**Failure mode.** "Progress narration" — reading through the activity list without stating implications or asks. If the deck could have been an email, it should have been. See also: [meeting-decks.md](meeting-decks.md#action-items-and-follow-ups).

Do not close with "any questions?" as the ending. Close with the ask.

## Kickoff deck (new project or new phase)

**Audience Q.** "What are we actually doing, who is responsible for what, and what decisions do I owe you now vs. later?"

**Governing thought shape.** Purpose plus scope boundary: "Deliver X for audience Y by date Z; explicitly out of scope: W." The out-of-scope statement matters as much as the in-scope one.

**Structural shape.** Purpose (why now) → scope (in / out) → deliverables and milestones → roles and decision rights → immediate decisions needed → open questions to be resolved in the first two weeks.

**Failure mode.** Vague scope ("improve customer experience") and vague roles ("cross-functional collaboration"). Kickoffs that avoid concrete commitments produce projects that drift for a quarter before anyone notices. Force specificity even when the natural instinct is to leave room.

## Research / technical deck (findings, evaluation, or investigation)

**Audience Q.** "What did you find, how much should I trust it, and what should I do differently as a result?" A technical audience wants the finding **and** its confidence level; a mixed audience wants the implication.

**Governing thought shape.** The finding stated as a claim, with its epistemic status attached: "**[Inference]** Latency regression is caused by connection-pool contention under concurrent read load." See also: [frameworks.md](frameworks.md#epistemic-labels--fact--inference--hypothesis--unknown).

**Structural shape.** Research question → method (enough to establish credibility, not a full paper) → finding → evidence → implication → limitations → open questions. Do not force this into a proposal frame — a research deck's "ask" is often "does this change our plan?", not a budget approval.

**Failure mode.** Overclaiming certainty (dropping the "inference" label to sound decisive), or the reverse — burying the finding under so many caveats the audience cannot extract it. The fix is to state the finding as a labeled claim, then discuss limitations in a dedicated slot.

Also common: burning the opening on method when the audience wants the finding first. If the audience trusts your team's methodology in general, lead with the finding and defer method to a middle slide or appendix.

## Review / retrospective deck (looking back on a phase or project)

**Audience Q.** "What actually happened relative to what we planned, why, and what are we changing next cycle?"

**Governing thought shape.** A one-sentence delta plus one-sentence adjustment: "Delivered 80% of scope on time; the 20% miss was driven by underestimating integration work; next cycle we will scope integration explicitly and staff it earlier."

**Structural shape.** Objective vs. outcome (the honest delta) → root drivers of the delta (not just proximate causes) → lessons → concrete changes for the next cycle → open questions.

**Failure mode.** Two symmetric failures. The self-congratulatory retrospective ("everything went well, minor improvements possible") — audiences learn nothing and trust erodes. The self-flagellating retrospective ("we failed on every front") — the honest signal drowns in undifferentiated regret. Neither produces next-cycle changes. Force yourself to state both what you would repeat and what you would change, with equal specificity.

---

## Choosing an archetype

Two diagnostic questions:

1. **What decision, belief, or action does the audience owe as a result of seeing this deck?** The archetype should match the shape of that decision. A budget approval is a proposal; a "which vendor" is a decision deck; "here is what we found" is a research deck.

2. **Is the audience's question already sharp, or does the deck need to sharpen it?** If sharp → answer-first structure (proposal / decision). If diffuse → context-first structure (research / kickoff / retrospective).

A deck can straddle archetypes (e.g., a research deck that ends with a proposal). When that happens, either split the deck or make the transition explicit — do not silently pivot from research-mode to proposal-mode mid-deck.

---

See also: [SKILL.md](../SKILL.md), [frameworks.md](frameworks.md), [meeting-decks.md](meeting-decks.md), [anti-patterns.md](anti-patterns.md)
