---
name: arx-meta-review
description: Final merge reviewer (called by arx-paper-review).
allowed-tools: Read, Grep, Glob, Bash
---

# Meta Reviewer

Merge all Stage 1-2 review outputs into a unified, calibrated review. This skill is invoked at Stage 3 of the `/arx-paper-review` orchestrator. It produces the final review form, author questions, and confidential chair note.

## Input

- `01_claim_map.md` (from `/arx-claim-extract`)
- `02_technical_review.md` (from `/arx-technical-review`)
- `03_repro_review.md` (from `/arx-repro-review`)
- `04_devil_advocate.md` (from `/arx-devil-advocate`)
- Individual scores from each skill
- Venue profile (from `/arx-venue-profile`)
- Review output directory path (provided by orchestrator or `$ARGUMENTS`)

## Output

Write three files to the review output directory:
1. `05_merged_review.md` -- complete review form with calibrated scores
2. `06_author_questions.md` -- questions for the authors
3. `07_confidential_chair_note.md` -- confidential comments to PC chair/editor

## Procedure

### Step 1: Collect and Reconcile Scores

Gather scores from each owner skill:

| Axis | Weight | Owner |
|------|:------:|-------|
| Problem significance | 10 | technical-review |
| Novelty / contribution | 15 | technical-review |
| Technical soundness | 20 | technical-review |
| Evaluation quality | 20 | technical-review |
| Reproducibility / artifact | 15 | repro-review |
| Clarity / organization | 10 | (writing-polish, or self-assess if Stage 4 not yet run) |
| Fit / impact on community | 10 | meta-review (this skill) |

Apply venue weight modifiers from the venue profile. For each axis:
```
display_score = (level / 5) * weight * venue_modifier
```

### Step 2: Score Update Rule

When re-running in iteration i+1:
```
new_score = old_score * 0.7 + current_assessment * 0.3
```

Override conditions (full replacement, not weighted update):
- Fatal blocker discovered
- Unsupported core claim discovered
- Major contradiction found
- Large information gain (e.g., artifact inspected for first time)

### Step 3: Conflict Resolution

Check for inconsistencies across review outputs:

1. **Score-concern mismatch**: High score but major concerns listed (or vice versa)
2. **Cross-reviewer contradiction**: Systems review says baselines are fair, but devil's advocate identifies unfairness
3. **Evidence disagreement**: Different reviewers cite the same evidence differently

For each conflict:
- State the conflict explicitly
- Provide the meta-reviewer's resolution with reasoning
- If unresolvable, flag for human escalation

### Step 3b: Dual-Review Convergence

When multiple reviewers (Claude + Codex, or multiple Claude subagents) independently
identify the same weakness:
- Mark it as **CONVERGED** in the merged review
- Increase confidence on that finding
- Converged findings get priority in the author questions list (Step 7)

Convergence detection: Two findings converge when they identify the same structural weakness
(not just the same section), even if phrased differently. Record convergence in the merged
review as:

```markdown
**[CONVERGED]** Both technical reviewer and devil's advocate independently flagged [weakness].
Confidence: HIGH.
```

### Step 4: Fit / Impact Assessment

