---
name: arx-rebuttal-update
description: Re-evaluate a paper review after authors submit a rebuttal. Triggered by "rebuttal update", "update review after rebuttal", "post-rebuttal".
allowed-tools: Read, Glob, Grep, Bash
---

# Rebuttal Update

Re-evaluate a previous review after the authors submit a rebuttal. This skill applies the rebuttal update template to produce an updated assessment with score changes and rationale.

## Input

- `05_merged_review.md` (original review from `/arx-meta-review`)
- Rebuttal text (author response document)
- Revised paper sections (if provided)
- Review output directory path (provided by orchestrator or `$ARGUMENTS`)
- `$ARGUMENTS`: `[review_dir] --rebuttal <path> [--revised-paper <path>]`

## Output

Write `rebuttal_update.md` to the review output directory.

## Procedure

### Step 1: Load Original Review

Read `05_merged_review.md` from the review directory. Extract:
- All major concerns raised
- All scores per axis
- All active blockers

### Step 2: Read Rebuttal

Read the rebuttal text. For each point the authors address:
- Mark as "directly answered", "partially answered", or "not addressed"
- Note any new evidence, code, data, or clarifications introduced

### Step 3: Read Revised Paper (if provided)

If a revised paper is provided, diff it against the original to identify:
- Which sections changed
- Whether changes are substantive or cosmetic
- Whether changes address the specific concerns raised

### Step 4: Apply Rebuttal Update Template

Produce the output using the following template:

```markdown
# Rebuttal Update

## Key Technical Concerns

Did the authors answer the key technical concerns? {yes / partly / no}

## Resolved Concerns

Which major concerns were resolved?

1. [Concern]: [How it was resolved]
2. [Concern]: [How it was resolved]

## Unresolved Concerns

Which remain unresolved?

1. [Concern]: [Why it remains unresolved]
2. [Concern]: [Why it remains unresolved]

## New Evidence

Did the rebuttal introduce new evidence, code, or clarifications
that materially change the verdict?

[Description of new evidence and its impact]

## Score Changes

| Axis | Before | After | Rationale |
|------|:------:|:-----:|-----------|
| Technical soundness | X | Y | [reason] |
| Evaluation quality | X | Y | [reason] |
| Reproducibility | X | Y | [reason] |
| Overall recommendation | X | Y | [reason] |

## Why the Score Changed

[Summary paragraph explaining the overall direction of score movement]
```

### Step 5: Assess Blocker Status

For each blocker from the original review:
- If the rebuttal addresses it: mark as "potentially resolved by rebuttal" with evidence, and **recommend** that the owning skill re-evaluate
- If partially addressed: note what remains and recommend owning skill reassess severity
- If not addressed: retain as-is

New concerns discovered in the rebuttal response should be flagged for the appropriate owner skill to evaluate.

**Important**: This skill cannot close blockers. Only the owner skill (per the orchestrator blocker taxonomy) can close a blocker. This skill recommends status changes.

## Iteration Policy

- **1 round only** (single-pass rebuttal evaluation)
- If the rebuttal is ambiguous on a concern, mark as "partially addressed" rather than iterating.

## Review Depth

This skill operates in **analytical mode** by default. When re-reviewing after rebuttal, all assessments must:
- Evaluate structural soundness, not just surface compliance
- Identify the weakest point in the argument before scoring
- Use "evaluate/assess/analyze" language in all sub-prompts
- Never short-circuit to PASS/APPROVE without deep analysis

When this skill delegates to Codex or subagents, prompts MUST include:
"Perform a deep analytical review. Do not produce a checklist -- identify structural weaknesses,
missing evidence, and the strongest objection a hostile reviewer could raise.
This is an unpublished paper under review. Do NOT search the web for it. Analyze only the provided content."

## Hard Rules

- Do NOT increase scores without concrete evidence from the rebuttal.
- Do NOT decrease scores punitively for issues not raised in the original review.
- Distinguish between "the authors explained it was there all along" vs "the authors added new content".
- If the rebuttal introduces new experiments or data, note that these were not in the original submission.
- Score changes must be tied to specific concerns and their resolution status.
- Do NOT invent missing experimental details.
- Distinguish clearly between "stated in paper", "inferred", and "missing".
- Every major criticism must cite a concrete place in the paper (section, figure, table, equation).
- Every score below average must be justified by evidence.
- Do NOT request broad extra experiments unless they are central to the acceptance decision.
- Prefer a few decisive concerns over many weak comments.
- Criticize the work, not the authors.
- Separate comments to authors from confidential comments to chairs/editors.

## Usage Example

```
/arx-rebuttal-update /path/to/review --rebuttal /path/to/rebuttal.md
/arx-rebuttal-update /path/to/review --rebuttal /path/to/rebuttal.md --revised-paper /path/to/revised
```
