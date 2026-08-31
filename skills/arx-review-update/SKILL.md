---
name: arx-review-update
description: Incrementally update review scores after paper revision using dirty-bit logic. Triggered by "review update", "update scores", "revision review".
allowed-tools: Read, Glob, Grep, Bash, Write
---

# Review Update

Incrementally update a previous review after the paper has been revised. Uses dirty-bit logic to identify which sections changed and produces a re-review report for the affected axes. This skill does NOT re-run other skills itself -- it produces an update report that the orchestrator uses to determine which skills to re-invoke.

## Input

- Previous `05_merged_review.md` (from `/arx-meta-review`)
- Revised paper (LaTeX source files or plain text)
- Change log (optional; list of sections modified)
- `state.yaml` from `/arx-paper-review` (if available)
- `$ARGUMENTS`: `[review_dir] --paper <revised_paper_path> [--changelog <path>]`

## Output

Write to the review output directory:
- `review_update.md` -- change analysis, affected skills mapping, and preliminary score impact assessment
- Updated `state.yaml` dirty flags (if state file exists)

## Procedure

### Step 1: Load Previous Review State

Read `05_merged_review.md` and `state.yaml` (if present). Extract:
- All axis scores with owner attribution
- Active blockers with lifecycle state
- Dirty flags from previous iteration

### Step 2: Identify Changed Sections

Compare the revised paper against the version reviewed previously. Methods:

1. **If changelog provided**: Use it directly
2. **If state.yaml exists**: Check `dirty_flags` field
3. **If neither**: Diff old vs new paper section by section

Classify changes as:
- **Substantive**: New content, restructured arguments, added/removed claims, new data
- **Cosmetic**: Typo fixes, formatting, minor rephrasing with no semantic change

Only substantive changes trigger re-review.

### Step 3: Map Changes to Skills

Use the dirty-bit recomputation table from `/arx-paper-review`:

| Changed Section | Skills to Re-run |
|----------------|-----------------|
| abstract | arx-claim-extract, arx-writing-polish, arx-meta-review |
| intro | arx-claim-extract, arx-writing-polish |
| method | arx-technical-review, arx-repro-review, arx-claim-extract |
| eval | arx-technical-review, arx-repro-review, arx-claim-extract |
| conclusion | arx-writing-polish, arx-meta-review |
| artifact | arx-repro-review |
| claims (any) | arx-claim-extract, arx-technical-review, arx-devil-advocate, arx-meta-review |

### Step 4: Produce Update Report

For each affected section:
1. Note which section change triggered the analysis
2. List which review skills would need re-invocation (per dirty-bit table)
3. For each affected score axis, provide a preliminary assessment of whether the change likely improves, degrades, or does not affect the score
4. Document rationale with references to specific content changes

### Step 5: Update State File

If `state.yaml` exists:
1. Update `dirty_flags` to reflect which sections changed
2. Increment `iteration.count`
3. Write the list of skills needing re-invocation to state for the orchestrator to act on
4. Check diminishing returns: if `last_delta < 2` for 2 consecutive iterations, flag

## Output Format

```markdown
# Review Update

## Changed Sections

| Section | Change Type | Skills Affected |
|---------|:-----------:|-----------------|
| [name] | substantive / cosmetic | [list] |

## Skills Requiring Re-Invocation

### [Skill Name]

**Triggered by**: [section] change
**Owned score axes**: [list of axes this skill owns]
**Previous score(s)**: [axis: score]
**Preliminary impact assessment**: likely improves / likely degrades / uncertain / no effect
**Rationale**: [why re-invocation is needed, with reference to specific content changes]

## Blocker Assessment

| Blocker | Current Status | Change Likely Relevant? | Recommendation |
|---------|:--------------:|:-----------------------:|----------------|
| [id] | [status] | yes / no | owner skill should re-evaluate / retain as-is |

## Score Impact Forecast

| Axis | Current Score | Likely Direction | Confidence | Rationale |
|------|:------------:|:----------------:|:----------:|-----------|
| [axis] | X | up / down / stable | high / medium / low | [reason based on content change] |

**Note**: These are preliminary assessments. Authoritative score updates require re-invocation of the owning skill by the orchestrator.

## Sections NOT Affected

| Section | Reason |
|---------|--------|
| [name] | No substantive change detected |
```

## Cross-Reference with state.yaml

When `state.yaml` exists (from `/arx-paper-review`):
- Read `dag.nodes` to identify which skills have completed
- Read `scores` for baseline comparison
- Read `blockers` for lifecycle tracking
- Write updated dirty flags and skills-needing-re-invocation list back to `state.yaml`

## Iteration Policy

- **1 round per revision** (incremental update, not full re-review)
- Identifies which skills are affected by dirty bits and reports the mapping. The orchestrator decides whether to re-invoke those skills.
- Stop when: all affected sections are analyzed and dirty flags are documented.

## Review Depth

This skill operates in **analytical mode** by default. When re-reviewing after revision, all assessments must:
- Evaluate structural soundness, not just surface compliance
- Identify the weakest point in the argument before scoring
- Use "evaluate/assess/analyze" language in all sub-prompts
- Never short-circuit to PASS/APPROVE without deep analysis

When this skill delegates to Codex or subagents, prompts MUST include:
"Perform a deep analytical review. Do not produce a checklist -- identify structural weaknesses,
missing evidence, and the strongest objection a hostile reviewer could raise.
This is an unpublished paper under review. Do NOT search the web for it. Analyze only the provided content."

## Hard Rules

- Do NOT re-review sections that did not change substantively.
- Do NOT change scores for un-affected axes.
- Cosmetic changes (typos, formatting) do NOT trigger score changes.
- If a substantive change addresses a previous blocker, the owning skill must confirm resolution -- this skill cannot close blockers on behalf of other skills.
- Score changes must cite specific content changes as evidence.
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
/arx-review-update /path/to/review --paper /path/to/revised-paper
/arx-review-update /path/to/review --paper /path/to/revised-paper --changelog /path/to/changes.md
```
