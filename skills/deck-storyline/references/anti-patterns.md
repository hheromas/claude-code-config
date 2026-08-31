# Anti-Patterns

Recurring failure modes in deck storyline design. Each entry names the pattern, explains why it happens, gives a detection test, and states the corrective move. Read this file before publishing a storyline — several of these patterns feel productive from the inside.

## Quick reference

| Pattern | One-line detection test |
|---|---|
| Fact-hypothesis confusion | Can you point to the primary source for every numbered claim? |
| Framework abuse (forcing OPQ / SCQA / Pyramid) | Did you pick the framework before understanding the audience's Q? |
| The "I worked on it, so it goes in" reflex | Does this slide's removal weaken the argument, or only the effort narrative? |
| Slide-layout thinking before storyline | Are you thinking about charts and formatting before the title stack passes the story test? |
| Governing question set before audience is specified | Can you name the audience concretely — one person or one role? |
| False certainty for rhetorical effect | Are hedge words removed because they were fluff, or because they sounded weak? |
| Author-owned Q | Would answering the Q let the audience take their next action? |
| Ungrouped evidence pile | Can you state a one-line summary above each cluster of evidence? |

## 1. Fact-hypothesis confusion

**Pattern.** Facts, inferences, and hypotheses appear side by side on the same slide, in the same font, with no distinction. The audience treats them all as facts (or all as guesses, if enough of them are visibly shaky).

**Why it happens.** In the analyst's head, the distinction is obvious — they lived through gathering the evidence. In the reader's head, the distinction is invisible unless it is on the page. The gap between the two is systematically underestimated.

**Detection.** For each numbered claim on a slide, ask: "Could I point to the primary evidence right now? If not, what makes this true?" If the answer for even one claim is "I inferred it" or "it seemed plausible", the slide has unlabeled hypotheses.

