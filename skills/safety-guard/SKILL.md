---
name: safety-guard
description: Trigger when user wants to enable safety guards for autonomous execution. Use when "careful", "freeze", "safe mode", "慎重モード", "ディレクトリ固定" is requested.
argument-hint: "[careful|freeze <directory>]"
allowed-tools: Read, Bash, Write, Edit, AskUserQuestion
---

# Safety Guard

Provides `/careful` and `/freeze` modes via On-Demand hooks to prevent destructive operations during autonomous execution.

## Modes

### `/careful` -- Block Destructive Commands

Blocks commands that could cause irreversible damage:

| Category | Blocked Patterns |
|----------|-----------------|
| File deletion | `rm -rf`, `rm -r`, `shred` |
| Git destructive | `git push --force`, `git push -f`, `git reset --hard`, `git clean -f`, `git checkout -- .` |
| Database destructive | `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE FROM` (without WHERE) |
| System | `chmod -R 777`, `chown -R`, `mkfs`, `dd if=` |
| Docker | `docker system prune`, `docker rm -f` |

### `/freeze <directory>` -- Lock Edits to a Directory

Blocks any file edits (Edit, Write, Bash write operations) outside the specified directory:

- Only files under `<directory>` (resolved to absolute path) can be modified.
- Read operations are unrestricted everywhere.
- Git operations (commit, push) are allowed as they do not modify working tree files.

## Procedure

1. **Parse arguments**: `$ARGUMENTS` determines the mode.
   - `careful` or empty: activate careful mode.
   - `freeze <dir>`: activate freeze mode for the specified directory.
2. **Install hook**: Write the appropriate hook script to `.claude/hooks/`.
3. **Confirm activation**: Print the active mode and what is blocked.
4. **Deactivation**: User says "disable guard", "ガード解除", or "unfreeze" to remove the hook.

## Hook Implementation

### careful mode hook

```bash
#!/usr/bin/env bash
# .claude/hooks/careful-guard.sh
# PreToolExecution hook for Bash tool

COMMAND="$1"
DANGEROUS_PATTERNS=(
  'rm -rf' 'rm -r ' 'shred '
  'git push --force' 'git push -f' 'git reset --hard'
  'git clean -f' 'git checkout -- .'
  'DROP TABLE' 'DROP DATABASE' 'TRUNCATE'
  'chmod -R 777' 'mkfs ' 'dd if='
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    echo "BLOCKED by /careful: command contains '$pattern'"
    exit 1
  fi
done
exit 0
```

### freeze mode hook

```bash
#!/usr/bin/env bash
# .claude/hooks/freeze-guard.sh
# PreToolExecution hook for Edit, Write tools

ALLOWED_DIR="$FREEZE_DIR"  # Set during activation
TARGET_FILE="$1"
REAL_TARGET=$(realpath "$TARGET_FILE" 2>/dev/null || echo "$TARGET_FILE")
REAL_ALLOWED=$(realpath "$ALLOWED_DIR" 2>/dev/null || echo "$ALLOWED_DIR")

if [[ "$REAL_TARGET" != "$REAL_ALLOWED"* ]]; then
  echo "BLOCKED by /freeze: edit outside $ALLOWED_DIR"
  exit 1
fi
exit 0
```

## Gotchas

- **Hook registration**: Hooks must be registered in `.claude/settings.json` under the `hooks` key. This skill handles registration automatically.
- **Not a sandbox**: This is advisory protection, not a security boundary. A determined user can bypass it by editing the hook file.
- **Nested guards**: Only one mode can be active at a time. Activating a new mode replaces the previous one.
- **Performance**: Hook scripts run on every tool invocation. Keep them fast (no network calls, no heavy file I/O).
- **Careful mode does not block all rm**: `rm single-file.txt` (without -rf/-r) is allowed. Only recursive/forced deletion is blocked.