Assess venue fit (this skill's owned score axis):

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | Highly relevant to venue; broad community interest; opens new directions |
| Good | 4 | Clear venue relevance; solid community interest |
| Mixed | 3 | Relevant but niche; limited broader impact |
| Weak | 2 | Marginal venue fit; better suited elsewhere |
| Very weak | 1 | Wrong venue; topic mismatch |

### Step 5: Recommendation

Map the total score and blocker status to a recommendation:

| Recommendation | Total Score Range | Blocker Condition |
|---------------|:-----------------:|-------------------|
| Strong Accept | 85-100 | 0 blockers |
| Accept | 75-84 | 0 FATAL blockers |
| Weak Accept | 65-74 | 0 FATAL blockers |
| Borderline | 55-64 | 0-1 non-fatal blockers |
| Weak Reject | 45-54 | Any blockers OR fatal flaw checklist hit |
| Reject | 30-44 | FATAL blockers present |
| Strong Reject | 0-29 | Multiple FATAL blockers |

**Critical rule**: A FATAL blocker forces the recommendation to Weak Reject or below, regardless of total score.

### Step 6: Confidence Assessment

| Level | Meaning |
|:-----:|---------|
| 5 | Expert in this specific topic; very confident in assessment |
| 4 | Knowledgeable in the area; confident in most assessments |
| 3 | Familiar with the topic; some uncertainty on specific points |
| 2 | Limited expertise in this area; significant uncertainty |
| 1 | Outside area of expertise; low confidence |

### Step 7: Generate Author Questions

From the combined reviews, extract 3-5 targeted questions that:
- Address the most important unresolved concerns
- Are answerable within a rebuttal (not "run 6 more months of experiments")
- Would most change the recommendation if answered well
- Are specific enough to have a clear answer

### Step 8: Generate Confidential Chair Note

Write a separate note for the PC chair/editor containing:
- Summary of reviewer agreement/disagreement
- Any concerns about ethical issues or disclosure
- Whether the paper needs a shepherd
- Whether specific expertise is needed for further review
- Any concerns the meta-reviewer has that should not appear in the author-facing review

## Output Format: 05_merged_review.md

```markdown
# Review Summary
- Paper type: {systems | embedded | mobile systems | scheduling | software | algorithms | mixed}
- Claimed contributions:
  1. [contribution 1]
  2. [contribution 2]
  3. [contribution 3]
- One-sentence verdict: [concise overall assessment]

# Scores
- Problem significance (10): X
- Novelty / contribution (15): X
- Technical soundness (20): X
- Evaluation quality (20): X
- Reproducibility / artifact / implementation realism (15): X
- Clarity / organization (10): X
- Fit / impact on community (10): X
- **Total (100): XX**
- Confidence (1-5): X
- Ethics / safety / disclosure concerns: none / minor / major
- Fatal flaws: N
- Required-for-accept fixes: N (0-3)
- Nice-to-have fixes: N (0-5)

# Strengths
1. [strength with evidence reference]
2. [strength with evidence reference]
3. [strength with evidence reference]

# Major Concerns
1. [concern with section/figure/table reference]
2. [concern with section/figure/table reference]
3. [concern with section/figure/table reference]

# Minor Concerns
1. [concern]
2. [concern]
3. [concern]

# Evidence Mapping
- Claim 1 -> Evidence in paper: [sections, figures, tables]
- Claim 2 -> Evidence in paper: [sections, figures, tables]
- Claim 3 -> Evidence in paper: [sections, figures, tables]

# Missing Evidence / Overclaims
1. [description with reference]
2. [description with reference]

# Questions for Authors
1. [question -- referenced in 06_author_questions.md]
2. [question]
3. [question]

# Recommendation
- {Strong Accept | Accept | Weak Accept | Borderline | Weak Reject | Reject | Strong Reject}

# Confidence Rationale
- [why this confidence level]

# Confidential Note to Chair/Editor
- [referenced in 07_confidential_chair_note.md -- see separate file]
```

## Output Format: 06_author_questions.md

```markdown
# Author Questions: [Paper Title]

## Question 1: [topic]
**Context**: [what prompted this question]
**Question**: [specific, answerable question]
**Impact on recommendation**: [how the answer could change the score]

## Question 2: ...
(repeat for 3-5 questions)
```

## Output Format: 07_confidential_chair_note.md

```markdown
# Confidential Note to Chair/Editor: [Paper Title]

## Reviewer Agreement
- [summary of where reviewers agree/disagree]

## Ethics / Disclosure
- [any concerns]

## Shepherd Recommendation
- Needed: YES / NO
- Reason: [if yes]

## Additional Expertise Needed
- [specific expertise, if any]

## Meta-Reviewer Concerns (not for authors)
- [anything the chair should know]
```

## 5-Level Anchors Per Axis

### Problem Significance (weight 10)
| 5 | Real, painful problem; broadly relevant to community |
|---|---|
| 4 | Real problem with clear practical motivation |
| 3 | Problem exists but significance debatable |
| 2 | Known problem; weak framing; toy setting |
| 1 | Fabricated or trivially solved |

### Novelty / Contribution (weight 15)
| 5 | New insight/mechanism/formulation; 2-3 sentence differentiator |
|---|---|
| 4 | Clear contribution; meaningful differentiation |
| 3 | Some novelty; heavy overlap with prior work |
| 2 | Engineering effort as novelty |
| 1 | Trivial combination |

### Technical Soundness (weight 20)
| 5 | No logical gaps; assumptions explicit; mechanism reproducible |
|---|---|
| 4 | Minor gaps; no fatal issues |
| 3 | Notable assumption or guarantee gaps |
| 2 | Key assumptions hidden or unrealistic |
| 1 | Fundamental logical flaw |

### Evaluation Quality (weight 20)
| 5 | Fair baselines, representative workloads, trade-offs quantified, limitations shown |
|---|---|
| 4 | Solid evaluation; minor gaps |
| 3 | Some cherry-picking or weak baselines |
| 2 | Significant gaps; missing overhead/scalability |
| 1 | Evaluation does not support claims |

### Reproducibility / Artifact (weight 15)
| 5 | Artifact available; install/run clear; main claims reproducible |
|---|---|
| 4 | Most info present; minor config gaps |
| 3 | Some artifacts but significant path gaps |
| 2 | Major gaps; reproduction needs guesswork |
| 1 | Impossible from provided info |

### Clarity / Organization (weight 10)
| 5 | Abstract covers problem/method/result/limitation; figures self-explanatory |
|---|---|
| 4 | Clear structure; minor readability issues |
| 3 | Readable but some sections unfocused |
| 2 | Contribution/result separation unclear |
| 1 | Hard to follow; notation unstable |

### Fit / Impact (weight 10)
| 5 | Highly relevant; broad interest; opens directions |
|---|---|
| 4 | Clear venue relevance; solid interest |
| 3 | Relevant but niche |
| 2 | Marginal fit; better elsewhere |
| 1 | Wrong venue |

## Iteration Policy

- Max 2 rounds
- Stop when: recommendation is consistent with individual review scores and concerns
- If inconsistency detected: flag `recommendation_text_inconsistency` blocker and iterate

## Score Ownership

This skill owns the following score axes:
- `fit_impact`
- `recommendation_consistency`
- `overall_recommendation`

This skill also produces the **calibrated total score** by aggregating all owner-skill scores with venue weight modifiers.

## Blocker Ownership

- `recommendation_text_inconsistency` (severity: MAJOR) -- recommendation label does not match the scores or stated concerns. This skill can open and close this blocker.

## Review Depth

This skill operates in **analytical mode** by default. All assessments must:
- Evaluate structural soundness, not just surface compliance
- Identify the weakest point in the argument before scoring
- Use "evaluate/assess/analyze" language in all sub-prompts
- Never short-circuit to PASS/APPROVE without deep analysis

When this skill delegates to Codex or subagents, prompts MUST include:
"Perform a deep analytical review. Do not produce a checklist -- identify structural weaknesses,
missing evidence, and the strongest objection a hostile reviewer could raise.
This is an unpublished paper under review. Do NOT search the web for it. Analyze only the provided content."

## Hard Rules

- Do NOT invent missing experimental details.
- Distinguish clearly between "stated in paper", "inferred", and "missing".
- Every major criticism must cite a concrete place in the paper (section, figure, table, equation).
- Every score below average must be justified by evidence.
- Do NOT request broad extra experiments unless they are central to the acceptance decision.
- Prefer a few decisive concerns over many weak comments.
- Criticize the work, not the authors.
- Separate comments to authors from confidential comments to chairs/editors.
