# タスク構造・フォルダ規約

order/ 配下のタスクフォルダ構造標準。

## ディレクトリ構造

```
order/                 # 既存リポジトリに含める
├── CLAUDE.md
├── .claude/
│   └── settings.local.json  # プロジェクト設定（マスター、シンボリックリンク元）
└── YYYYMMDD/          # 日付別フォルダ
    └── NNN-taskname/   # 作業フォルダ（0埋め3桁、taskname必須）
        ├── CLAUDE.md   # タスク固有コンテキスト
        └── .claude/    # ★ CLAUDE.md と同階層に配置
            └── settings.json -> ../../../.claude/settings.local.json
```

## タスクフォルダ命名規則

形式: `NNN-taskname`（0埋め3桁 + ハイフン + タスク名。例: `001-bugfix/`, `003-feature-auth/`）

### 並列作業（orch/track パターン）
| プレフィックス | 役割 | 例 |
|---------------|------|-----|
| `orch` | 全体管理・オーケストレーター | `001-orch-release/` |
| `track-{letter}` | 並列トラック（A, B, C...） | `002-track-a-api/` |

- `orch` の plan.md に Track 構成・依存関係・handoff ポイントを記述
- 各 Track は独立して進行。同期が必要な場合は orch が管理
- **Track 混在禁止**: 1セッションで複数 Track を混在させない。切替時はコミットしてから

## タスクフォルダ標準構造

```
NNN-taskname/
├── plan.md           # 全体計画、Phase構成、成功基準
├── CLAUDE.md         # タスク固有コンテキスト・パス変数（必須）
├── .claude/
│   └── settings.json -> ../../../.claude/settings.local.json
└── phases/
    └── phase_NNN/
        ├── order.md      # Phaseの指令（入力、作成後は不可変）
        ├── report.md     # Phaseの最終レポート（出力）
        ├── appendix/     # 詳細調査、spec等
        └── work/         # 中間メモ
```

全ファイル/フォルダは必須。1フェーズのみでも phases/ 構造を使用する。

**order.md の不可変性**: 作成後に変更しない。乖離時は report.md に差異と理由を記録。

**plan.md の権威性**: タスク全体の SSOT。Phase ステータスは plan.md を厳守し、スキップや順序変更しない。

## 詳細度の使い分け
| 配置先 | 内容 | 行数目安 |
|--------|------|:--------:|
| plan.md / order.md | 純粋な要件（ゴール、成功基準） | 50行以下 |
| report.md | 純粋な結果（サマリー、結論） | **100行以下** |
| appendix/ | 詳細成果物（spec、設計書、調査） | - |
| work/ | 中間メモ | - |

**超過時**: 詳細を appendix/ に分離し、report.md から参照する。

## 命名規則
- **appendix/**: `step{N}_{内容}.md` または `{内容}.md`
- **work/**: `P{phase}_STEP{step}_{内容}.md`（例: `P47_STEP12_analysis.md`）

## シンボリックリンクパターン

`.claude/` は CLAUDE.md と同階層（タスクフォルダ直下）に配置。settings.local.json はシンボリックリンクでマスターを参照。

```bash
# 新規タスクフォルダ作成時
mkdir -p $ORDER/YYYYMMDD/NNN-taskname/{.claude,phases/phase_001/{appendix,work}}
ln -s ../../../.claude/settings.local.json $ORDER/YYYYMMDD/NNN-taskname/.claude/settings.json
```

## ファイル操作ルール
- **mv のみ使用**: cp 禁止（Git 履歴追跡のため）
- **削除禁止**: rm は使わず `.trash/` に移動（.gitignore で除外済み）

## ファイル分類時の注意

プロジェクト固有の概念名・用語を含むファイルは、カテゴリ名に関わらずプロジェクト配下に配置。迷ったらプロジェクト配下。

## タスク固有 CLAUDE.md（必須）

タスクフォルダには **必ず CLAUDE.md を作成**し、冒頭にパス変数定義を設ける:

```markdown
$TASK      = $ORDER/YYYYMMDD/NNN-taskname
$OUTPUT    = $TASK/phases
```

- タスク開始時に作成。絶対パスを使用（`~` 禁止）
- `$OUTPUT` はフェーズ毎に変更しない（`phases/` レベルで固定）
- 個別フェーズのパスは作業中に `$OUTPUT/phase_NNN/` で参照

## 出力言語ルール

- **report.md, summary 等の出力ファイル**: 日本語で記述
- **コード内コメント**: 英語可
- **コミットメッセージ**: 英語

→ テンプレート・作成コマンドは /task-init を参照
