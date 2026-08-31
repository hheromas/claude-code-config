---
name: arx-repro-review
description: Reproducibility reviewer (called by arx-paper-review).
allowed-tools: Read, Grep, Glob, Bash, WebFetch
---

# Reproducibility Reviewer

Assess the reproducibility and artifact viability of an academic paper. This skill is invoked at Stage 2 of the `/arx-paper-review` orchestrator. It focuses on whether another researcher could reproduce the main claims from the information provided.

## Input

- Paper text (LaTeX source files or plain text sections)
- Artifact README (if available)
- `01_claim_map.md` (output from `/arx-claim-extract`)
- Review output directory path (provided by orchestrator or `$ARGUMENTS`)

## Output

Write `03_repro_review.md` to the review output directory.

## Procedure

### Step 1: Artifact Inventory

Identify all artifacts mentioned or implied by the paper:

1. **Source code**: Repository URL, language, framework, dependencies
2. **Datasets**: Public/private, size, format, availability
3. **Hardware**: Board, GPU, sensors, firmware version
4. **Software environment**: OS, compiler, runtime, library versions
5. **Configuration**: Parameters, hyperparameters, seeds, scripts
6. **Models**: Pre-trained weights, training procedure, checkpoint availability

For each artifact, mark availability:

| Status | Meaning |
|--------|---------|
| `AVAILABLE` | URL or appendix provides the artifact |
| `DESCRIBED` | Artifact is described but not provided |
| `MENTIONED` | Artifact is referenced but details are insufficient |
| `MISSING` | Required artifact is not mentioned at all |

### Step 2: Reproduction Path Analysis

For each core claim in the claim map, trace the minimum path to reproduction:

1. **Install**: What must be installed? How long would it take?
2. **Configure**: What parameters must be set? Are defaults documented?
3. **Run**: What command or script produces the result?
4. **Verify**: How does one confirm the result matches the paper?

Flag any step where information is insufficient.

### Step 3: Dependency Analysis

Check for reproduction blockers:

1. **Proprietary dependencies**: Commercial software, licensed datasets, internal APIs
2. **Hardware requirements**: Specific GPUs, boards, sensors not widely available
3. **Scale requirements**: Cluster-scale experiments that cannot be scaled down
4. **Non-determinism**: Sources of randomness without seed control
5. **Data availability**: Training data, calibration data, real-world traces

### Step 4: Implementation Status Clarity

Evaluate how clearly the paper communicates what IS and IS NOT implemented:

1. Is the boundary between implemented and simulated explicit?
2. Are simplifying assumptions in the implementation documented?
3. Is the relationship between the paper's formulas and the actual code clear?
4. Are there gaps between the algorithm description and what was actually built?

### Step 5: Venue-Specific Assessment

Apply venue-specific artifact expectations from the venue profile:

| Venue Type | Expectation |
|-----------|-------------|
| VERY_HIGH (EuroSys/OSDI/ATC) | Full AE: completeness, documentation, buildability, main claims reproduction |
| HIGH (SenSys/MobiSys/EWSN) | Board/firmware/deployment evidence; testbed data |
| MEDIUM (RTCSA) | Simulation acceptable; hardware prototype is positive signal |
| LOW (algorithms) | Proofs are primary artifact; code is bonus |

### Step 6: Label Every Statement

Every factual statement in the output must be labeled:

| Label | Meaning |
|-------|---------|
| `[STATED]` | Explicitly written in the paper |
| `[INFERRED]` | Reasonable inference from paper content |
| `[MISSING]` | Not found in the paper |

## Output Format

