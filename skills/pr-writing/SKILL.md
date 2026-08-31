---
name: pr-writing
description: PR 本文をレビュアー目線で読みやすく書く。トップレベルは要点のみ、詳細は details/summary で折り畳む。「PR 文書」「PR 本文」「PR 書く」「コンパクトに」「details/summary」で使用。
argument-hint: "[対象 PR の要件 or 空欄で直前のタスクから生成]"
---

> Source: pckk/order/.claude/skills/pr-writing (project-local skill)
> Adapted: 2026-08-18 by claude-shared (pckk / pacific-proposal 依存部分を汎用化し、
> プロジェクト固有 PR template への参照は「各プロジェクトの template を尊重」表記に変更)

# PR 本文の書き方

セクション構造 (`## 概要 / ## 変更内容 / ## 影響範囲 / ## 動作確認 / ## レビュー観点 / ## 提出前チェック` 等) は **各プロジェクトの `.github/pull_request_template.md` を尊重する**。本 skill はその**中身の書き方**を扱う。

## 基本方針

- **トップレベルはコンパクト**: 1 セクション 1〜3 行が目安。レビュアーが画面を埋めない量に収める
- **詳細は `<details><summary>...</summary>` で折り畳む**: 行数・件数・ログ・edge case はトップに置かない
- **専門用語は plain words で言い換える**: 「tiebreaker」「決定論的」等の jargon は概要で plain に説明する。例: 「`id` を最終ソートキーに足して、同点の行同士でも並びが確定する」
- **外部ファイル参照は本文に埋め込む**: `phases/...` の path リンクは PR には残さず、必要な内容を `<details>` に取り込む（私的な調査ディレクトリを公開しない）

> コンパクトさの目安は `../slack-zakki/SKILL.md` 級。**ただし slack-zakki の casual 口語体（〜してる、〜かも）は採用しない**。PR は常体（だ・である）。slack-zakki は「短さの物差し」としてだけ参照する

## トップに置いていいもの / details に下げるもの

| カテゴリ | トップに置く | details に下げる |
|---------|-----------|---------------|
| 概要 | 何を直したか・なぜ直したか・チケット | 真因の長文解説、機序の図解 |
| 変更内容 | 1 行サマリ（何系のパターン適用 等） | 件数、ファイル一覧、`git diff --stat` 出力 |
| 動作確認 | キー結果のみ（PASS / 主要証拠 1 行ずつ） | 各テストの個別結果、コマンド、生ログ |
| 共有事項 | レビュアーが必ず見るべき観点 (3 行以内) | 業務確認推奨の細目、性能注意、非ブロッカー留意、補助情報 |

## 削るべきもの（anti-patterns）

「何を書かないか」が「何を書くか」と同じくらい重要。以下は **トップに残ったら削る**:

### 1. 件数・サイズの top 二重掲載

❌ NG（top と details の二重掲載）:
```markdown
## 変更内容
合計 21 行修正、8 ファイル、+31 / -22 行。5 パターンで一律 id tiebreaker を適用。
<details>
<summary>パターン別件数</summary>
- Pattern A: ...
```

✅ OK（top は質的サマリだけ）:
```markdown
## 変更内容
5 パターンで一律 id tiebreaker を適用。
<details>
<summary>パターン別件数</summary>
- Pattern A: ...
```

数値が必要なら details の中で完結させる。

### 2. 環境固有制約の言い訳

❌ NG（dev 環境問題を本論に混ぜる）:
```markdown
- 視覚回帰はローカル MUI X Pro 期限切れで非掲載（licensed env で別途実施推奨）
```

✅ OK: details の「視覚再現の試行と結論」等にまとめるか、必要性が低ければ書かない。

ローカル特有の問題（ライセンス、CI 設定、ホスト固有 path）は **PR の評価に直接関係しない限り削る**。

### 3. ストーリーテリング・後付けの状況説明

❌ NG（経緯の語り）:
```markdown
- Pattern A `delivery-slips.service.ts:240`: ...新設。なお本 PR レビュー期間中に user 自身が本番 prod で同ページの「順序ランダム入れ替わり」事象を観察し報告 → 主ソート安定化は user 期待と整合する方向に後方確認済（業務確認は別タスクで本人確認推奨）
```

