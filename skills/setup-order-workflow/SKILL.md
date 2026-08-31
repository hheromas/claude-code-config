---
name: setup-order-workflow
description: Trigger when setting up a new project with order workflow. Use when "setup order", "init order", "order workflow setup", "ワークフロー初期化" is requested.
argument-hint: "[project_name]"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Order Workflow セットアップ

新しいプロジェクトに order ベースのタスク管理構造を初期化する。

## 使用方法

```
/setup-order-workflow
/setup-order-workflow <project_name>
```

## 前提条件

- テンプレートが存在すること（`${CLAUDE_SHARED:-$HOME/box/claude-shared}/templates/order-workflow/`）
- 対象ディレクトリが git リポジトリであること（推奨）

## セットアッププロセス

### Step 1: プロジェクト情報の収集

ユーザーに以下を確認（AskUserQuestion 使用）。
**注意**: 各質問に最低 2 つの選択肢を用意すること（AskUserQuestion の制約）。現在のディレクトリやリポジトリ名をデフォルト候補にし、「その他」は自動提供される Other で対応。

1. **プロジェクト名**
   - 候補: 現在のリポジトリ名、親ディレクトリ名
   - 例: `your-project`, `your-service`, `your-tool`

2. **プロジェクトルート**（絶対パス）
   - 候補: 現在の作業ディレクトリ、親ディレクトリ
   - 例: `/home/user/box/myproject`

3. **プロジェクト概要**（1文）
   - 候補: リポジトリの説明文（あれば）
   - 例: `OASIS エコシステムのドキュメントハブ兼インフラ管理リポジトリ`
   - 例: `魚市場 EC システム uomart のマルチサービスマーケットプレイス`

4. **additionalDirectories**（複数選択可）
   - 自動検出: プロジェクトルートの親ディレクトリ内にある git リポジトリ一覧を `ls` で取得し候補を提示
   - プロジェクトルート自身も候補に含める
   - docs/ サブディレクトリがあればそれも候補に含める
   - ユーザーに選択させる（AskUserQuestion multiSelect）

### Step 2: 既存環境の検出

order/ ディレクトリが既に存在するか確認し、分岐する:

1. **order/ が存在しない場合**: Step 3 へ進む
2. **order/ が存在する場合**:
   - 既存のタスクフォルダ（YYYYMMDD-* や YYYYMMDD/ 形式）を検出
   - ユーザーに対応を確認（AskUserQuestion）:
     - `legacy/ に退避して新規セットアップ`（推奨）
     - `既存構造を維持してセットアップファイルのみ追加`
   - legacy 退避の場合: `mkdir -p ${ORDER}/legacy && mv ${ORDER}/existing-folders ${ORDER}/legacy/`

3. **既存 CLAUDE.md の検出**:
   - プロジェクトルートに CLAUDE.md が存在するか確認
   - 存在する場合はユーザーに戦略を確認（AskUserQuestion）:
     - `独立管理 + 相互参照`（推奨）: 両方の CLAUDE.md を維持し、ルートの order 関連セクションを order/ への参照に短縮。order/CLAUDE.md にルートへの参照を追加
     - `完全独立（相互参照なし）`: ルート CLAUDE.md がテンプレートや特殊用途（symlink 先等）の場合に選択。order/CLAUDE.md を独立して新規作成し、ルート CLAUDE.md は一切変更しない
     - `ルート CLAUDE.md はそのまま維持`: order/CLAUDE.md のみ新規作成
   - 独立管理の場合: ルート CLAUDE.md 内の order/タスク管理関連セクションを特定し、`order/CLAUDE.md および order/.claude/rules/ を参照` への 1 行参照に置換

### Step 3: ディレクトリ構造の作成

```bash
PROJECT_ROOT="<collected>"
ORDER="${PROJECT_ROOT}/order"
DATE=$(date +%Y%m%d)

# order ディレクトリ構造
mkdir -p ${ORDER}/.claude/rules
mkdir -p ${ORDER}/${DATE}/001-initial-setup/{.claude,phases/phase_001/{appendix,work}}
```

