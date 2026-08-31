# ast-grep CLI reference

Companion to SKILL.md. Subcommands, flag details, exit codes, output formats. (Python-focused.)

## Subcommand list

| Command | Use |
|---|---|
| `ast-grep scan` | Apply registered rules across the project (CI use) |
| `ast-grep test` | Run rule-tests/ (classification + snapshot) |
| `ast-grep run` | One-shot pattern search / rewrite without YAML |
| `ast-grep new` | Generate rule / test scaffolding |
| `ast-grep lsp` | Run as a Language Server (editor integration) |
| `ast-grep completions` | Output shell completion script |

## Main `scan` flags

```bash
ast-grep scan [PATH...]
```

| Flag | Meaning |
|---|---|
| `--rule <FILE>` | Specify a single rule file (no sgconfig needed) |
| `--config <FILE>` | Path to sgconfig.yml |
| `--filter <REGEX>` | Filter rule ids by regex |
| `--inline-rules <YAML>` | Inline YAML on the command line |
| `--update-all` | Apply fixes to every violation (destructive) |
| `--interactive` | Approve interactively, one at a time |
| `--format json` | JSON output (for CI integration) |
| `--report-style <pretty\|rich\|short>` | Console output format |
| `--error <severity>` | Exit non-zero at the specified severity or above. Bare `--error` includes hints |

### `--error` behavior

| Specification | Meaning |
|---|---|
| (default) | Exit non-zero if any finding has `error` severity |
| `--error` | Exit non-zero on any of `hint` / `warning` / `error` |
| `--error=warning` | Exit non-zero on `warning` or above |
| `--error=error` | Exit non-zero only on `error` (same as default) |

To fail CI on warnings, pass `--error`. For phased rollout, start with the default and tighten gradually.

### Exit codes

- `0` — no violations, or only violations below the threshold
- `1` — detected violations exceeded the `--error` threshold
- other — configuration / syntax error (e.g. exit 4)

## Main `test` flags

```bash
ast-grep test
```

| Flag | Meaning |
|---|---|
| `--skip-snapshot-tests` | Run classification tests only (ignore snapshot diffs). Use in CI |
| `-U` / `--update-all` | Generate / update snapshots |
| `--interactive` | Approve snapshot diffs one at a time |
| `--filter <REGEX>` | Filter test ids |
| `--config <FILE>` | Specify sgconfig.yml |

## `run` (one-shot rewrite)

```bash
ast-grep run \
  --pattern 'old_func($$$ARGS)' \
  --rewrite 'new_func($$$ARGS)' \
  --lang python \
  src/
```

| Flag | Meaning |
|---|---|
| `--pattern <CODE>` | Search pattern |
| `--rewrite <CODE>` | Rewrite template |
| `--lang <LANG>` | Target language (`python` for this skill) |
| `--update-all` | Apply everywhere without confirmation |
| `--interactive` | Confirm one at a time |
| `--debug-query <ast\|cst>` | Dump pattern's AST / CST (essential for kind name lookup) |

### Looking up kind names

```bash
# AST view (named nodes)
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=ast

# CST view (all nodes including anonymous tokens)
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=cst
```

Always run before writing a non-trivial pattern to verify the structure.

## `--format json` output structure

```json
[
  {
    "text": "print('debug')",
    "range": {
      "byteOffset": {"start": 100, "end": 114},
      "start": {"line": 5, "column": 2},
      "end": {"line": 5, "column": 16}
    },
    "file": "src/runner.py",
    "ruleId": "no-print-in-src",
    "severity": "warning",
    "message": "Use logger instead of print().",
    "note": "...",
    "labels": [...]
  },
  ...
]
```

Useful for PR comment generation, SARIF conversion, custom report tooling.

## sgconfig.yml and `--config`

When juggling multiple sgconfig files or running from outside the repo, pass `--config <PATH>` explicitly. The default search walks parent directories from the current dir looking for `sgconfig.yml`.

## CI integration notes

- Pin `ast-grep` via `uv tool install ast-grep-cli` or `pip install ast-grep-cli` so CI and local match
- Avoid global installs in CI (version drift)
- Save `--format json` output, then format into PR comments in a downstream step
- Skip snapshot tests in CI (developer responsibility — see `references/testing.md`)
