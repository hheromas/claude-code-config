---
name: arx-ai-deodorize
description: AI-pattern detector (called by writing-polish chain).
allowed-tools: Read, Glob, Grep, Bash
---

# AI Deodorize

Detect AI-generated writing patterns in academic papers. This skill is **advisory only** -- it identifies problems but does not auto-fix them. Fixes go through `/arx-writing-polish`. This skill runs at Stage 4 of the `/arx-paper-review` orchestrator, or standalone.

**Important**: The goal is NOT to evade AI detectors. AI detectors are unreliable and biased against non-native English writers. The goal is to make the paper natural, clear, and authentically authored.

## Input

- Paper text (LaTeX source files or plain text sections)
- `$ARGUMENTS`: `[paper_path] [--section <name>] [--references <path>] [--deep]`

## Output

Write `deodorization_report.md` to the review output directory.

## Score Ownership

None. This skill is advisory. Its output feeds into `/arx-writing-polish`.

## Blocker Ownership

None. This skill does not own any blockers. It is purely advisory.

## AI-Generated Patterns (Detection Targets)

The following patterns are what readers perceive as unnatural, not what AI detectors flag:

1. **Inflated adjectives**: Overuse of "significant", "robust", "novel", "comprehensive", "effective" without justification
2. **Low meaning density**: Sentences that sound important but convey little specific information
3. **Excessive connectors**: Overuse of "Furthermore", "Moreover", "Additionally", "Consequently" where logic should flow naturally
4. **Missing limitations**: Real limitations smoothed away or replaced with vague hedges
5. **Repetitive rhythm**: Same sentence length and structure repeated across multiple sentences
6. **Vague contributions**: Contributions that sound impressive but lack specificity
7. **Thin systems detail**: Systems paper lacking implementation constraints, HW/SW versions, overhead costs, deployment assumptions

## 8-Track Scan

Each paragraph is assessed on all applicable tracks. A paragraph is tagged based on its worst track result. Tracks 1-7 always run. Track 8 runs only when `--references` is provided.

### Track 1: Meaning

- Is every claim tied to a concrete result, mechanism, or condition?
- Are the paper's limitations explicitly stated?
- Are trade-offs described, not hidden?

### Track 2: Diction

- Replace inflated adjectives with measurable descriptions
- Prefer short Anglo-Saxon verbs over Latinate formality when possible
- Remove repeated stock phrases ("novel", "robust", "effective", "comprehensive") unless justified

### Track 3: Sentence Rhythm

- Break long balanced sentences into simpler units
- Allow a mix of short and medium sentences
- Avoid repeating the same opening structure across multiple sentences

### Track 4: Authorial Judgment

- Add why this baseline/workload/design choice matters
- State what was intentionally not done
- State what the results do not imply

### Track 5: Systems Specificity

- Mention implementation boundary conditions
- Name hardware/software versions when relevant
- Include deployment assumptions
- Surface costs: overhead, memory, energy, latency, complexity

### Track 6: Final Authenticity

- Could the authors defend every sentence in a Q&A?
- Does the text preserve the authors' real uncertainty?
- Does the wording match the actual maturity of the implementation?

### Track 7: Overclaim Detection

- Claims stronger than evidence supports
- "Broadly applicable" without scope bounds
- Comparisons without fair baseline conditions
- Extrapolation beyond evaluated scenarios

### Track 8: Reference Paper Comparison (requires `--references`)

Compare the paper's vocabulary, sentence patterns, and transitions against reference papers tagged `style_ref` or `both` with `style_quality >= MEDIUM` in the references index.

- **Vocabulary gap**: Does the paper use AI-typical word choices where reference papers in the same domain use different terms?
- **Transition patterns**: Do the paper's paragraph transitions match patterns seen in published reference papers, or do they follow AI-typical formulaic connectors?
- **Section conventions**: Does the paper follow the structural conventions of the target venue as evidenced by reference papers?
- **Figure/table description style**: Compare how the paper describes results vs how reference papers describe theirs

This track is skipped when `--references` is not provided.