```markdown
# Reproducibility Review: [Paper Title]

## Summary
- Artifact expectation level: VERY_HIGH / HIGH / MEDIUM / LOW
- Artifact availability: X/N artifacts available or described
- Reproduction feasibility: HIGH / MEDIUM / LOW / IMPOSSIBLE

## Score

| Axis | Score (1-5) | Display (0-100) | Justification |
|------|:-----------:|:---------------:|---------------|
| Reproducibility | X | X*3 | ... |

## Artifact Inventory

| Artifact | Type | Status | Notes |
|----------|------|:------:|-------|
| Source code | code | AVAILABLE/DESCRIBED/MENTIONED/MISSING | ... |
| Dataset A | data | ... | ... |
| Hardware setup | hw | ... | ... |
| ... | ... | ... | ... |

## Reproduction Path

### Claim 1: [claim text]
1. Install: [requirements] [STATED/MISSING]
2. Configure: [parameters] [STATED/MISSING]
3. Run: [command/script] [STATED/MISSING]
4. Verify: [expected output] [STATED/MISSING]
- Feasibility: HIGH / MEDIUM / LOW / IMPOSSIBLE
- Missing info: [list]

### Claim N: ...

## Dependency Analysis

### Proprietary Dependencies
- [list or "None identified"]

### Hardware Requirements
- [list with availability assessment]

### Non-determinism Sources
- [list with seed/control status]

## Implementation Clarity

- Implemented vs simulated boundary: CLEAR / AMBIGUOUS / UNSTATED [STATED/INFERRED/MISSING]
- Algorithm-to-code correspondence: CLEAR / PARTIAL / UNCLEAR [STATED/INFERRED]
- Simplifying assumptions documented: YES / PARTIAL / NO [STATED/MISSING]

## Strengths
1. ...
2. ...

## Concerns
1. ... [section reference]
2. ...

## Blockers Raised
- `missing_repro_steps`: [description, if applicable]
- `artifact_blocker`: [description, if applicable]
```

## Scoring Criteria

### Reproducibility (15 points)

| Level | Score | Criteria |
|-------|:-----:|---------|
| Strong | 5 | Artifact available, install/run conditions specific, main claims reproducible via shortest path, implementation boundary clear |
| Good | 4 | Most reproduction info present; minor gaps in configuration or environment details |
| Mixed | 3 | Some artifacts available but significant gaps in reproduction path |
| Weak | 2 | Major information gaps; reproduction requires significant guesswork |
| Very weak | 1 | Reproduction impossible from provided information |

## Iteration Policy

- Max 2 rounds
- Stop when: all artifacts are inventoried and reproduction paths are traced or flagged as impossible
- If reproduction is impossible for a core claim: raise blocker

## Score Ownership

This skill owns the following score axis:
- `reproducibility`

## Blocker Ownership

This skill can open and close the following blockers:
- `missing_repro_steps` (severity: MAJOR) -- key reproduction steps cannot be determined
- `artifact_blocker` (severity: FATAL) -- a core claim cannot be reproduced due to missing/unavailable artifact

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

## Mode: tech-article (Optional)

By default this skill operates in `mode: paper`. Set `mode: tech-article` (via $ARGUMENTS or context) to switch to a 10-axis reader-simulation rubric for technical blog posts / hands-on / tutorial articles. Full rubric, dispatch prompt template, score interpretation, and pitfalls live in `references/reader_simulation_rubric.md`.

### 10-axis rubric (each 0-2 points, total 20)
1. Environment prerequisites stated
2. Code completeness
3. Command accuracy
4. Version dependency stated
5. Full config files included
6. Expected output shown
7. Handling of errors
8. Project prerequisites stated
9. Link health (verify with WebFetch)
10. Author-specific knowledge stated

Score interpretation: 18-20 publishable, 14-17 okay with light revision, 10-13 needs revision, <=9 rethink premise.

### Trigger
- `mode: tech-article` explicit, or target is *.md / blog post format
- arx-repro-review default remains `mode: paper` (academic 15-pt schema)

### Execution
- **Prompt-based**, no external script required
- Dispatch a general-purpose subagent (Task tool) using the template in `references/reader_simulation_rubric.md`
- Subagent must role-play as a **first-time reader**, not as an expert executor

### Source attribution
Adapted from `mizchi/skills/tech-article-reproducibility` (10-axis methodology, dispatch template, score interpretation). See `references/reader_simulation_rubric.md` for the faithful port.

## Hard Rules

- Do NOT invent missing experimental details.
- Distinguish clearly between "stated in paper", "inferred", and "missing".
- Every major criticism must cite a concrete place in the paper (section, figure, table, equation).
- Every score below average must be justified by evidence.
- Do NOT request broad extra experiments unless they are central to the acceptance decision.
- Prefer a few decisive concerns over many weak comments.
- Criticize the work, not the authors.
- Separate comments to authors from confidential comments to chairs/editors.
