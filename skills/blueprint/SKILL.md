---
name: blueprint
description: >
  Trigger when generating a multi-session execution plan. Use when "blueprint",
  "execution plan", "実行計画", "plan from goal", "break down into phases" is requested.
argument-hint: "<one-line goal> [--phases N] [--track]"
allowed-tools: Read, Write, Bash, Glob, Grep, Edit
---

# Blueprint: Multi-Session Execution Plan Generator

1行のゴールから Phase 構造の実行計画を生成し、各 Phase に自己完結した order.md を作成する。

## Workflow

1. **Goal Analysis**: `$ARGUMENTS` からゴールを解析
   - スコープの大きさを判定 (small: 1-2 phases, medium: 3-5, large: 6+)
   - 必要なスキル/ツールを列挙
   - 依存関係グラフを構築
2. **Phase Decomposition**: ゴールを Phase に分解
   - 各 Phase は独立した成果物と完了条件を持つ (02-task-workflow.md の Phase 判定基準に準拠)
   - `--track` 指定時は並列 Track 構成を設計
3. **order.md Generation**: 各 Phase の order.md を生成
   - 入力: 前 Phase の成果物参照 (パスのみ、内容は含めない)
   - 目的: 1-2 文
   - 成功基準: 検証可能な条件リスト
   - 制約: Phase 固有の注意事項
4. **plan.md Generation**: /task-init 形式の plan.md を生成
5. **Validation**: SC-3R R1 相当の構造検証を実行

## Phase Decomposition Rules

| 分割する | 分割しない |
|---------|-----------|
| 単体でレビュー可能な成果物がある | 前後と一体でしか成果物にならない |
| 独立した完了/失敗条件を定義できる | 定型手順 (commit, SC-3R) |
| 並列化にメリットがある | 強い直列依存で分割コスト > 効果 |

## Output Structure

```
phases/
  phase_001/
    order.md    # 自己完結した指令書
    work/       # (空、実行時に使用)
    appendix/   # (空、実行時に使用)
  phase_002/
    order.md
    ...
plan.md         # 全体計画 + Phase テーブル
```

## Gotchas

- order.md is immutable after creation. If the blueprint needs revision, create a new Phase or update plan.md with amendments -- never edit existing order.md files.
- Each order.md must be self-contained for a fresh session. Include absolute paths, not relative references to "the previous phase's output".
- The skill generates structure only. It does not execute any Phase. Use /task-execute or manual workflow to run each Phase.
- `--track` mode requires an orch folder. The skill creates it automatically but the user must confirm Track assignment before execution.
- Large goals (6+ phases) should be reviewed by the user before order.md generation. The skill pauses after Phase decomposition for approval.