✅ OK（事実だけ）:
```markdown
- Pattern A `delivery-slips.service.ts:240`: 修正前 `ORDER BY` 不在 → planner 任せだったため、`dailyArrivalId, id` 順を新設。
```

「user が観察した」「後方確認」等のメタ情報は work / report ファイル側で記録し、PR には事実と契約だけ残す。

### 4. 「別タスク」の重複言及

❌ NG（共有事項の top で「別タスク」と言ってるのに details でも繰り返す）:

```markdown
レビュー観点:
- 既存 spec に orderBy assert 無し → 回帰テスト追加は別タスク

<details>
<summary>その他の留意事項</summary>
- 回帰テスト spec 未追加: ... 別タスク候補
</details>
```

✅ OK: top で言ったら details では再述しない。逆も同じ。**1 つの事実は 1 箇所**。

### 5. 環境変数や hook の状態説明

❌ NG（ローカル開発のノイズが共有事項に混入）:
```markdown
- husky pre-commit hook が permission 644 で skip: 環境固有...
```

✅ OK: 本 PR の挙動を変えないなら **記載不要**。レビュアーに見せたい本 PR 起因の事実だけ書く。

### 6. 過剰な details ネスト

❌ NG: 1 セクションに details 5 個以上、summary 内が長い文

✅ OK: 1 セクション 2〜3 個目安、summary は 1 フレーズ「**◯◯詳細**」程度

## details ブロックの典型ラインナップ

PR の規模に応じて選ぶ。重複は避ける:

- **「パターン別件数」「変更ファイル一覧」**（変更内容セクション）
- **「typecheck / lint / jest 詳細」**（動作確認）
- **「SQL planner 切替実験 N: ○○」**（動作確認）— クエリ別に 1 つずつ
- **「業務確認推奨の箇所」**（共有事項）— 主ソート新設等
- **「性能・運用注意」**（共有事項）— EXPLAIN ANALYZE のカバレッジ、index 注意
- **「その他の留意事項（非ブロッカー）」**（共有事項）— 別タスク化されている既知問題
- **「影響テーブルマップ（Pattern × ファイル）」**（共有事項）— レビュー時の地図
- **「視覚再現の試行と結論」**（共有事項）— ローカル制約等

## ルール（補足）

- **ローカル絶対パス禁止**。プロジェクト内の私的調査ディレクトリ (order の `phases/...` 等) のパスは PR に残さず、必要な内容は `<details>` に取り込む
- **`関連URL` は backlog のみが基本**: 内部 phase 参照は本文 `<details>` に取り込む
- **バズワード禁止**（最適化・改善・向上・効率化）。「決定論化」「安定化」のような具体語のみ
- **常体（だ・である）**。コミットメッセージ規約と合わせる

## 手順

1. 対象 PR の要件を把握する（直前の Phase 成果物 / report.md / appendix の内容を確認）
2. プロジェクトの `.github/pull_request_template.md` があればそのセクション構造を踏まえる
3. 各セクションについて、本 skill の表「トップに置いていいもの / details に下げるもの」で振り分ける
4. **「削るべきもの」のチェックリストで top を洗う**:
   - [ ] 件数・サイズが top と details で重複していないか
   - [ ] 環境固有の言い訳が混じっていないか
   - [ ] ストーリー / 経緯が混じっていないか
   - [ ] 「別タスク」の重複言及がないか
   - [ ] hook / 環境設定の note がないか
5. 専門用語は plain words に言い換える（特に概要）
6. details は 1 セクション 2〜3 個目安
7. 完成後、トップレベルだけ通読して 1 画面に収まるか確認（収まらなければ追加で details 化、または削れる本文がないか再チェック）
8. ファイル配置先はプロジェクトの慣習に従う（例: `phases/phase_NNN/appendix/pr.md`）。`gh pr create --body` で `cat` する前提

## 関連 skill / rule

- プロジェクトの `.github/pull_request_template.md`: セクション構造（必読）
- `../writing-deodorize/SKILL.md`: AI 臭の脱臭（バズワード除去）
- `../slack-zakki/SKILL.md`: コンパクトさ level の物差し（文体は別物。参照のみ）
- プロジェクト固有の PR 投入手順 (push、`gh pr create --base main` 等) は各 project の rules/ or skills/ を参照
