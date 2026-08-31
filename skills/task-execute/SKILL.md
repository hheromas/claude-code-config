---
name: task-execute
description: Trigger when starting phase execution. Use when "execute phase", "phase 実行", "run phase", "start phase" is requested.
argument-hint: "[phase_NNN]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Phase 実行ガイド

Phase を正しい手順で実行するためのプロセスガイド。

## 使用方法

- `/task-execute` — 現在の Phase を確認し実行開始
- `/task-execute phase_NNN` — 特定の Phase を実行

対象 Phase: $ARGUMENTS（指定なしの場合は plan.md から次の未完了 Phase を自動判定）

## Phase 実行フロー

### 0. 前提確認

1. plan.md を読み、現在の Phase ステータスを確認
2. 対象 Phase の order.md を読み、要件を把握
3. 前提となる Phase が完了しているか確認
4. `ls work/` で既存ファイルを確認（番号衝突回避）

**重要**: order.md は作成後に変更しない（不可変）。実行中に乖離が生じた場合は report.md に差異と理由を記録する。

### 1. 実行開始

1. plan.md の対象 Phase ステータスを "in progress" に更新
2. Safety commit: `order: Start phase_NNN - [概要]`

### 2. 作業実行（think → dump → act）

1. 考えたことを work/ にダンプしてから実行に移る
   - 命名: `P{XX}_STEP{N}_{内容}.md`（`XX` = phase 番号の zero-padded 2 桁。例: phase_003 → `P03_STEP1_design.md`。`STEP{N}` は phase 内連番）
   - 「後でまとめる」禁止。逐次書き出す
2. 大量ファイル精読時は 1 単位ごとに dump
3. 2-3 単位ごとに safety commit
4. スコープ外の問題を発見したら即座に記録:
   - work/ にメモ
   - plan.md の「スコープ外」セクションに追記
   - 中断 vs 自走継続の判断は §"停止条件と user 介入の要否" table を参照

### 3. マルチリポジトリ作業時の注意

複数リポジトリにまたがる変更がある場合:

1. 各リポジトリでの変更を明確に分離して記録
2. 変更したリポジトリの一覧を work/ にメモ
3. 各リポジトリで個別に commit
4. commit ハッシュを work/ に記録

### 4. Phase 完了

1. 成功基準を order.md と照合
2. report.md を作成（100行以下、詳細は appendix/ に分離）
3. plan.md のステータスを "done" に更新
4. Safety commit: `order: Complete phase_NNN - [概要]`

## 完了前チェックポイント

| # | 確認項目 | 確認方法 |
|---|---------|---------|
| 1 | order.md の全要件を満たしたか | order.md と report.md を突合 |
| 2 | work/ に中間成果物が記録されているか | `ls work/` |
| 3 | report.md が 100 行以下か | `wc -l report.md` |
| 4 | plan.md のステータスが最新か | plan.md を確認 |
| 5 | 変更した全リポジトリが commit 済みか | 各リポジトリで `git status` |
| 6 | スコープ外の発見事項が記録されているか | plan.md の「スコープ外」確認 |

## 停止条件と user 介入の要否

Phase 実行中に以下の trigger に遭遇した場合、autonomous 自走を継続するか / 中断して user 介入を要求するかを下表で判定する。判定 key は **「order.md 既述の成功基準が現実装で達成可能か」**。不能なら autonomous 自走 NG。

**Lookup timing**: §0 前提確認時に table 全 row を eager-read で skim し trigger 該当を 1-pass 判定（happy path で該当無しなら以降 lazy）。複数 row が同時成立する場合は **上から評価し最初に match した row を適用**（lexical priority）。

| Trigger | Default 動作 | user 介入要否 | 必須 deliverable |
|---------|-------------|--------------|-----------------|
| 前提 phase が未完了 (§0.3) | abort + report (Phase skip 禁止) | 要 | work/ メモ + status report (確認事項 + 復旧パス) |
| `$ARGUMENTS` 指定 phase が plan.md 不在 / order.md 不在 | abort + handoff (auto-fallback しない) | 要 | status report (確認事項 + 復旧パス) |
| order.md の構造不備 (成功基準 section 欠落 等) を発見 | abort + handoff (初期不備の補完は user 確認の上で許容、autonomous 補完禁止) | 要 | status report (副次発見 field) |
| scope 外発見 (order.md の成功基準は依然達成可能) | work/+plan.md 「スコープ外」記録 + 自走継続 | 不要 | work/ + plan.md 追記 |
| scope 外発見 (order.md の成功基準が達成不能になる) | 中断 + user 介入要求 | **要** | work/+plan.md+report.md「差異と理由」+ user 提案 |
| 重大環境変化 (外部依存破壊・API 仕様変更等で達成不能) | 中断 + user 介入 | 要 | 同上 |

**補足**:
- 中断時も `order: Start phase_NNN - <概要>` は **発行済みのまま残す** (historical fact)。`Complete` は発行しない。
- `status report` には必ず「**何を確認すれば復旧できるか**」を含める (cross-skill handoff contract)。
- 副次的に隣接 Phase の異常を発見した場合は「副次発見」として report に分離記述 (引数解釈の勝手変更・ロールフォワード禁止)。

## アンチパターン

| やりがち | 正しいやり方 |
|---------|-------------|
| 全作業完了後にまとめて work/ にダンプ | 逐次ダンプ（think → dump → act） |
| report.md に詳細を全部書く | 100 行以下、詳細は appendix/ |
| plan.md 更新を忘れる | Phase 開始時・完了時に必ず更新 |
| 他リポジトリの commit を忘れる | 変更リポジトリ一覧を work/ に記録 |
| スコープ外の問題を口頭で済ませる | plan.md に明示的に記録 |

## Gotchas

- **Phase skipping is prohibited.** Phases must execute in order. If a Phase's prerequisites are not met, stop and report rather than skipping ahead.
- `order.md` is **immutable** after creation. If reality diverges from the order, record the divergence and rationale in `report.md` -- do not edit `order.md`.
- Safety commits (`order: Start/Complete phase_NNN`) are mandatory bookends. Forgetting them makes it impossible to recover state if the session is interrupted.
- `work/` file naming uses `P{XX}_STEP{N}_{content}.md`. Check `ls work/` before creating files to avoid number collisions with existing files from other phases.
- Multi-repo changes require per-repo commits. Forgetting to commit in a secondary repo is a common oversight -- always maintain a repo change list in `work/`.