**注意**: `mkdir -p` の brace expansion は zsh/bash で動作するが、リテラル `{` が残る場合があるため、個別の `mkdir -p` コマンドに分割するのが安全:

```bash
mkdir -p ${ORDER}/${DATE}/001-initial-setup/.claude
mkdir -p ${ORDER}/${DATE}/001-initial-setup/phases/phase_001/appendix
mkdir -p ${ORDER}/${DATE}/001-initial-setup/phases/phase_001/work
```

### Step 4: settings.local.json セットアップ

**重要**: グローバル `~/.claude/settings.json` の丸コピーは行わない。プロジェクト固有の設定のみを記述する。

Claude Code の settings 階層:
- User (`~/.claude/settings.json`): グローバル deny ルール、hooks 等 → **重複させない**
- Local (`settings.local.json`): プロジェクト固有の allow、additionalDirectories → **ここに書く**
- 配列はスコープ間でマージされるため、deny ルールの重複は不要

生成する `${ORDER}/.claude/settings.local.json`:

```jsonc
{
  "permissions": {
    "additionalDirectories": []
  }
}
```

**最小限で開始する理由**:
- `allow`/`deny` ルールはグローバル設定（`~/.claude/settings.json`）とマージされるため、初期状態では不要
- 必要に応じてプロジェクト固有の allow/deny を後から追加
- `additionalDirectories` は空配列で初期化し、環境固有のパスは **setup.sh で注入** する

**環境固有パスの注入（setup.sh パターン）**:

プロジェクトの `setup.sh` に以下のステップを追加して、各環境で実行時に `additionalDirectories` を自動設定する:

```bash
ORDER_SETTINGS="${PROJECT_ROOT}/order/.claude/settings.local.json"
if [ -f "${ORDER_SETTINGS}" ]; then
    if command -v jq >/dev/null 2>&1; then
        jq --arg pr "${PROJECT_ROOT}" --arg cl "${HOME}/.claude" \
            '.permissions.additionalDirectories = [$pr, $cl]' \
            "${ORDER_SETTINGS}" > "${ORDER_SETTINGS}.tmp" \
            && mv "${ORDER_SETTINGS}.tmp" "${ORDER_SETTINGS}"
    else
        echo "[WARN] jq not found. Manually update ${ORDER_SETTINGS}"
    fi
fi
```

これにより JSON ファイルに絶対パスをハードコードせず、環境間のポータビリティを確保する。

**シンボリックリンク**:
```bash
ln -s ../../../.claude/settings.local.json ${ORDER}/${DATE}/001-initial-setup/.claude/settings.json
```

### Step 5: テンプレートからファイル生成

テンプレートディレクトリ: `${CLAUDE_SHARED:-$HOME/box/claude-shared}/templates/order-workflow/`

プレースホルダ置換:

| プレースホルダ | 値 |
|---------------|-----|
| `{{PROJECT_NAME}}` | ユーザー入力のプロジェクト名 |
| `{{PROJECT_ROOT}}` | ユーザー入力のプロジェクトルート |
| `{{PROJECT_DESCRIPTION}}` | ユーザー入力の概要 |

生成ファイル:
1. `${ORDER}/CLAUDE.md` ← `CLAUDE.md.template`（プレースホルダ置換）
2. `${ORDER}/.claude/rules/00-paths.md` ← `rules/00-paths.md.template`（プレースホルダ置換）
3. `${ORDER}/.claude/rules/01-structure.md` → **symlink** to `${TEMPLATE_DIR}/rules/01-structure.md`
4. `${ORDER}/.claude/rules/02-task-workflow.md` → **symlink** to `${TEMPLATE_DIR}/rules/02-task-workflow.md`
5. `${ORDER}/.claude/rules/03-tools.md` ← `rules/03-tools.md.template`（プレースホルダ置換）

