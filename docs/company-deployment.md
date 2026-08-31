# Company Deployment Guide — claude-shared

会社環境 (WSL2 想定) に claude-shared を fail-closed whitelist で導入するための手順書。

---

## 1. Overview

**方針**: fail-closed whitelist。 setup.sh を `--company` フラグで起動すると、 個人依存の skill / hook / webhook / 外部 fetch が全て skip され、 事前 review された **37 skills + 9 rules** のみが `~/.claude/` に link される。 outbound integrations (Discord webhook / OpenRouter / Codex MCP / 個人 GitHub push) は **ゼロ**。

**想定環境**:
- **OS**: WSL2 (Ubuntu 22.04 LTS or 24.04 LTS)
- **配置場所**: Linux fs 側 (`~/box/claude-shared`)。 **`/mnt/c/` 上は禁止** (NTFS symlink 化け + 0777 permission)
- **Claude Code**: 会社側で使用許可済
- **Codex**: 会社側 policy 次第。 `--company` では default off。 使用可否は Section 6 の flow で判定

**scope 外**:
- Windows 側 mise / winget 経由 install (WSL 側と混在させない)
- `agent-browser` (npm 経由 install なので claude-shared 管理外)

---

## 2. Pre-flight Checks

setup.sh 実行前に以下 4 点を確認:

### 2.1 git line ending
```bash
git config --global core.autocrlf input
```
WSL 内で Windows 側 git 経由 clone すると CRLF 混入して shell script が壊れる。 `input` で LF 保持。

### 2.2 配置場所
```bash
pwd  # → /home/<user>/box/... であること
# NG: /mnt/c/... 配下は絶対禁止
```
Linux fs 側配置で POSIX symlink がネイティブ動作。 Windows fs 上だと symlink 管理者権限要求 + permission 0777 化。

### 2.3 Codex 使用予定なら AppArmor 対応
```bash
cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns  # 1 なら要対応
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0  # 一時解除
echo "kernel.apparmor_restrict_unprivileged_userns=0" | \
  sudo tee /etc/sysctl.d/60-apparmor-namespace.conf  # 永続化
```
会社 policy で `sudo` 不可なら Codex delegation は諦める。 `--company` で default off なので影響なし。

### 2.4 Discord webhook 無効化確認
`--company` mode は `hooks/discord_notify.env` が非空だと **exit 3 で block** する。 個人環境から clone してきたなら実行前に:
```bash
rm -f ~/box/claude-shared/hooks/discord_notify.env
```

---

## 3. Setup 手順 (8 steps)

### Step 1: WSL2 distro 準備
Ubuntu 22.04 LTS or 24.04 LTS を Microsoft Store から install。 v2 確認:
```bash
wsl --set-default-version 2   # (Windows 側 PowerShell)
```

### Step 2: hostname 短命名 (任意、 sync-env 使用時のみ)
```bash
sudo hostnamectl set-hostname wsl-company
```
sync-env の branch 命名 `pc-$(hostname)` を短縮 (会社 policy が許すなら)。 `--company` では sync-env 自体が除外なので skip 可。

### Step 3: 基本ツール install
```bash
sudo apt update && sudo apt install -y \
  git curl jq python3 python3-pip build-essential shellcheck
```

### Step 4: git 設定
```bash
git config --global core.autocrlf input
git config --global user.email "you@company.example"
git config --global user.name "Your Name"
```

### Step 5: repo clone (Linux fs 側)
```bash
mkdir -p ~/box && cd ~/box
git clone <company-fork-or-tarball-url> claude-shared
cd claude-shared
```
**注意**: 単純 clone は `.git/` + tracked `order/` (~166 files) + `reviewing/` (~89 files) を伴走。 会社共有拡大時は Section 5 の Arc B/C 経路を検討。

### Step 6: claude CLI install
会社 policy に従い install。 例:
```bash
curl -fsSL https://claude.ai/install.sh | bash
```
初回 `claude` 実行で `~/.claude/` 作成 (session 開始 → `/exit`)。

### Step 7: setup.sh --company 実行
```bash
cd ~/box/claude-shared && ./setup.sh --company
```
期待出力: `[COMPANY][DONE] linked=37 skipped=23 blocked=0 outbound_integrations=0`。 exit code 0 で成功。

### Step 8: 動作確認
```bash
ls ~/.claude/skills/ | wc -l   # → 25
ls ~/.claude/rules/             # → 9 rule files
claude                          # session 起動、 whitelist skill 一覧確認
```

