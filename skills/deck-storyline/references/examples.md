# Examples

Worked before / after comparisons of storyline design. Each example shows what the material looked like when it failed and what changed when the storyline was redesigned. Read the analytical framing after each example, not the surface prose difference.

## Example 1 — アジカ食品: proposal to the CEO

**Situation.** Tanaka, in corporate planning, must brief the CEO on the first half's cost overrun and propose a response. He has cost figures, competitor observations, and factory-visit notes.

### Before — the diffuse report

> CEO,
>
> Reporting on H1 results. Manufacturing costs are up 8% YoY. Raw materials +12%, utilities +15%, labor +5%. Logistics +7%. Revenue is up 3%. Competitors are also seeing cost pressure. On my recent factory visit I confirmed that on-the-ground morale is high. We will need to consider various measures going forward. Please advise.
>
> — Tanaka, Corporate Planning

The CEO's likely response: "So what are you saying?"

**What went wrong at the storyline level:**

| Problem | Diagnosis |
|---|---|
| No governing thought | The document reports facts and ends without a claim. |
| Author-owned Q | The implicit Q is "what did we observe?" The CEO's Q is "what should we do?" |
| Argument blocks are ungrouped | Six figures listed in sequence with no summary layer above them. |
| Irrelevant material included | Competitor commentary and factory-morale observation do not support any recommendation. They are in the deck because Tanaka noticed them, not because the CEO needs them. |
| Ends without an ask | "Please advise" is not a decision request. |

### After — the redesigned brief

> CEO,
>
> To address the H1 cost overrun, I recommend concentrated investment in raw-materials cost reduction, yielding annual savings of ¥30M.
>
> There are two reasons.
>
> First, supplier consolidation yields ¥14M annually: switching to domestic alternate suppliers (¥10M) and lot-size optimization (¥4M).
>
> Second, utilities measures yield ¥16M annually: LED conversion (¥8M), energy-efficient equipment (¥6M), off-peak power (¥2M).
>
> Requesting your approval to execute these measures.
>
> — Tanaka, Corporate Planning

**What changed at the storyline level:**

| Change | Effect |
|---|---|
| Governing thought comes first | The CEO knows the recommendation before reading further. |
| Audience-owned Q | The Q is now "which measures should I approve?", which matches what the CEO needs to decide. |
| Argument blocks are grouped | Six individual measures become two summary blocks (supplier / utilities), each with a message-shaped headline and a clear yen figure. |
| Structural preview ("two reasons") | Reader knows what to expect; comprehension is easier. |
| Irrelevant material removed | Competitor and morale observations are gone — they did not support the recommendation. |
| Ends with an ask | Explicit approval request. |

### The transferable lesson

The Before is not badly written prose — it is prose written without a storyline. The redesign is not about polish; it is about deciding, before writing, what the CEO's Q is, what the answer is, and which observations support the answer versus which merely came out of the analyst's notebook.

Note also the discipline of removing observations Tanaka worked to gather. The morale observation is real, and Tanaka likely felt it was worth including. In a storyline redesign, "I noticed it" is not sufficient grounds for inclusion; "it supports the governing thought" is. See also: [anti-patterns.md](anti-patterns.md#the-i-worked-on-it-so-it-goes-in-reflex).

## Example 2 — Pyramid grouping under the recommendation

The same アジカ食品 material, shown as the pyramid the redesigned brief encodes:

```
[Governing thought]
Concentrating investment on raw-materials cost reduction
yields ¥30M annual savings.
    │
    ├─ [A: supplier consolidation] ¥14M annually
    │      ├─ switch to domestic alternate suppliers → ¥10M
    │      ├─ consolidate 5 suppliers → 3 suppliers
    │      └─ annual contracts locking prices → (enabler)
    │
    └─ [B: utilities measures] ¥16M annually
           ├─ LED conversion → ¥8M
           ├─ energy-efficient equipment → ¥6M
           └─ off-peak power → ¥2M
```

**What the pyramid enforces:**

- Every summary node is a **message** with a predicate and a number, not a topic label ("Cost drivers"). See also: [frameworks.md](frameworks.md#pyramid-principle).
- Summary numbers sum to the governing thought's number (¥14M + ¥16M = ¥30M). A pyramid where the numbers do not roll up is broken.
- The pyramid can be tested by reading only the top two layers: does it still make an argument? If yes, the structure holds.

### Before-grouping vs. after-grouping (source material's ungrouped list)

The same underlying measures, without grouping:

> - LED conversion → ¥8M
> - Switch to domestic alternate suppliers → ¥10M
> - Energy-efficient equipment → ¥6M
> - Lot-size optimization → ¥4M
> - Off-peak power → ¥2M

Five items, no summary, no clear top-level claim. The audience must group in their head to see the argument. A skeptical listener starts asking about individual line items ("is the LED number realistic?") before understanding the big claim, and the discussion never returns to the recommendation.

Grouping into two blocks with summary messages produces the argument the pyramid demonstrates above.

## Example 3 — Title-only test on a slide sequence

A short AI-adoption proposal, shown twice as a title stack.

**Before — topic titles:**

```
01  Considering AI adoption
02  Current issues
03  Market environment
04  Proposal contents
05  Expected effects
06  Schedule
```

Reading only these titles tells you the topic categories the deck covers. It does not tell you the argument. The deck fails the storyline-only test.

**After — action titles:**

```
01  Inquiry volume is exceeding the current 3-person team's capacity
02  62% of inquiries are template responses and thus automatable
03  Introducing AI first-response can reduce human handling by ~120 hours/month
04  Rather than full automation, phased rollout starting with low-risk categories is appropriate
05  A 3-month PoC can verify accuracy, hours saved, and mis-answer risk
06  Requesting approval of the ¥3M PoC budget this month
```

Reading only these titles, you know the claim, the reasoning, and the ask. The audience can grasp the argument in 30 seconds. The deck body then serves to prove each title.

**Transferable lesson.** Topic titles are a table of contents; action titles are the argument. A storyline is finished when the action titles alone tell the story. If the redesigned title stack cannot pass this test, the argument still has gaps — polishing the slide bodies will not close them.

## Example 4 — Same topic, different audience Q

The source material illustrates that the same underlying material generates different governing questions depending on audience:

| Audience | Their Q |
|---|---|
| CEO | "Does this fit strategy and return investment?" |
| CFO | "How big is the budget and what is the payback period?" |
| Line director | "How much does the burden on my team increase, and what are the risks?" |
| Line staff | "How does my day-to-day change?" |
| Shareholder | "When and how much will this affect earnings?" |

**Transferable lesson.** "The" deck for a topic does not exist. The same investigation produces five different decks depending on whose decision it supports. Attempting to make one deck serve all five audiences produces a deck that answers none of their questions well. See also: [deck-archetypes.md](deck-archetypes.md#choosing-an-archetype).

If the deck genuinely must serve multiple audiences (e.g., a board pack read by the CFO and the CEO), state which audience's Q the governing thought answers, and put audience-specific material in appendices marked by role.

---

See also: [SKILL.md](../SKILL.md), [frameworks.md](frameworks.md), [deck-archetypes.md](deck-archetypes.md), [anti-patterns.md](anti-patterns.md)
