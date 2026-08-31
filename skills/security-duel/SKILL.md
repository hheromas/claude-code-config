---
name: security-duel
description: Black Hacker vs White Hacker の攻防デュエルでセキュリティ監査レポートを生成する。攻撃者視点で脆弱性を洗い出し、防御者視点で対策をまとめる。「セキュリティ」「脆弱性」「攻撃」「ペネトレーション」「threat model」「セキュリティレビュー」といった依頼で使用する。
argument-hint: "[対象ディレクトリ or 空欄でカレント]"
allowed-tools: Read, Glob, Grep, Bash(git log:*), Bash(find:*), Write
---

# security-duel - 攻防セキュリティ監査

2つのペルソナで交互にプロジェクトを検証し、脆弱性と対策をレポートにまとめる。
コード変更・攻撃コマンド実行はしない。レポートと提案のみ。

## ペルソナ

**Black Hacker（攻撃者）**: 容赦なく、創造的に攻撃面を探す。「どこが甘い？ どこから入れる？ 何を盗める？」。OWASP Top 10、CWE、実際の攻撃パターンに基づく。

**White Hacker（防御者）**: 現実的に、コスト対効果を考えて防御策を設計する。Defense in depth、最小権限、ゼロトラスト。

## Phase 1: 偵察（Reconnaissance）

対象: `$ARGUMENTS` で指定されたディレクトリ、または現在のプロジェクト。

攻撃面（Attack Surface）を特定する。重点的に読むべきコード:

```bash
# 認証・認可まわりのファイルを探す
grep -rl "auth\|login\|session\|token\|password\|jwt" --include="*.{ts,js,py,go,rb}" .

# SQL/DB操作を探す
grep -rl "query\|execute\|SELECT\|INSERT\|findMany\|prisma" --include="*.{ts,js,py,go,rb}" .

# 環境変数・シークレットを探す
find . -name ".env*" -o -name "*secret*" -o -name "*credential*" | head -20
```

チェック対象:
1. 認証・認可（ログイン、セッション、権限制御）
2. 入力処理（バリデーション、サニタイゼーション）
3. データ保存（クエリ構築、暗号化、シークレット管理）
4. 外部通信（API コール、Webhook）
5. インフラ（Docker, nginx, ポート公開）
6. 依存関係（既知の脆弱性）

## Phase 2: Black Hacker の攻撃

各脆弱性について以下を記述:

- **攻撃手法**: 具体的なペイロード・手順（実行はしない、思考実験として記述）
- **影響度**: 成功時の被害
- **難易度**: Low / Medium / High
- **証拠**: `file:line` でコードの脆弱箇所を指す

**例**:
```
### Finding: User Search API の SQL Injection

**攻撃手法**:
POST /api/users/search
{"query": "' OR '1'='1' --"}

**影響**: 全ユーザーデータ漏洩
**難易度**: Low（ツールで自動化可能）
**証拠**: `src/api/users.ts:47` — テンプレートリテラルで直接クエリ構築
```

## Phase 3: White Hacker の防御

各攻撃に対して防御策を設計:

- **対策**: 具体的な修正方法（修正前→修正後のコード例付き）
- **優先度**: Critical / High / Medium / Low
- **工数**: hours / days / weeks
- **副作用**: 既存機能への影響

**例**:
```
**対策**: パラメータ化クエリに変更

修正前（脆弱）:
  const result = await db.query(`SELECT * FROM users WHERE name = '${input}'`)

修正後（安全）:
  const result = await db.query('SELECT * FROM users WHERE name = $1', [input])

**優先度**: Critical
**工数**: 2 hours
**副作用**: なし
```

## Phase 4: デュエル（相互検証）

White Hacker の防御策に対して Black Hacker が再攻撃:
- 防御を回避できる方法はないか？
- 対策の実装にバグが入りやすい箇所は？
- 新たな攻撃面が生まれていないか？

White Hacker が再反論し、最終的な防御策を確定する。

## Phase 5: レポート出力

`security-duel-report-YYYYMMDD.md` としてプロジェクトルートに保存。

```markdown
# Security Duel Report: [プロジェクト名]

日付: YYYY-MM-DD
対象: [ディレクトリパス]

## Executive Summary
- 検出された脆弱性: N 件
- Critical: N / High: N / Medium: N / Low: N
- 即時対応が必要: N 件

## Attack Surface
| 領域 | ファイル数 | リスク評価 |
|------|----------|-----------|
| 認証 | N | High/Medium/Low |
| ... | ... | ... |

## Findings

### Finding #1: [脆弱性タイトル]
**Severity**: Critical

**Black Hacker**:
- 攻撃手法: [ペイロード例]
- 影響: [被害内容]
- 証拠: `file:line`

**White Hacker**:
- 防御策: [修正方法]
- 修正前/後のコード例
- 工数: N hours

**デュエル結果**: 防御十分 / 追加対策要
---
（Finding を繰り返す）

## Action Plan

### Immediate（今日 — Critical）
- [ ] ... (Nh)

### This Week（High）
- [ ] ... (Nh)

### This Month（Medium）
- [ ] ... (Nd)

### Backlog（Low）
- [ ] ...

## 監視・検知の推奨事項
- ...
```

## うまくいかないとき

- 静的サイトなど攻撃面が極めて少ない → その旨を伝え、依存関係チェックだけ実施
- 認証がない公開 API → 認証導入自体を最優先の Finding として報告
- 本番シークレットがコードに見つかった → **即座にユーザーに警告**（レポート完成を待たない）
