---
name: task-init
description: Trigger when creating a new task. Use when "new task", "タスク作成", "create task", "init task" is requested.
argument-hint: "[YYYYMMDD/NNN-taskname]"
allowed-tools: Bash, Read, Write, Edit, Glob
---

# タスク初期化

`$ARGUMENTS` で指定されたパス、または対話的にタスクフォルダを作成する。

## タスクフォルダ作成コマンド

```bash
# 変数定義
DATE="YYYYMMDD"
TASK="NNN-taskname"
BASE="${ORDER}/${DATE}/${TASK}"

# ディレクトリ作成
mkdir -p ${BASE}/{.claude,phases/phase_001/{appendix,work}}

# settings シンボリックリンク（マスターファイル名を自動検出）
if [ -f "${ORDER}/.claude/settings.local.json" ]; then
  SETTINGS_MASTER="settings.local.json"
else
  SETTINGS_MASTER="settings.json"
fi
ln -s ../../../.claude/${SETTINGS_MASTER} ${BASE}/.claude/settings.json
```

## タスクフォルダ命名規則

形式: `NNN-taskname`（0埋め3桁 + ハイフン + タスク名）

### 通常タスク

```
001-bugfix/
002-refactor/
003-feature-auth/
```

### 並列作業（orch/track パターン）

複数タスクを並列で進める場合:

| プレフィックス | 役割 | 例 |
|---------------|------|-----|
| `orch` | 全体管理・オーケストレーター | `001-orch-release/` |
| `track-{letter}` | 並列トラック（A, B, C...） | `002-track-a-api/` |

```
order/20260201/
├── 001-orch-release/       # 全体管理、plan.md に Track 構成を記述
├── 002-track-a-api/        # Track A: API 作業
├── 003-track-b-frontend/   # Track B: フロントエンド作業
└── 004-track-c-config/     # Track C: 設定作業
```

**ルール**:
- `orch` フォルダの plan.md に Track 構成・依存関係を記述
- 各 Track は独立して進行可能
- Track 間の同期が必要な場合は orch が管理
- **Cross-track handoff**: Track 間でデータや成果物を引き渡す場合は、orch の plan.md に handoff ポイントを明記し、引き渡し元 Track の report.md に「handoff to Track X」を記録
- **Track 混在禁止**: 1セッションで複数 Track の作業を混在させない。Track 切替時はコミットしてから

## CLAUDE.md テンプレート

タスクフォルダ直下に CLAUDE.md を作成:

```markdown
# NNN-taskname

## 概要

[タスクの目的と背景]

## パス変数定義

# 固定パス（プロジェクト共通）
$PROJECT_ROOT = (プロジェクトルート)
$ORDER        = $PROJECT_ROOT/order

# タスク固有パス
$TASK      = $ORDER/YYYYMMDD/NNN-taskname
$OUTPUT    = $TASK/phases

## ステータス

**進行中**

## 参照

- `$TASK/plan.md`: 計画書
```

**ルール**:
- タスク開始時に作成、進行中は随時更新
- 相対パスではなく絶対パスを使用
- タスク開始前に `git worktree list` でパス検証

## Gotchas

- The `settings.json` symlink uses a relative path (`../../../.claude/...`) that assumes exactly 3 directory levels from `$ORDER` to the task's `.claude/` directory. Non-standard nesting depths break the symlink.
- The skill auto-detects `settings.local.json` vs `settings.json` in `$ORDER/.claude/`. If neither exists, the symlink target is invalid and Claude Code may fail silently.
- `$ORDER` must be defined in the project's CLAUDE.md before invoking this skill. If undefined, the `$BASE` path computation produces a broken directory structure.
- Parallel task naming (`orch`/`track-{letter}`) requires the orchestrator folder to exist first. Creating track folders without an `orch` folder leaves no coordination point.
- The 3-digit zero-padded prefix (`NNN-`) determines execution order. Gaps are fine, but reusing numbers causes directory conflicts.

## plan.md テンプレート

```markdown
# NNN-taskname 計画書

## 目的

[1-2文で目的]

## 成功基準

1. [基準1]
2. [基準2]

## Phase 構成

| Phase | 内容 | ステータス |
|-------|------|-----------|
| 1 | [内容] | 待機 |
```

**plan.md の権威性**: plan.md がタスク全体の正（SSOT）。Phase のステータスは plan.md の記載を厳守。

