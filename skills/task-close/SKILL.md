---
name: task-close
description: Trigger when all phases of a task are complete. Use when "task close", "タスク完了", "close task", "final check" is requested.
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
---

# タスククロージャ

タスク完了時の最終検証とクロージャ処理。

## 使用方法

- `/task-close` — クロージャチェックを開始

タスクの全 Phase 完了後に使用する。

## クロージャフロー

### Step 1: plan.md 整合性チェック

1. 全 Phase のステータスが "done" になっているか
2. 成功基準がすべてチェック済みか（`[x]`）
3. Phase 構成表と `phases/` ディレクトリが一致しているか
4. **スコープ外の全項目が `/task-redistribute` 済みか**:
   - 全項目に具体タスク ID or 「対応不要（理由）」があるか
   - 「別タスク」「将来対応」等の曖昧な記述がゼロか
   - 完了済みタスクへの振り先がゼロか
   - 未処理の場合は `/task-redistribute` を先に実行し、完了してから続行

### Step 2: レポート完全性チェック

```bash
# 全 Phase に report.md が存在するか確認
for dir in $TASK/phases/phase_*/; do
  phase=$(basename "$dir")
  if [ ! -f "$dir/report.md" ]; then
    echo "MISSING: $phase/report.md"
  fi
done
```

各 report.md について:
- order.md の要件に対応する結果が記載されているか
- 100 行以下か（超過分は appendix/ に分離されているか）
- テスト結果や検証結果が含まれているか

### Step 3: リポジトリ commit チェック

`/multi-repo-check` を使い、タスクで変更した全リポジトリの git status を一括確認する。order リポジトリだけでなく、コード変更したリポジトリも必ず確認すること。未コミット変更がある場合は `/multi-repo-check commit` でコミット提案を取得できる。

### Step 4: ドキュメント更新チェック

タスクの変更内容に応じて、以下のドキュメントが更新されているか確認:

| 変更タイプ | 更新対象 |
|-----------|---------|
| Docker 構成変更 | `docs/infrastructure/docker-services.md` |
| NGINX 設定変更 | `docs/architecture/nginx-routing.md` |
| API 追加・変更 | `docs/api/bse-core-endpoints.md` |
| Route/Component 追加 | `docs/frontend/svelte-structure.md` |
| DB スキーマ変更 | `docs/database/mysql-schema.md` |

### Step 5: 最終サマリー出力

```markdown
## タスククロージャレポート

### 基本情報
- タスク: [タスク名]
- 期間: [開始日] - [完了日]
- Phase 数: [N]

### 成功基準の充足
| # | 基準 | 状態 |
|---|------|------|
| 1 | [基準] | PASS/FAIL |

### 変更リポジトリ
| リポジトリ | 最終 commit | 内容 |
|-----------|------------|------|
| [repo] | [hash] | [概要] |

### スコープ外（全項目振り直し済み）
| 項目 | 追跡先 |
|------|--------|
| [項目] | **NNN-taskname** / 対応不要（理由） |

### 判定: COMPLETE / INCOMPLETE
```

## クロージャ判定基準

| 条件 | 必須 |
|------|------|
| 全 Phase が done | Yes |
| 全成功基準が PASS | Yes |
| 全 report.md が存在 | Yes |
| 全リポジトリが commit 済み | Yes |
| 関連ドキュメントが更新済み | Yes |
| スコープ外が全項目振り直し済み（曖昧・未定ゼロ） | Yes |

全条件を満たした場合のみ COMPLETE と判定する。