**共有ルールの symlink 化**:

01-structure.md と 02-task-workflow.md はプロジェクト固有のカスタマイズがないため、テンプレートへの symlink とする。テンプレート更新時に全プロジェクトへ自動反映される。

```bash
TEMPLATE_DIR="${CLAUDE_SHARED:-$HOME/box/claude-shared}/templates/order-workflow"
RULES_DIR="${ORDER}/.claude/rules"

# 相対パスで symlink を作成（ln -sr は GNU coreutils 必須）
ln -sr "${TEMPLATE_DIR}/rules/01-structure.md" "${RULES_DIR}/01-structure.md"
ln -sr "${TEMPLATE_DIR}/rules/02-task-workflow.md" "${RULES_DIR}/02-task-workflow.md"
```

**注意**: `ln -sr`（相対 symlink 自動計算）が使えない環境（macOS 等）では、手動で相対パスを計算するか `python3 -c "import os; print(os.path.relpath('$TEMPLATE_DIR/rules', '$RULES_DIR'))"` で算出する。

**order/CLAUDE.md の追加調整**（Step 2 で既存 CLAUDE.md が検出された場合）:
- 「プロジェクト技術情報」セクションを追加し、ルート CLAUDE.md への参照を記載
- additionalDirectories により自動読み込みされる旨を明記

### Step 6: .gitignore 作成

```bash
cat > ${ORDER}/.gitignore << 'EOF'
.trash/
**/screenshots/
EOF
```

### Step 7: 初回タスクの作成

```
${ORDER}/${DATE}/001-initial-setup/
├── CLAUDE.md          # タスク固有コンテキスト（$TASK, $OUTPUT パス変数定義）
├── .claude/
│   └── settings.json  # → ../../../.claude/settings.local.json へのシンボリックリンク
├── plan.md            # 初回計画書
└── phases/
    └── phase_001/
        ├── order.md   # 初回指令
        ├── appendix/
        └── work/
```

タスク CLAUDE.md の内容:
```markdown
$TASK      = ${ORDER}/${DATE}/001-initial-setup
$OUTPUT    = $TASK/phases

## タスク概要

{{PROJECT_NAME}} プロジェクトに order ベースのタスク管理ワークフローを初期セットアップする。
```

**CLAUDE.md 運用ガイダンス**:
- order レベル CLAUDE.md は初期セットアップ後は安定させる（rules/skills 追加時のみ更新）
- タスクレベル CLAUDE.md も作成後は安定させる（`$OUTPUT` は `phases/` レベルで固定、フェーズ毎の更新不要）
- 個別フェーズのパスは作業中に `$OUTPUT/phase_NNN/` で参照

### Step 8: Git 戦略

ユーザーに確認（AskUserQuestion）:

1. **独立 git リポジトリとして初期化**:
   ```bash
   cd ${ORDER}
   git init
   git add -A
   git commit -m "Initial order workflow setup for {{PROJECT_NAME}}"
   ```
   親リポジトリの `.gitignore` に `order/` を追加（必要に応じて）

2. **既存リポジトリに含める**（推奨: 既に git リポジトリ内の場合）:
   ```bash
   cd ${PROJECT_ROOT}
   git add order/
   git commit -m "order: Initialize order workflow structure for {{PROJECT_NAME}}"
   ```

### Step 8.5: Codex MCP の確認（order ワークフローの前提）

order ワークフローの rules（`delegator/orchestration.md`・`policy.md`）と `/codex-delegation` skill は
`mcp__codex__codex` を前提にしている。**未接続だと「Codex不使用時は自己レビューで代替」に落ちるため、セットアップ時に確認する。**

```bash
# 接続確認（これだけ。未接続でも order セットアップ自体は完了できる）
claude mcp list 2>&1 | grep -i codex || echo "CODEX_NOT_REGISTERED"
```

**未登録だった場合**、ユーザーに以下を提示する（勝手に登録せず、確認を取る）:

