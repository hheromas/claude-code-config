# User Directive Fidelity

User mandates are **terminal vetoes**, not soft preferences. Weakening a "delete" instruction into "trim" or "merge" is a fidelity violation, regardless of downstream judgement about merit.

## Rule: Mandate-as-Terminal-Veto

When the user issues a directive containing one of the following verbs, the directive is **non-negotiable** and **non-substitutable**:

- delete / 削除 / drop / remove
- keep / 残す / preserve
- forbid / 禁止 / never
- mandate / 必須 / must / always

The agent MAY ask for clarification BEFORE acting. The agent MUST NOT silently substitute a weaker action ("trim", "shorten", "merge", "soften") for a stronger directive ("delete", "remove", "drop").

## Status Code Allowlist

When reporting on a directive's disposition, only the following status codes are allowed:

| Code | Meaning |
|------|---------|
| `DONE` | Directive applied as stated |
| `DELETED` | Target removed per directive |
| `NOT-NEEDED` | Directive obsoleted by a later user instruction (cite which) |
| `BLOCKED` | Cannot apply; reason + ask required |

Forbidden status codes (these silently weaken the directive):

- `WEAKENED`
- `TRIMMED` (when "delete" was the directive)
- `MERGED` (when "delete" was the directive)
- `SOFTENED`
- `PARTIAL` (without explicit user agreement)

## Required Workflow

1. **Quote the user verbatim** in the work dump before acting (verbatim quote prevents paraphrasing drift).
2. **Map verb → status**: `delete` → `DELETED` (or `BLOCKED + reason`). No substitution.
3. **If the agent disagrees**: surface the disagreement BEFORE acting. Do not act-then-justify.
4. **Cross-file scan**: when a directive applies broadly (e.g., "delete all em-dashes"), grep the full target tree and report scope before acting.

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Substitute "trim" for "delete" | Delete as stated; ask if scope unclear |
| Report `WEAKENED` | Report `DONE` / `DELETED` / `BLOCKED` only |
| Apply with caveats not in the directive | Apply literally; raise caveats in a separate turn |
| Defer-to-judgement after the fact | Defer-to-user BEFORE acting |
| Carry forward across sessions silently | Re-confirm directive on resume if scope is broad |

## Sources

- BG1 ap-4 (universal); BG5 LB-3 (root cause: "delete" → "trim" weakening); BG6 K1 (mandate hierarchy); MEMORY `feedback_no_visual_compression_tricks` reinforces the pattern.
- Master synthesis: P0-01 / TK-N8 + TK-N9 / NF-06.

## Cross-link

- `delegator/policy.md` — when delegating to Codex, the user-directive contract carries through; do not let an expert "soften" a directive in advisory mode.
- `core/02-workflow.md` — fits under "既存コードの無断削除禁止" (削除前報告) and "エビデンスに基づく判断" (do not infer user intent).
