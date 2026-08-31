---
name: arx-claim-extract
description: Stage 3 claim extractor (called by arx-paper-review).
allowed-tools: Read, Grep, Glob, Bash
---

# Claim Extractor

Extract core claims from an academic paper and map each claim to its supporting evidence. This skill is the foundation for all downstream review skills in the arx- system.

## Input

- Paper text (LaTeX source files or plain text sections)
- Venue profile (output from `/arx-venue-profile`)
- Paper path provided via context or `$ARGUMENTS`
- Optional: `--references <path>` -- path to `references/index.md` for novelty assessment against reference papers

## Output

Write `01_claim_map.md` to the review output directory.

## Procedure

### Step 1: Identify Core Claims (3-7)

Read the paper's abstract, introduction (especially the "contributions" paragraph), and conclusion. Extract 3-7 distinct claims. Each claim must be:

- **Specific**: Not "we improve performance" but "we reduce p99 latency by 18-24% under bursty workloads"
- **Testable**: There should be a way to verify the claim from the paper's own content
- **Distinct**: No two claims should be restatements of the same idea

Classify each claim:

| Type | Description |
|------|-------------|
| `SYSTEM` | A systems design or implementation contribution |
| `ALGORITHM` | A new algorithm, protocol, or scheduling method |
| `THEORY` | A formal result (theorem, bound, guarantee) |
| `EMPIRICAL` | An experimental finding or measurement |
| `METHODOLOGY` | A new evaluation method, benchmark, or framework |

### Step 2: Map Evidence

For each claim, identify:

1. **Supporting sections**: Which sections contain the argument or proof
2. **Figures**: Which figures/plots directly support the claim
3. **Tables**: Which tables provide quantitative backing
4. **Equations**: Which equations formalize the claim
5. **Evidence strength**: One of `STRONG`, `MODERATE`, `WEAK`, `MISSING`

Evidence strength criteria:

| Level | Meaning |
|-------|---------|
| `STRONG` | Multiple consistent data points, statistical significance, or complete proof |
| `MODERATE` | Some data supports claim but gaps exist (e.g., limited scenarios, no error bars) |
| `WEAK` | Claim is stated but evidence is indirect, anecdotal, or insufficient |
| `MISSING` | Claim appears in abstract/intro but no supporting evidence found in the paper |

### Step 3: Flag Issues

For each claim, check:

- **Overclaim**: Does the claim's language exceed what the evidence supports?
- **Scope mismatch**: Does the claim generalize beyond the evaluated conditions?
- **Missing control**: Is a necessary baseline or ablation absent?
- **Circular**: Does the claim depend on assumptions that the paper also assumes?

### Step 4: Label Each Statement

Every factual statement in the output must be labeled:

| Label | Meaning |
|-------|---------|
| `[STATED]` | Explicitly written in the paper |
| `[INFERRED]` | Reasonable inference from paper content |
| `[MISSING]` | Not found in the paper |

### Step 5: Novelty Assessment Against References (requires `--references`)

When `--references <path>` is provided, compare extracted claims against the content of reference papers to assess novelty:

1. **Overlap detection**: For each claim, check whether substantially similar claims appear in any reference paper
2. **Differentiation strength**: If overlap exists, assess whether the paper adequately differentiates its contribution
3. **Flag significant overlaps**: Claims that overlap significantly with referenced work without clear differentiation are flagged with `OVERLAP` in addition to any existing issue tags

If `--references` is not provided, this step is skipped. The claim map is still produced but without novelty cross-referencing.

## Output Format

```markdown
# Claim Map: [Paper Title]

## Summary
- Paper type: {systems | embedded | scheduling | algorithms | mixed}
- Number of claims extracted: N
- Evidence coverage: X/N claims with STRONG evidence

## Claims

### Claim 1: [Concise claim statement]
- **Type**: SYSTEM / ALGORITHM / THEORY / EMPIRICAL / METHODOLOGY
- **Source**: Section X, paragraph Y [STATED]
- **Evidence**:
  - Section X.Y: [description] — STRONG
  - Figure N: [description] — MODERATE
  - Table M: [description] — STRONG
- **Evidence strength**: STRONG / MODERATE / WEAK / MISSING
- **Issues**: None / Overclaim / Scope mismatch / Missing control / Circular
- **Notes**: [Any additional observations]

### Claim 2: ...
(repeat for all claims)

## Evidence Gap Summary

| Claim | Evidence | Issues | Overlap? | Blocker? |
|-------|----------|--------|:--------:|:--------:|
| 1     | STRONG   | None   | No       | No       |
| 2     | WEAK     | Overclaim | Yes (paper_id) | Yes  |
| ...   | ...      | ...    | ...      | ...      |

Note: The "Overlap?" column is populated only when `--references` is provided. It lists the paper_id of any reference paper with significant claim overlap.

## Blockers Raised
- `unsupported_claim`: [description, if any claim has MISSING or WEAK evidence for a core contribution]
```

## Iteration Policy

- Max 2 rounds
- Stop when: all claims have evidence mapped OR flagged as MISSING
- If a claim is flagged as MISSING for a core contribution, raise blocker `unsupported_claim` (severity: FATAL)

## Score Ownership

- `claim_evidence_linkage`: This skill owns this score axis

## Blocker Ownership

- `unsupported_claim`: This skill can open and close this blocker

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
