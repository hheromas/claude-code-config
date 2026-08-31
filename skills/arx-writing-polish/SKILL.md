---
name: arx-writing-polish
description: Academic writing improvement pipeline with 5 sequential editing agents. Triggered by "writing polish", "polish writing", "improve writing", "refine paper".
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# Writing Polish

Improve academic paper writing through a 5-agent sequential pipeline. This skill runs at Stage 1 (baseline scan mode) and Stage 4 (full editing mode) of the `/arx-paper-review` orchestrator, or standalone when invoked directly. It operates at paragraph level, preserving technical claims while improving clarity, precision, and naturalness.

## Input

- Paper text (LaTeX source files or plain text sections)
- Editing mode (one of 5 modes below)
- `$ARGUMENTS`: `[paper_path] --mode <mode> [--section <name>]`
- Venue profile (from `/arx-venue-profile`, if available)
- `deodorization_report.md` (from `/arx-ai-deodorize`, if available). When this file exists in the review directory, consume its "Fix List" table as input for editing priorities. FLAGGED paragraphs get highest priority, SUSPECT paragraphs get secondary priority. The fix list provides paragraph IDs, tracks, and suggested fixes that should guide the editing pipeline.

## Output

Write `08_language_edit_notes.md` to the review output directory.

## Score Ownership

This skill owns and reports scores for:
- `clarity` (0-100)
- `organization` (0-100)
- `english_naturalness` (0-100)

## Blocker Ownership

- `semantic_drift` (MINOR) -- raised when an edit changes the meaning of a technical claim

## Editing Modes

| Mode | Scope | When to Use |
|------|-------|-------------|
| `baseline_scan` | Read-only assessment; no edits | Stage 1 pre-review snapshot of writing quality |
| `conservative_polish` | Grammar, clarity, sentence flow only | Early drafts where content is still changing |
| `technical_precision` | Sharpen claims and bind them to evidence | After content is stable; tighten claim-evidence links |
| `native_naturalization` | Make phrasing more natural while preserving technical exactness | Non-native authors; after technical precision pass |
| `venue_tightening` | Compress for page limits and stronger contribution framing | Camera-ready preparation |

Default mode if unspecified: `conservative_polish`.

### Baseline Scan Mode

When invoked with `--mode baseline_scan`, this skill:
1. Reads the entire paper and scores clarity, organization, and english_naturalness
2. Writes `writing_baseline.md` (NOT `08_language_edit_notes.md`) to the review directory
3. Does NOT produce paragraph-level edits -- scores only
4. This mode always runs at Stage 1 of the orchestrator regardless of the `--writing` flag

## 5-Agent Sequential Pipeline

Each agent processes the full paper (or specified section) in order. The output of each agent becomes the input for the next.

### Agent 1: StructureEditor

- Reorder for logic and section purpose
- Ensure each section fulfills its role: intro = gap + contribution, method = design rationale, eval = fairness + trade-off, discussion = limitation + scope
- Flag paragraphs that belong in a different section
- Do NOT rewrite sentences; only reorder and flag

### Agent 2: PrecisionEditor

- Replace vague claims with measurable, conditional wording
- Bind claims to specific evidence (section, figure, table, equation)
- Convert "improves efficiency" to "cuts energy per task by 12% on NRF52840 under duty-cycled workloads"
- Replace inflated adjectives with numbers, conditions, or comparisons

### Agent 3: VoicePreserver

- Preserve the author's intended meaning and confidence level
- Ensure edits from Agents 1-2 did not increase certainty beyond evidence
- Restore author's real uncertainty where it was smoothed away
- Check that design trade-off rationale remains in the author's voice:
  - Why this baseline
  - Why this workload
  - Why this constraint is sufficient
  - What was intentionally not done

### Agent 4: SystemsStyleEditor

- Inject systems-specific concreteness
- Add: implementation boundary conditions, HW/SW versions, deployment assumptions
- Surface costs: overhead, memory, energy, latency, complexity
- Ensure systems detail matches the venue expectations (e.g., RTCSA expects real-time constraints; SenSys expects energy/power detail)

### Agent 5: FinalConsistencyChecker

- Verify abstract, intro, figures, results, and conclusion make compatible claims
- Check that no claim was strengthened or weakened inconsistently across sections
- Flag any cross-section contradictions
- Verify figure/table captions are consistent with body text

## Paragraph-Level Output Format

For each edited paragraph, output:

```markdown
### [Section].[Paragraph N]

**Original:**
> [original text]

**Edited:**
> [edited text]

**Why changed:** [concise rationale]

**Semantic drift risk:** low / medium / high
```

Paragraphs with no changes: list as "No change" (do not reproduce text).

## Iteration Policy

- **Target score**: 90
- **Hard stop**: 95 (do not polish beyond this; diminishing returns)
- **Max iterations**: 4
- **Stop early**: If score delta < 2 for 2 consecutive iterations
- **No regression**: Each iteration must not decrease any score axis
- **No semantic drift**: If an edit introduces semantic drift risk = high, revert that edit

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

## Forbidden Actions

- Do NOT add fabricated references, facts, or baselines.
- Do NOT increase certainty beyond what the evidence supports.
- Do NOT rewrite into generic hype language.
- Do NOT optimize for AI detectors.
- Do NOT erase limitations or uncertainty.
- Do NOT homogenize all sections into the same tone.

## Technical Claim Boundary

This skill cannot modify the substance of technical claims. If a claim appears unsupported or overclaimed, flag it as a note in the output but do NOT rewrite it. Technical blocker resolution is the responsibility of the research-readiness loop (arx-claim-extract, arx-technical-review, arx-devil-advocate).

Writing skills can NEVER close any blocker except `semantic_drift`.

## Style Reference

Query the reviewing literature database for venue-appropriate style patterns and diction examples. **Always use `make query`** (read-only, flock-safe):

```bash
cd $HOME/box/claude-shared/reviewing/db
make query Q="SELECT content FROM chunks JOIN sources ON chunks.source_id = sources.source_id WHERE sources.category = 'writing' AND list_contains(tags, 'style')"
```

**NEVER** open `reviewing.duckdb` directly with `duckdb.connect()`. All read operations go through `make query` or `make verify`.

## Diction Quick-Reference

| Avoid | Prefer |
|-------|--------|
| utilize | use |
| demonstrate | show |
| facilitate | help, enable |
| comprehensive | full, broad, end-to-end |
| significantly | by X%, under Y condition |
| novel | (omit or specify what is new) |
| robust | (specify what it withstands) |
| effective | (specify the metric and magnitude) |

## Usage Example

```
/arx-writing-polish /path/to/paper --mode technical_precision
/arx-writing-polish /path/to/paper --mode venue_tightening --section method
/arx-writing-polish /path/to/paper --mode native_naturalization
```