```bash
# 前提: codex CLI と認証
which codex || npm install -g @openai/codex
codex login status || codex login

# 登録（user スコープ = 全プロジェクトで有効）
claude mcp add -s user codex -- codex -m gpt-5.2-codex mcp-server

# 検証（★ここまでやって初めて「登録できた」と言える）
claude mcp list   # codex: ... - ✔ Connected
```

> **★ 罠（2026-08-14 実地検証）**: MCP サーバの登録先は **`~/.claude.json` の top-level `mcpServers`**
> （`claude mcp add -s user` が書く場所）。**`~/.claude/settings.json` の `mcpServers` は読まれない** —
> `claude-delegator` プラグインの `/claude-delegator:setup` Step 3 はそちらを指示するが、
> **そのとおりに書いても `claude mcp list` に出ず、再起動しても接続されない**。必ず公式 CLI を使うこと。
>
> 反映には**セッション再起動が必要**（登録した当該セッションでは使えない）。
> 詳細は `${CLAUDE_SHARED}/rules/delegator/orchestration.md` の「MCP 登録」節。

未登録のまま進める場合は、Step 9 の報告に「**Codex 未接続 → レビューは敵対的 subagent + SC-3R で代替**」と明記する。

### Step 9: 結果報告

生成されたファイル一覧と次のステップをユーザーに提示:

1. **生成ファイル一覧**（ツリー形式で表示）
2. **次のステップ**:
   - 新しいタスクを開始するには `/task-init` を使用
   - プロジェクト固有の rules/skills を追加する場合は `${ORDER}/.claude/rules/` や `${ORDER}/.claude/skills/` に配置
   - `${ORDER}/CLAUDE.md` の skills テーブルを更新
3. **settings.local.json の追加カスタマイズ**:
   - プロジェクト固有の deny ルールが必要な場合は追加
   - additionalDirectories は後からでも変更可能
4. **Codex MCP の状態**（Step 8.5 の結果）:
   - `✔ Connected` / `未登録（登録コマンドを提示済み）` / `未登録のまま進行（レビューは敵対的 subagent で代替）` のいずれかを明記

## テンプレートのカスタマイズ

プロジェクト固有の rules/skills が必要な場合:
1. `${ORDER}/.claude/rules/` に追加ファイルを作成
2. `${ORDER}/.claude/skills/` にプロジェクト固有の skill を追加
3. `${ORDER}/CLAUDE.md` の skills テーブルを更新

## 設計判断の記録

このスキルは以下の実運用知見に基づいて設計されている:

| 知見 | 出典 | 反映箇所 |
|------|------|---------|
| settings.json はグローバルと重複させない | example project (SC-3R Round 3) | Step 4 |
| additionalDirectories の初期設定が必須 | example project (SC-3R Round 3) | Step 1, 4 |
| 既存 CLAUDE.md とのマージ戦略が必要 | example project (SC-3R Round 3) | Step 2 |
| .gitignore が必要 | example project (SC-3R Round 3) | Step 6 |
| settings 配列はスコープ間でマージされる | Claude Code 公式仕様 | Step 4 |
| CLAUDE.md は初期セットアップ後は安定させる | example project (long-term ops) | Step 7 |
| settings.local.json は最小限で開始、allow は初期不要 | claude-shared セットアップ | Step 4 |
| 環境依存パスは JSON にハードコードせず setup.sh で注入 | claude-shared ポータビリティ検証 | Step 4 |
| 共有ルール（01, 02）は symlink でテンプレート同期 | claude-shared (multi-project ops) | Step 5 |
| ルート CLAUDE.md がテンプレート等の場合「完全独立」が適切 | claude-shared セットアップ | Step 2 |
| テンプレートパスは `$CLAUDE_SHARED` 変数で環境非依存に | claude-shared ポータビリティ検証 | 前提条件, Step 5 |
| MCP registration path 詳細は各 provider の CLI 手順を参照 | user 実地検証 | Step 8.5 |