### Track 9: JP business/long-form patterns (optional)

Activate for Japanese business documents, READMEs, report.md, response letters. Six patterns not covered by Tracks 1-8 (others overlap with Diction / Meaning):

| # | Pattern | Example | Fix |
|---|---------|---------|-----|
| J1 | 両論併記の中立化 | 「一方では… 他方では…」連発で立場を消す | 自分の立場を明示 |
| J2 | 章冒頭の機械的 summary | 「前章では X について述べました。本章では…」 | 削除 |
| J3 | 対称的な見出し / 過剰な並列 | 全節「概要 / メリット / デメリット / まとめ」5並列 | 内容に合わせ非対称化 |
| J4 | 過度な listing (本来 prose) | 文章で書ける内容を全て bullet | 主張は文、列挙が必要な箇所だけ bullet |
| J5 | 仮定+結論+展望 3 段定型 | 「〜と仮定すると〜という結論が得られ、今後は〜が期待される」 | 結論と根拠を直接接続 |
| J6 | "我々は…" 一人称複数の濫用 | 「我々は〜と考える」「一般的に〜とされています」連発 | 必要箇所のみ、または判断主体を明示 |

Skip Track 9 when reviewing English-only academic papers (Tracks 1-8 are sufficient).

### Track 10: 2-axis reflection loop (multi-pass review mode)

For documents requiring iterative refinement (response letters, long report.md, business docs). Overrides the default "1 round only" Iteration Policy.

**Axes** (both 0-10, higher = better):
- **Axis A: 内容の独自性** — concrete examples / numbers / explicit grounds. 0 = generalities only, 10 = every claim grounded
- **Axis B: AI 臭非検出度** — `score = max(0, 10 - hits)` over all flagged Track 1-9 patterns

**Loop**:
1. Dispatch a fresh subagent: Read target, score Axis A / Axis B, output line-numbered findings
2. Apply 3-5 fixes per iteration (human or parent agent edits — never delegate the rewrite)
3. Re-score with a NEW subagent (no reuse — prevents anchoring on prior critique)
4. Stop when Axis A >= 8 AND Axis B >= 8 for 2 consecutive iterations, or feedback drops to taste-level

**Anti-patterns**: delegating rewrites to subagent (AI cannot self-deodorize), reusing the same subagent (learns previous findings), chasing one axis only, chasing 10/10 (8/8 is the target).

## Reference Comparison Flags

| Flag | Default | Effect |
|------|---------|--------|
| `--references <path>` | none | Path to `references/index.md`. If not provided, Track 8 is skipped. |
| `--deep` | OFF | When ON, read full paper text of reference papers for detailed comparison. When OFF (default), use pre-extracted style profiles from `<references_path>/profiles/`. If no profiles exist, they are auto-generated on first use. |

### profiles/ Management

- **Location**: `<references_path>/profiles/`
- **Auto-generated** on first use from papers with `role=style_ref` or `role=both` and `style_quality >= MEDIUM`
- **Each profile**: ~50 lines of extracted style features:
  - Characteristic transition phrases and their frequency
  - Hedging patterns (how uncertainty is expressed)
  - Section-level conventions (how intro/eval/conclusion are structured)
  - Figure and table description patterns
  - Sentence length distribution statistics
- **Regeneration**: Delete the profiles/ directory to force regeneration on next run

## Paragraph Tagging

Each paragraph receives one of three tags:

| Tag | Meaning | Criteria |
|-----|---------|----------|
| `CLEAN` | No AI-smell detected | All applicable tracks pass |
| `SUSPECT` | Minor patterns detected | 1-2 tracks flagged at low severity |
| `FLAGGED` | Significant AI patterns | 3+ tracks flagged, or any track at high severity |

## Correction Workflow (Recommended Order)

When flagged paragraphs are sent to `/arx-writing-polish`, apply corrections in this order:

1. **Concretize meaning**: Replace vague claims with specific results, mechanisms, or conditions
2. **State limitations**: Add what the method cannot do, where it was not tested, what remains unclear
3. **Reduce big words**: Apply the diction replacement table below
4. **Bind to evidence**: Tie every claim to a section, figure, table, or equation
5. **Preserve authorial judgment**: Keep the author's voice on trade-off decisions

