---
name: arx-technical-review
description: Technical/systems reviewer (called by arx-paper-review).
allowed-tools: Read, Grep, Glob, Bash
---

# Technical Reviewer

Perform a technical review of an academic paper covering soundness, evaluation quality, and implementation realism. This skill is invoked at Stage 2 of the `/arx-paper-review` orchestrator. While it retains deep expertise in systems-specific concerns (latency, throughput, energy, memory, overhead, scalability trade-offs, baseline fairness), it is designed to assess general technical quality across paper types -- not limited to systems papers.

## Input

- Paper text (LaTeX source files or plain text sections)
- `01_claim_map.md` (output from `/arx-claim-extract`)
- Venue profile (output from `/arx-venue-profile`)
- Review output directory path (provided by orchestrator or `$ARGUMENTS`)
- Optional: `--references <path>` -- path to `references/index.md` for cited paper accuracy checks

## Output

Write `02_technical_review.md` to the review output directory.

## Procedure

### Step 1: Read Claim Map

Load `01_claim_map.md` and identify all claims of type `SYSTEM`, `ALGORITHM`, `EMPIRICAL`, or `THEORY`. These are the primary targets for technical scrutiny.

### Step 2: Technical Soundness Assessment

For each claim, evaluate:

1. **Logic chain**: Is there a logical gap between the problem definition and the proposed solution?
2. **Assumptions**: Are all assumptions explicitly stated? Are any hidden?
3. **Guarantees**: For scheduling/algorithm papers -- are formal or probabilistic guarantees clear?
4. **Mechanism clarity**: Is the system mechanism described with enough precision to reimplement?

Score: `technical_soundness` (1-5 scale, weight 20)

### Step 3: Evaluation Quality Assessment

Check the paper's experimental evaluation:

1. **Baseline fairness**: Are baselines appropriate and fairly configured?
2. **Workload representativeness**: Do workloads/traces/datasets match the claimed scope?
3. **Trade-off quantification**: Are trade-offs (latency vs accuracy, energy vs throughput, etc.) measured, not just claimed?
4. **Statistical rigor**: Error bars, variance, worst-case analysis, or repeated trials?
5. **Negative results**: Does the paper report where the method does NOT work?
6. **Cherry-picking check**: Are scenarios selected to favor the proposed method?

Score: `evaluation_quality` (1-5 scale, weight 20)

### Step 4: Implementation Realism Assessment

Evaluate practical feasibility:

1. **Implementation status**: What is implemented vs simulated vs assumed?
2. **Overhead accounting**: Are latency, memory, energy, bandwidth, and engineering complexity overhead reported?
3. **Hardware/software assumptions**: Are HW/SW dependencies realistic and clearly stated?
4. **Scalability**: Is the evaluation scale appropriate for the claims?
5. **Deployment gap**: Is there a mismatch between the evaluated setting and the claimed deployment scenario?

Score: `implementation_realism` (1-5 scale, weight included in reproducibility axis of 100-point rubric)

### Step 5: Problem Significance and Novelty

1. **Problem significance**: Is the problem real, painful, and relevant to the systems/embedded community?
2. **Novelty**: Is the contribution a new insight/mechanism/formulation, or engineering effort repackaged as novelty?

Score: `problem_significance` (1-5 scale, weight 10)
Score: `novelty_contribution` (1-5 scale, weight 15)

### Step 6: Fatal Flaw Checklist

Run the following 9-item checklist. Each item answered YES forces careful consideration of Weak Reject or below:

1. Is the main claim unsupported by the presented evidence?
2. Are the baselines inappropriate or unfair?
3. Are key assumptions unrealistic or unstated?
4. Is the implementation status unclear in a way that invalidates claims?
5. Are important costs omitted (latency, energy, memory, bandwidth, engineering complexity, hardware constraints)?
6. Is reproducibility impossible from the provided information?
7. Is prior work misrepresented?
8. Are claimed improvements too narrow or cherry-picked?
9. Is there a mismatch between theorem/model and deployed setting?

### Step 7: Cited Paper Accuracy Check (requires `--references`)

When `--references <path>` is provided, cross-check the paper's descriptions of cited work against the actual content of reference papers tagged `content_ref` or `both` in the references index.

For each reference paper available:

1. **Description accuracy**: Does the paper accurately describe what the cited work does?
2. **Comparison fairness**: Are comparisons with cited work fair and correctly characterized?
3. **Missing context**: Does the paper omit relevant context from cited work that would change the reader's understanding?
4. **Novelty differentiation**: Is the claimed novelty genuinely distinct from what the cited work already achieved?

If `--references` is not provided, this step is skipped. The review proceeds normally without reference cross-checking.

### Step 8: Label Every Statement

Every factual statement in the output must be labeled:

| Label | Meaning |
|-------|---------|
| `[STATED]` | Explicitly written in the paper |
| `[INFERRED]` | Reasonable inference from paper content |
| `[MISSING]` | Not found in the paper |

## Output Format

