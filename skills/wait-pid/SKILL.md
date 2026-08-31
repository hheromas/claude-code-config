---
name: wait-pid
description: Trigger when user asks to "wait for process", "monitor PID", "プロセス待機". Monitors process completion and notifies. Supports both Linux/macOS/WSL (bash + tail) and Windows PowerShell / cmd (Wait-Process).
argument-hint: "[PID] [message]"
allowed-tools: Bash(*)
---

# プロセス終了検知

PID $1 の終了を監視し、完了時に通知する。 実行環境に応じて Linux/WSL (bash) と Windows (PowerShell) の 2 パターン。

## 環境自動判定

- `uname` が `Linux` / `Darwin` を返す → **Linux/macOS/WSL 版** を使う
- `PowerShell` / `pwsh` が使える env (Windows native、 or WSL 内で相互運用) → **PowerShell 版** も使える
- どちらでも動く場合、 tool 呼び出しは `Bash(*)` の方が Claude Code の task notification と統合しやすいため Bash 版を優先

## Linux / macOS / WSL 版 (bash)

1. `ps -p $1` で PID の存在を確認。 存在しなければ 「既に終了」 と報告して終了。
2. 以下を実行:

```
Bash(
  command: "tail --pid=$1 -f /dev/null && echo '$2'",
  run_in_background: true,
  description: "Wait for PID $1 to finish"
)
```

`$2` が未指定なら `"Process $1 finished"` をデフォルト。

3. PID 終了時に task notification が届く。 user に完了報告。

## Windows PowerShell / Command Prompt 版

Windows native (WSL 外) or PowerShell 経由で監視する場合:

### PowerShell (推奨、 Windows 5.0 以降)

```
Bash(
  command: "powershell -NoProfile -Command \"Wait-Process -Id $1; Write-Output '$2'\"",
  run_in_background: true,
  description: "PS: Wait for PID $1"
)
```

- `Wait-Process -Id <PID>`: 指定 PID の終了を待機 (blocking)。 存在しない PID なら即エラー
- `-NoProfile` で $PROFILE の読み込み skip (起動高速化 + 環境変数干渉回避)
- 出力 `$2` は Claude Code の notification message として拾われる

### 事前存在 check (省略可)

```powershell
Get-Process -Id $1 -ErrorAction SilentlyContinue
```

- exit code 0 = 存在、 非 0 = 既に終了

### Command Prompt (cmd.exe) 版 — 補助 (推奨は PowerShell)

`cmd` には native な wait-by-PID がないため、 PowerShell の `Wait-Process` を `powershell -Command` 経由で呼ぶのが簡潔:

```
Bash(
  command: "cmd /c \"powershell -NoProfile -Command \"Wait-Process -Id $1\" && echo $2\"",
  run_in_background: true,
  description: "cmd->PS: Wait for PID $1"
)
```

## 複数 PID

各 PID に対して個別に上記を実行。 各完了は独立した notification として届く。 Bash 版 / PowerShell 版を mix しても OK (Claude Code の Bash tool 経由で running_in_background される限り notification は届く)。

## 禁止パターン

```bash
# NG — Claude Code が検知できない (& でバックグラウンド化しても Bash tool 経由の task registration にならない)
tail --pid=$1 -f /dev/null &
```

```powershell
# NG — 同上、 Start-Job や & はダメ
Start-Job -ScriptBlock { Wait-Process -Id $1 }
```

**必ず Bash tool の `run_in_background: true` を使う** (bash / powershell どちらのコマンドでも)。

## 注意

- PID が既に終了 → `tail --pid` / `Wait-Process` は即座に終了 (正常、 error 扱いでない)
- セッション切断 → 監視プロセスは残るが notification は届かない
- 長時間ジョブでは 会社 chat (Slack/Teams webhook) との併用推奨