---

## 4. `--company` Flag 仕様

### Exit codes

| Exit | 意味 | 対処 |
|---:|---|---|
| 0 | 成功 | Section 3 Step 8 で確認 |
| 2 | unknown argument | `--company` / `--help` / (default) のみ受付 |
| 3 | `hooks/discord_notify.env` 非空 | rotate & rm してから再実行 |
| 4 | whitelist 外の残存 skill link | `~/.claude/skills/` を手動確認、 除去 |
| 5 | managed_unlink / company_link target mismatch (foreign file) | `~/.claude/` の real file (symlink ではない実体) を手動確認 |

### 完了時 report
```
[COMPANY][MODE] fail-closed whitelist; interactive integrations disabled
[COMPANY][LINK] rule/core/00-safety.md
[COMPANY][LINK] skill/self-critique
... (省略) ...
[COMPANY][SKIP] skill/koebox: known personal/external integration
[COMPANY][SKIP] step/discord: disabled in company mode
[COMPANY][DONE] linked=37 skipped=23 blocked=0 outbound_integrations=0
[COMPANY][INFO] review company artifact excludes .git history before distribution
```

### `--help`
```bash
./setup.sh --help
```
Usage 出力のみ、 副作用なし。

---

## 5. Distribution (Arc C — 履歴分離 export tool 実装済)

Personal repo (`ocl2go/claude-shared`) は **private** で個人 identifier + reviewing/ PDF + 履歴を含むため、 **会社 PC からの直接 clone は不可** (private repo auth + 個人情報 leak 両方の問題)。 代替として **`scripts/export-company-artifact.sh`** で会社 safe subset を **履歴分離した artifact** に出力する。

### 5.1 export モード一覧

| `--target=` | 出力 | 用途 |
|---|---|---|
| `stage` | ディレクトリに bare copy | ローカル確認、 手動 push |
| `tarball` (default) | `.tar.gz` archive | 会社 approved channel (Slack / Teams / OneDrive / email) 経由持ち込み |
| `git-init` | fresh git repo (履歴なし) 単一 commit | 手動で remote 設定して push |
| `gh-create` | fresh repo + `gh repo create` + push | 別 GitHub アカウントに直接 public/private repo 作成 |
| `push` | fresh repo + 既存 remote に push | 空の remote が既にある場合 |

### 5.2 典型 workflow: 別 GitHub アカウントに public repo 作成

会社 PC からアクセスするために、 **職探しでは使わない別 GitHub アカウント** を用意して public repo で distribution。 個人メイン account との traceability を断つため:

- **`--as=<username>`** を必ず指定 (commit author が global git config の identity ではなく `<username>@users.noreply.github.com` になる)
- **PAT-in-URL** で push (SSH 鍵 / gh CLI の ambient credential 経由の紐付き回避)
- `commit.gpgsign=false` を強制 (個人 GPG 鍵での署名を防ぐ)

```bash
# 個人 PC 側 (別アカウントに gh CLI で login 済前提)
gh auth login  # ← 別アカウントに switch
cd ~/box/claude-shared

# 初回: fresh public repo 作成 + push (別アカウント名義)
./scripts/export-company-artifact.sh --target=gh-create \
  --repo=<new-account>/claude-code-config --public \
  --as=<new-account>

# 出力例: https://github.com/<new-account>/claude-code-config
```

会社 PC (WSL2):
```bash
git config --global core.autocrlf input
cd ~/box && git clone https://github.com/<new-account>/claude-code-config claude-shared
cd claude-shared
./setup.sh --company
```

### 5.3 更新 workflow (fresh push で mirror 更新)

Personal repo に更新が入ったら:

```bash
cd ~/box/claude-shared
./scripts/export-company-artifact.sh --target=push \
  --remote="https://<new-account>@github.com/<new-account>/<repo>.git" \
  --pat-file="$HOME/.config/claude-shared/<new-account>.pat" \
  --as=<new-account> --force
```

- `--pat-file=` で PAT を安全な保存場所 (chmod 600) から読取り、 URL に自動注入 (`https://<user>@...` → `https://<user>:<PAT>@...`)。 world/group-readable の場合 WARN 出力
- `--as=` で commit 名義を新アカウント化
- `--force` で `git push --force` (mirror workflow の意図的 overwrite)
- Push 後 script が `.git/config` から credentials を strip
- GPG 署名は無効化される (個人 GPG 鍵で署名されると traceability 発生)

### 5.3.1 PAT 保管場所 (推奨)