```markdown
# Technical Review: [Paper Title]

## Summary
- Paper type: {systems | embedded | scheduling | algorithms | mixed}
- Venue: [venue name]
- Review focus: systems realism, baseline fairness, implementation scope, evaluation quality

## Score Summary

| Axis | Score (1-5) | Display (0-100) | Justification |
|------|:-----------:|:---------------:|---------------|
| Problem significance | X | X*2 | ... |
| Novelty / contribution | X | X*3 | ... |
| Technical soundness | X | X*4 | ... |
| Evaluation quality | X | X*4 | ... |
| Implementation realism | X | (feeds repro axis) | ... |

## Technical Soundness Analysis

### Claim 1: [claim text]
- Logic chain: [assessment] [STATED/INFERRED/MISSING]
- Assumptions: [list] [STATED/INFERRED/MISSING]
- Gaps: [if any]

### Claim N: ...

## Evaluation Quality Analysis

### Baselines
- [baseline name]: Fair / Unfair — [reason] [STATED]

### Workloads
- [workload]: Representative / Narrow — [reason] [STATED]

### Trade-offs
- [trade-off]: Quantified / Claimed-only — [evidence] [STATED/MISSING]

### Statistical Rigor
- [assessment]

## Implementation Realism

- Implementation status: [what is built vs simulated]
- Overhead reported: [yes/no, what is missing]
- HW/SW assumptions: [list]
- Scalability assessment: [adequate / insufficient for claims]
- Deployment gap: [none / minor / major — description]

## Fatal Flaw Checklist

| # | Question | Answer | Evidence |
|:-:|----------|:------:|----------|
| 1 | Main claim unsupported? | YES/NO | ... |
| 2 | Baselines unfair? | YES/NO | ... |
| 3 | Assumptions unrealistic/unstated? | YES/NO | ... |
| 4 | Implementation status unclear? | YES/NO | ... |
| 5 | Important costs omitted? | YES/NO | ... |
| 6 | Reproducibility impossible? | YES/NO | ... |
| 7 | Prior work misrepresented? | YES/NO | ... |
| 8 | Improvements cherry-picked? | YES/NO | ... |
| 9 | Model/deployment mismatch? | YES/NO | ... |

Fatal flaw count: N/9

## Cited Paper Accuracy (if --references provided)

| Cited Paper | Description Accurate? | Comparison Fair? | Issues |
|-------------|:---------------------:|:----------------:|--------|
| [paper_id]  | YES/NO                | YES/NO           | ...    |

## Strengths
1. ...
2. ...
3. ...

## Major Concerns
1. ... [section/figure/table reference]
2. ...

## Minor Concerns
1. ...
2. ...

## Blockers Raised
- `unfair_baseline`: [description, if applicable]
- `hidden_assumption`: [description, if applicable]
- `evaluation_gap`: [description, if applicable]
```

## Scoring Criteria Detail

### Problem Significance (10 points)

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | Problem is real, painful, and broadly relevant |
| Good | 4 | Problem is real with clear practical motivation |
| Mixed | 3 | Problem exists but significance is debatable |
| Weak | 2 | Known problem, weak framing, or toy setting |
| Very weak | 1 | Fabricated or trivially solved problem |

### Novelty / Contribution (15 points)

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | New insight/mechanism/formulation; difference articulable in 2-3 sentences |
| Good | 4 | Clear contribution with meaningful differentiation |
| Mixed | 3 | Some novelty but overlaps heavily with prior work |
| Weak | 2 | Primarily engineering effort; "implementation was hard" as novelty |
| Very weak | 1 | Trivial combination of known techniques |

### Technical Soundness (20 points)

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | No logical gaps; assumptions explicit; mechanism reproducible |
| Good | 4 | Minor gaps; no fatal logical issues |
| Mixed | 3 | Notable gaps in assumptions or guarantees |
| Weak | 2 | Key assumptions hidden or unrealistic |
| Very weak | 1 | Fundamental logical flaw |

### Evaluation Quality (20 points)

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | Fair baselines, representative workloads, trade-offs quantified, negative results shown |
| Good | 4 | Solid evaluation with minor gaps |
| Mixed | 3 | Some cherry-picking or weak baselines |
| Weak | 2 | Significant evaluation gaps; missing overhead/scalability |
| Very weak | 1 | Evaluation does not support claims |

## Iteration Policy

- Max 2 rounds
- Stop when: all major concerns are evidence-linked
- If fatal flaw found: raise appropriate blocker immediately

## Score Ownership

This skill owns the following score axes:
- `problem_significance`
- `novelty_contribution`
- `technical_soundness`
- `evaluation_quality`
- `implementation_realism`

**Recommendation scope**: This skill produces scores only. It does NOT produce an overall recommendation (accept/reject). The overall recommendation is the exclusive responsibility of `/arx-meta-review`. If Codex returns a recommendation during technical review delegation, record it as advisory but do not include it in the output.

## Blocker Ownership

This skill can open and close the following blockers:
- `unfair_baseline` (severity: FATAL)
- `hidden_assumption` (severity: MAJOR)
- `evaluation_gap` (severity: MAJOR)

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
