---
name: sync-env-pull
description: Trigger when user asks to "sync env pull", "会社 sync", "mirror 更新", "会社 pull", "設定を最新に", "会社の claude-shared を最新に". Pull-only sync from the company distribution mirror (hheromas/claude-code-config). Never pushes. Local changes handled interactively via AskUserQuestion.
argument-hint: ""
allowed-tools: Bash(git *), Bash(cd *), Bash(yes *), Bash(./setup.sh*), Bash(bash *), Read, Grep, AskUserQuestion
---

# sync-env-pull — company mirror pull-only sync

会社デプロイの mirror (hheromas/claude-code-config) を latest に追随する pull-only 版 sync-env。 personal remote への push は行わない (mirror は read-only consumer)。 local に差分がある場合は AskUserQuestion で対話的に決定。

## 対象環境

- 会社 PC (mirror clone)
- 想定 clone 先: `~/box/claude-shared`
- 別 path なら `CLAUDE_SHARED` env で指定

## 変数

```bash
CLAUDE_SHARED="${CLAUDE_SHARED:-$HOME/box/claude-shared}"
```

## 事前チェック

```bash
cd "$CLAUDE_SHARED" || { echo "ERROR: $CLAUDE_SHARED not found"; exit 1; }
git remote get-url origin >/dev/null 2>&1 || { echo "ERROR: no origin remote"; exit 1; }
```

Personal repo との誤用防止: origin URL が `hheromas/` を含むか確認 (もし個人 remote だったら `sync-env` skill を使うべき旨案内)。

## Workflow

### Step 1: fetch + 3 axis 状態判定

```bash
cd "$CLAUDE_SHARED"
git fetch origin
```

以下 3 軸を評価:

| 変数 | 意味 | コマンド |
|---|---|---|
| `DIRTY` | 未コミット変更あり | `[ -n "$(git status --short)" ]` |
| `LOCAL_COMMITS` | main に対して未 push commit | `git log --oneline origin/main..HEAD \| wc -l` |
| `REMOTE_AHEAD` | origin/main が先行 | `git log --oneline HEAD..origin/main \| wc -l` |

### Step 2: 分岐マトリクス

| Dirty | Local | Remote | 対応 |
|:---:|:---:|:---:|---|
| no | 0 | 0 | 完全同期、 Step 5 report のみ |
| no | 0 | >0 | **pull only** (Step 3 → 4) |
| yes | * | * | AskUserQuestion で **dirty tree 対応** (下記 A) |
| no | >0 | * | AskUserQuestion で **local commits 対応** (下記 B) |

Dirty + local commits の複合状態は user に別々に確認 (「まず dirty を〜、 その後 local commits を〜」)。

### Step 3: force-mirror pull

Mirror repo は personal side からの `git push --force` で history 書き換わるため、 通常 `git pull` / `git merge` は非 fast-forward で reject される。 hard reset:

```bash
git reset --hard origin/main
```

これで local main が origin/main に完全一致。

### Step 4: setup.sh 再実行

skills/ に変更 (whitelist 拡張、 skill body 更新等) がある場合:

```bash
cd "$CLAUDE_SHARED" && yes n | ./setup.sh 2>&1 | { grep -vF '[OK]' || true; }
```

auto-detect が働くので `--company` フラグ不要。

### Step 5: 結果報告

```
## sync-env-pull 完了
- 取り込み: N コミット
- setup.sh: 再実行済み / 不要
- 状態: 最新 = <short sha>
```

pull した commit list を head -5 で参考表示。

## 対話 pattern (AskUserQuestion 例)

### A. Dirty tree あり

未コミット変更を列挙 (max 10 files) して:

> 未コミット変更あり:
> M skills/<name>/SKILL.md
> M setup.sh
> どうしますか?
> 1. **変更を discard して pull** (推奨: 会社 mirror は upstream 尊重)
> 2. **stash して pull → 後で手動 pop**
> 3. **sync 中止** (変更内容確認後に再実行)

選択後:
- 1 → `git checkout -- .` → Step 3
- 2 → `git stash push -u -m "sync-env-pull auto-stash $(date +%Y%m%dT%H%M%S)"` → Step 3 → 完了時に stash id を報告
- 3 → abort

### B. Local commits あり

Personal-side で試験的に commit していた場合 (稀):

> local 未 push commit N 件:
> a1b2c3d ...
> どうしますか?
> 1. **別 branch に退避して main を reset** (branch 名 `local-backup-YYYYMMDD`)
> 2. **discard** (mirror workflow 尊重)
> 3. **sync 中止**

選択後:
- 1 → `git branch local-backup-$(date +%Y%m%d-%H%M%S) HEAD` → `git reset --hard origin/main`
- 2 → `git reset --hard origin/main`
- 3 → abort

## Personal repo との区別

このスキルは **mirror repo (hheromas/claude-code-config) からの pull 専用**。 個人 repo (ocl2go/claude-shared) の 双方向 sync には `sync-env` skill を使う (personal setup では本 skill は install されない、 PERSONAL_SKIP_SKILLS で除外)。

もし origin URL が `hheromas/` を含まない場合、 user に「これは personal repo ですが、 `sync-env` skill の方が適切かもしれません」 と確認する。

## 禁止パターン

- **`git push` 実行禁止**。 skill 内で `git push` を叩かない (mirror は read-only consumer 用途)
- **無確認 destructive op 禁止**。 `git reset --hard` / `git checkout -- .` / `git stash drop` 前に必ず AskUserQuestion
- **secret 混入 hint あるファイルの自動 discard 禁止**。 例: `~/.claude/.sync-env-actions.log` に近い場所 or `.env` に近い変更 → 特に注意して user 確認

## 注意事項

- Mirror repo の commit は毎回 fresh git init による新 SHA なので、 `git log` を辿った履歴は「initial commit のみ」 の連続に見える (正常挙動)
- setup.sh 再実行後、 `~/.claude/settings.json` の diff warning が出たら backup path を報告 (中身は表示しない)
- 長時間 setup.sh が刺さる場合は wait-pid で monitor 可
