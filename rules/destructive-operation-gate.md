# Destructive Operation Gate

破壊的操作 (destructive ops) には plan-level の事前承認だけでは不十分。実行直前に live-gate を通すこと。

Source: BG4:127-130 (REVERT-RETRACT saga; 「慎重」 + 事前承認でも solo `git reset --hard` 不可)、BG10 INV-G UR-4 (15+ revert events / 13pp regression)、Codex R3 H6 validated。

---

## Rule statement

以下の操作は、たとえ plan / order / 直前会話で承認を得ていたとしても、**実行直前に separate live confirmation** を必須とする。verbal 「慎重」「OK」「やって」だけで実行してはならない。承認スコープは **per-operation** であり、暗黙の transitive 拡張は禁止。

## Trigger detection (concrete list)

以下のいずれかを実行する前に gate を通す:

- **Git destructive**: `git push --force` / `git push -f`, `git reset --hard`, `git rebase` (interactive 含む) , `git checkout -- <path>` / `git restore .`, `git clean -fd`, `git branch -D`, `git stash drop` / `git stash clear`
- **File system destructive**: `rm -rf`, `rm -r`, `find ... -delete`, `truncate`, シンボリックリンク先実体への書き込み破壊
- **Database destructive**: `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE FROM ... WHERE` (no WHERE 含む)
- **Process destructive**: `kill -9 <pid>`, `pkill`, `killall`, container/pod の `kubectl delete` / `docker rm -f`
- **Outbound communication**: Discord / Slack / email / GitHub PR comment 等の外部送信 (取消不可性が高い)
- **Repository state**: branch deletion, tag deletion, release artifact 削除

## Gate procedure

1. **Pre-confirm**: 実行コマンドを **逐語表示** + 影響範囲 (失う commit / file / row) を 1-2 行で明記
2. **Verify scope**: `git status` / `ls` 等で副作用 surface を確認、影響対象を表示
3. **Announce**: 「以下を実行します: <command>。失う物: <items>。実行してよいですか?」と user に問う
4. **Wait for explicit go-ahead**: per-operation の承認 (前回の承認は流用しない)
5. **Execute**: 承認後に実行
6. **Verify-after**: 実行後 `git log` / `git status` 等で結果確認、想定通りでなければ即報告

## Exception cases

- **User pre-approval scope は明示的範囲のみ**: 「revert したい」承認は当該 commit のみ。連続する push / reset には毎回確認
- **Tier 1 read-only** (`git status`, `git diff`, `git log`, `ls`) は対象外
- **Sandboxed test repos** (例: `.trash/`, 一時 worktree) で user が事前に「freely operate」と明示した場合のみ免除
- **Hooks-enforced auto-revert** (CI rollback 等) は自動化済みのため対象外。但しその hook 自体の追加/変更は本ルール対象

## Anti-patterns

- 「慎重に」「丁寧に」を verbal 承認と解釈して実行 → BG4 LB-3 root cause
- 「先ほど OK と言われた」を transitive 適用して別 commit / 別 file に拡張
- `git reset --hard` を `git status` で diff 確認せず実行 → INV-7 (partial commit + restore plan dump) 違反
- 取消不可外部送信 (Discord / PR comment) を gate なしで送信

## Cross-link

- `core/00-safety.md` Tier 3 NEVER list の拡張 (本ルールは Tier 3 の operational gate を提供)
- `core/02-workflow.md` 「既存コードの無断削除禁止」 (本ルールは削除以外の destructive op に general 化)
- `delegator/orchestration.md` (subagent / Codex 経由 destructive op も同 gate を要求)
- MEMORY `feedback_inv7_partial_commit` (partial commit + restore plan)
- MEMORY `feedback_subagent_return_git_diff_verify` (subagent 「reverted/failed」 報告は git diff verify 後 accept)