**Corrective move.** Label every material claim with its epistemic status (Fact / Inference / Hypothesis / Unknown). Attach labels to numbers too — "40 hours saved / month **[hypothesis, pre-interview]**". Add a legend if labels are used inline. See also: [frameworks.md](frameworks.md#epistemic-labels--fact--inference--hypothesis--unknown).

**Consequence of not fixing.** Two symmetric failures. Hypotheses treated as facts → decisions taken on shaky premises, re-litigated later when the premise fails. Facts treated as hypotheses → settled matters reopened, meetings loop.

## 2. Framework abuse — forcing OPQ, SCQA, or Pyramid

**Pattern.** The author picks a framework (usually the one they most recently learned) and forces the deck into it, regardless of whether the deck's job fits the framework.

**Why it happens.** Frameworks feel like structure. A deck that fits a framework feels defensible. The alternative — deciding what structure the audience's decision actually needs — is harder and less legible.

**Detection.** Ask: "Did I choose this framework before I could articulate the audience's Q?" If yes, the framework is a scaffold, not a fit. Also: does forcing the deck into the framework produce weird sections ("Complication" for a routine progress update, "Options" when only one path exists)? If so, the framework is not serving the material.

**Corrective move.** Pick the framework after articulating audience, Q, and desired outcome. If none of the standard frameworks fits, describe the argument shape in one paragraph and use that directly. Frameworks are diagnostic tools, not construction requirements. See also: [frameworks.md](frameworks.md#quick-reference), [deck-archetypes.md](deck-archetypes.md#choosing-an-archetype).

## 3. The "I worked on it, so it goes in" reflex

**Pattern.** Material appears in the deck because the author gathered it, not because it supports the argument. Sunk-cost driven inclusion. In the アジカ食品 example, the observation about high factory-floor morale is a clean instance — real, gathered with effort, and irrelevant to the recommendation.

**Why it happens.** Removing material feels like wasting the work done to gather it. Including it feels like getting credit. Neither instinct serves the audience.

**Detection.** For each slide or section, apply the necessity test: "If this disappeared, would the argument materially weaken?" If the honest answer is "no, but I want the reader to know I did this work", the material is decoration, not argument. See also: [examples.md](examples.md#example-1--アジカ食品-proposal-to-the-ceo).

**Corrective move.** Move the material to an appendix, or delete it. If the effort itself is what the audience needs to see (e.g., a research-methodology slide establishing credibility), state that role explicitly so the material is deliberate rather than instinctive.

## 4. Slide-layout thinking before storyline is stable

**Pattern.** The author opens PowerPoint (or Figma, Keynote, etc.) and starts arranging boxes, choosing chart types, and picking colors before the title stack passes the storyline-only test. Visual polish accumulates on a broken argument.

**Why it happens.** Layout work is immediately gratifying; storyline work is not. Visible progress on a slide feels like real progress. It is not.

**Detection.** Are you thinking about "should this be a bar chart or a table?" before you can read your action titles in sequence and hear a coherent argument? If yes, you are two steps ahead of the work.

**Corrective move.** Write the storyline outside the slide tool — plain text, one action title per line. Read the titles in order. Iterate until the argument holds. Only then think about visuals. The scope of this skill ends at the storyline; visual design is a separate concern handled elsewhere. See also: [SKILL.md](../SKILL.md).

## 5. Setting the governing question before specifying the audience

**Pattern.** The author writes the deck's Q as a generalized question ("what should we do about costs?") without pinning down who is in the room. The resulting deck tries to be relevant to everyone and lands with no one.

**Why it happens.** "The audience" often means five people with different roles. Rather than pick one to design for, the author averages — producing a deck aimed at a fictitious composite reader.

**Detection.** Can you name the primary audience concretely — one person by role or by name? If the answer is "well, several people will see it", press: whose decision does this deck exist to enable? If you cannot answer, the audience is undefined and any Q is arbitrary.

**Corrective move.** Pick a single primary audience. State it in the deck's thesis block. Design the argument to their Q. Secondary audiences get appendices marked by role, or a separate deck. See also: [examples.md](examples.md#example-4--same-topic-different-audience-q).

## 6. False certainty for rhetorical effect

**Pattern.** The author removes hedges ("possibly", "we think", "roughly") to sound more confident. Hypotheses become bare assertions. The deck sounds strong; it is actually less trustworthy.

**Why it happens.** Some presentation training explicitly recommends this ("assert with confidence, remove weak language"). It is bad advice at the epistemic level even when it improves prose rhythm. Removing a hedge does not change the underlying uncertainty — it hides it.

**Detection.** For each removed hedge, ask: was it removed because it was fluff (real fix), or because it made the claim sound uncertain (false certainty)? The second is a labeling failure disguised as an editing win.

**Corrective move.** Distinguish two operations. Delete hedges that add no information ("I think" before a factual claim). Preserve hedges that carry the claim's actual uncertainty; if the sentence rhythm suffers, restate the claim with an explicit epistemic label instead ("**[Hypothesis]** X will save ¥20M"). Confidence is expressed by accurate labeling, not by stripping labels. See also: [frameworks.md](frameworks.md#epistemic-labels--fact--inference--hypothesis--unknown).

**Source note.** The source material contains an internal contradiction on this point — an earlier section urges the author to remove hedges and assert confidently; a later section demands epistemic separation. This skill adopts the later position.

## 7. Author-owned Q instead of audience-owned Q

**Pattern.** The deck's Q is what the author wants to report, not what the audience wants to know. "What did we find in our cost analysis?" instead of "Which cost measures should the CEO approve?"

**Why it happens.** The author knows the material intimately and naturally frames the deck as an answer to "what did I learn?". The audience is not asking that question.

**Detection.** Apply the source's test: does answering the Q let the audience take their next action? If the Q is "what did we find?", the answer is "we found X" — and the audience's next action is unclear. If the Q is "which option should I approve?", the answer names an option and the audience can decide.

**Corrective move.** Rewrite the Q from the audience's decision seat. Then rewrite the governing thought to answer it directly. Often this reorders the entire deck: what was buried on slide 12 (the recommendation) rises to slide 1. See also: [frameworks.md](frameworks.md#opq-objective--problem--question), [examples.md](examples.md#example-1--アジカ食品-proposal-to-the-ceo).

## 8. Ungrouped evidence pile

**Pattern.** Ten pieces of evidence are listed in sequence with no summary layer above them. The audience must group in their head. A skeptical listener picks apart individual items before ever seeing the aggregate claim, and the discussion never zooms back out.

**Why it happens.** All ten pieces feel important to the author, and grouping them requires deciding which summary sentence they roll up to — a harder cognitive step than listing.

**Detection.** For each cluster of evidence on a slide, ask: "Is there a one-line summary sentence above this cluster that names the aggregate claim, in message form (predicate + number)?" If the "summary" is a topic label ("Cost drivers"), the cluster is ungrouped.

**Corrective move.** Group evidence into 2-5 clusters, each with a message-shaped summary line. The summary lines together should support the governing thought. Numbers roll up (child sums = parent sum). See also: [frameworks.md](frameworks.md#pyramid-principle), [examples.md](examples.md#example-2--pyramid-grouping-under-the-recommendation).

## 9. Ending because the evidence has run out

**Pattern.** The deck stops after the last slide of analysis, with no explicit implication, decision request, or next action. The audience is left holding a completed argument with no place to put it.

**Why it happens.** The author's work is finished when the evidence is presented. The audience's work is only beginning at that point — and the deck fails to hand them the next step.

**Detection.** Read the last slide alone. Does it name a decision requested, a recommendation, a next action, or an explicit open question? If it reads as "and that concludes the analysis", the ending is missing.

**Corrective move.** End with one of: decision requested (with by-when and by-whom), recommendation, next action, or unresolved question the audience should hold. Choose based on the deck's archetype. See also: [deck-archetypes.md](deck-archetypes.md#quick-reference).

---

See also: [SKILL.md](../SKILL.md), [frameworks.md](frameworks.md), [deck-archetypes.md](deck-archetypes.md), [examples.md](examples.md), [meeting-decks.md](meeting-decks.md)
