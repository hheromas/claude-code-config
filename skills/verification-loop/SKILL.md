---
name: verification-loop
description: >
  Trigger when code changes need full quality verification. Use when "verify",
  "run checks", "quality check code", "verification loop", "品質検証" is requested.
argument-hint: "[--stage build|typecheck|lint|test|security] [--fix]"
allowed-tools: Bash, Read, Glob, Grep
---

# 5-Stage Verification Loop

コード変更後の品質検証を 5 段階で順次実行し、結果をサマリーする。

## Stages

| # | Stage | Command | Fails on |
|---|-------|---------|----------|
| 1 | Format | `uv run --frozen ruff format .` | diff (--check mode) |
| 2 | Typecheck | `uv run --frozen pyright` | type errors |
| 3 | Lint | `uv run --frozen ruff check . --fix` | unfixable violations |
| 4 | Test | `uv run --frozen pytest --cov` | test failures / low coverage |
| 5 | Security | `uv run --frozen bandit -r .` | high-severity findings |

## Workflow

1. `$ARGUMENTS` に `--stage` があれば指定ステージのみ実行、なければ全 5 段階を順次実行
2. 各ステージの終了コードとサマリーを記録
3. ステージ失敗時: `--fix` があれば自動修正を試行し再実行、なければ停止して報告
4. 全ステージ完了後、結果テーブルを出力

## Output Format

```markdown
## Verification Result

| Stage | Status | Duration | Notes |
|-------|--------|----------|-------|
| Format | PASS | 2s | - |
| Typecheck | FAIL | 8s | 3 errors in src/main.py |
| Lint | SKIP | - | blocked by typecheck failure |
| Test | SKIP | - | blocked |
| Security | SKIP | - | blocked |

**Verdict**: FAIL (typecheck)
```

## Gotchas

- Commands reference `rules/coding/python.md` quality commands. If the project uses a different stack, stages must be adapted manually.
- `ruff format` without `--check` modifies files in place. Stage 1 runs format (write mode) first, then subsequent stages see formatted code.
- `--fix` on lint stage can introduce changes that break typecheck. If lint fix triggers, re-run typecheck before proceeding to test.
- `uv run --frozen` requires a valid `uv.lock`. If lock file is stale, all stages fail with a confusing dependency error.
- Security stage (bandit) may flag false positives. Review findings before treating them as blockers.
