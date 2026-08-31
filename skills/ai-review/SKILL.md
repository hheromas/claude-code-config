---
name: ai-review
description: Trigger when user requests "AI review", "parallel review", "review with multiple agents". Orchestrates multi-agent review of papers or documents.
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# reviewing システム

論文・発表資料のAIレビュー運用ルール。

---

## マスタールールブック

論文・発表資料のAIレビューを行う際は、プロジェクトごとに定義されたルールブックを参照すること：
```
$REVIEW_RULES
```

> **NOTE**: プロジェクトの CLAUDE.md で `$REVIEW_RULES` パスを定義すること。
> 例: `$REVIEW_RULES = /path/to/project/reviewing/rules/master_rule_book.md`

## 並列 Agent によるレビュー実行

レビューを実行する際は、各 source_id を独立した Agent で並列実行し、コンテキストの混同を防ぐ：

```
Orchestrator
├── Agent (source_id_1) → review_1.md  ─┐
├── Agent (source_id_2) → review_2.md  ─┼─ 並列
└── Agent (source_id_N) → review_N.md  ─┘
                ↓ 全完了後
        Summary Agent → summary.md
```

## Iteration 継続条件（ケースバイケース）

ゲート基準は状況に応じて調整：

| ケース | [高] | [中] | [低] | 判定 |
|--------|------|------|------|------|
| 厳格モード | Reject | Reject | Reject | 全て解消まで |
| 標準モード | Reject | Reject | Accept | [高][中]解消まで |
| 緩和モード | Reject | Accept | Accept | [高]解消まで |

デフォルトは標準モードだが、タスク開始時に確認するか、order.md で明示する。

## 自走型 TODO 管理

長時間タスクでは、TODO に「TODO を追加する TODO」を含め、課題解決まで自走し続ける：

```
- [ ] 現在のタスクを実行
- [ ] 問題があれば新しい TODO を追加
- [ ] order.md 要件を再確認
- [ ] 全完了まで繰り返し
```

## Gotchas

- `$REVIEW_RULES` must be defined in the project's CLAUDE.md before invoking this skill. If undefined, the master rulebook path resolves to nothing and reviews run without rules.
- Each parallel Agent receives an independent context. Do not assume shared state between review agents -- pass all necessary context explicitly.
- The iteration gate mode (strict/standard/relaxed) defaults to standard but should be confirmed at task start. Forgetting to set it causes ambiguous accept/reject decisions.
- Summary Agent runs only after ALL parallel agents complete. If one agent hangs, the entire pipeline stalls.