`~/.config/claude-shared/<username>.pat` に chmod 600 で保管。 例:

```bash
mkdir -p ~/.config/claude-shared
chmod 700 ~/.config/claude-shared
printf '%s' "ghp_..." > ~/.config/claude-shared/hheromas.pat
chmod 600 ~/.config/claude-shared/hheromas.pat
```

`/tmp/` は再起動で消えるため PAT 保管に不向き。 XDG 慣例 `~/.config/` 直下に。

会社 PC 側で更新取り込み:
```bash
cd ~/box/claude-shared
git fetch origin && git reset --hard origin/main
./setup.sh --company
```

### 5.4 tarball 経路 (repo 経路 NG の場合)

```bash
# 個人 PC 側
./scripts/export-company-artifact.sh --target=tarball --out=/tmp/claude-shared-company.tar.gz --force
# → Slack file / OneDrive / email 添付で会社 PC へ

# 会社 PC 側
mkdir -p ~/box/claude-shared && cd ~/box/claude-shared
tar xzf /path/to/claude-shared-company.tar.gz
./setup.sh --company
```

### 5.5 What's excluded from artifact (leak check)

`scripts/export-company-artifact.sh` は以下を **artifact に含めない**:
- `.git/` (履歴分離)
- `hooks/` (Discord webhook)
- `scripts/` (personal helpers、 export script 自身も含めない)
- `order/`, `reviewing/`, `external-repos/`, `.trash/`, `.ruff_cache/`
- Personal templates (`mcp.json.template`, `settings.json.template` 通常版)
- `external-skills.txt`, `external-repos.txt`, `.mcp.json`

含まれるのは: setup.sh / LICENSE / THIRD_PARTY_NOTICES / CLAUDE.md / 37 skills / 9 rules / templates/settings.json.company.template / templates/order-workflow/ / docs/company-deployment.md / 自動生成 README.md — 計 ~50 files。

### 5.6 dry-run 確認

初回運用前に必ず:
```bash
./scripts/export-company-artifact.sh --dry-run
```
で含める files list を確認。 37 skills + 9 rules + root files が正しく enumerate されることを check。

---

## 6. Codex 使用可否判定 Flow

```
[Q1] 会社側で Codex CLI + OpenAI 契約が許可されているか?
    │
    ├─ No → --company default off で使わない (推奨・終了)
    │
    └─ Yes → [Q2]
              │
    [Q2] WSL2 AppArmor 対応可能か? (sudo sysctl 実行権あり)
    │
    ├─ No → --company default off で使わない (推奨・終了)
    │
    └─ Yes → [Q3]
              │
    [Q3] 未公開情報 (会社 IP / 未発表資料) を Codex に送信可能か?
    │
    ├─ No → --company default off (安全側)
    │
    └─ Yes → codex-delegation 手動追加検討 (Phase 6 拡張、
             要 SC-3R 再走行 + 会社 IT 承認)
```

**推奨**: 3 つ全て Yes でない限り Codex は無効化 (`--company` default off が正解)。 default off なので追加設定不要。

---

## 7. Undo / Uninstall

### `--company` 適用を personal setup に戻す
```bash
cd ~/box/claude-shared
./setup.sh   # (personal mode = 引数なし)
```
再度全 skill が link され、 hooks / scripts / commands / rules directory symlink が復活。 個人 setup と同状態に戻る。

### 完全 uninstall
```bash
rm -rf ~/.claude/skills ~/.claude/rules
rm -f ~/.claude/CLAUDE.md ~/.claude/hooks ~/.claude/scripts ~/.claude/commands
```
`~/.claude/settings.json` は claude CLI が管理する user config なので通常残す。 完全リセットしたい場合のみ削除。

### repo 自体削除
```bash
rm -rf ~/box/claude-shared
```
再度使う場合は Section 3 Step 5 から再実行。

---

## Appendix: 依存 audit 出典

本 guide の根拠:
- WSL2 互換性: `order/20260824/001-company-deployment-audit/phases/phase_001/work/P01_STEP004_wsl_compat.md`
- Risk matrix + exclusion list: `phases/phase_002/work/P02_STEP005_risk_matrix.md`
- setup.sh --company 設計: `phases/phase_003/work/P03_STEP006_company_flag_design.md`
- Codex hostile review: `phases/phase_001/work/P01_STEP002_codex_hostile.md`

**版**: 2026-08-24 初版 (setup.sh --company 導入 commit と同時 land 予定)。