## Diction Replacement Table

| Avoid | Prefer |
|-------|--------|
| utilize | use |
| demonstrate | show |
| facilitate | help, enable |
| comprehensive | full, broad, end-to-end |
| significantly | by X%, under Y condition |

## Output Format

```markdown
# Deodorization Report: [Section Name]

## Summary

- Total paragraphs scanned: N
- CLEAN: N (X%)
- SUSPECT: N (X%)
- FLAGGED: N (X%)

## Paragraph Details

### [Section].[Paragraph N] -- [CLEAN|SUSPECT|FLAGGED]

**Pattern type:** AI-like / genuinely-weak-writing / both
**Tracks flagged:** [list of track names]

**Findings:**
- [Track]: [specific finding with quoted text]

**Suggested fix direction:** [brief guidance, NOT a rewrite]
```

## Machine-Readable Fix List (for arx-writing-polish handoff)

At the end of `deodorization_report.md`, append a machine-readable fix list table for consumption by `/arx-writing-polish`:

```markdown
## Fix List

| paragraph_id | track | severity | issue | suggested_fix |
|-------------|-------|----------|-------|---------------|
| method.3 | Diction | SUSPECT | "utilize" x3, "comprehensive" | Replace with concrete terms |
| eval.1 | Meaning | FLAGGED | Vague claim without metrics | Bind to Table 2 data |
| intro.5 | Rhythm | SUSPECT | 4 consecutive long sentences | Break into varied lengths |
```

This table enables `/arx-writing-polish` to prioritize FLAGGED and SUSPECT paragraphs during editing.

## Style Reference

Query the reviewing literature database for natural academic writing examples. **Always use `make query`** (read-only, flock-safe):

```bash
cd $HOME/box/claude-shared/reviewing/db
make query Q="SELECT content FROM chunks JOIN sources ON chunks.source_id = sources.source_id WHERE sources.category = 'writing' AND (list_contains(tags, 'diction') OR list_contains(tags, 'style'))"
```

**NEVER** open `reviewing.duckdb` directly with `duckdb.connect()`. All read operations go through `make query` or `make verify`.

## Iteration Policy

- **Default: 1 round only** (single-pass scan). Output feeds into `/arx-writing-polish`.
- **Override**: Track 10 (2-axis reflection loop) enables multi-pass mode for long-form / business documents. Use only when explicitly invoked.

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

- This skill is **detection only**. Do NOT rewrite any text.
- Do NOT optimize for AI detector evasion. Focus on genuine readability.
- Do NOT flag technical terminology as "inflated" -- domain-specific terms are appropriate.
- Do NOT penalize formal academic register when it serves precision.
- Distinguish between "AI-like" and "genuinely bad writing" -- flag both but label differently.
- Do NOT invent missing experimental details.
- Distinguish clearly between "stated in paper", "inferred", and "missing".
- Every major finding must cite a concrete place in the paper (section, figure, table, equation).
- Every score below average must be justified by evidence.
- Do NOT request broad extra experiments unless they are central to the acceptance decision.
- Prefer a few decisive concerns over many weak comments.
- Criticize the work, not the authors.
- Separate comments to authors from confidential comments to chairs/editors.

## Usage Example

```
/arx-ai-deodorize /path/to/paper
/arx-ai-deodorize /path/to/paper --section introduction
/arx-ai-deodorize /path/to/paper --references /path/to/references/
/arx-ai-deodorize /path/to/paper --references /path/to/references/ --deep
```

## Origin / References

- Tracks 1-8 (academic): native to this skill.
- Track 9 (JP patterns J1-J6) and Track 10 (2-axis reflection loop): adapted from `mizchi/skills/mizchi-blog-style` (https://github.com/mizchi/skills/tree/main/mizchi-blog-style). Personal-blog-only conventions (tl;dr, 口語混入) were excluded; only the generalizable AI-smell axes were merged on 2026-05-08.
