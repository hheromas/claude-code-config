---
name: ast-grep-practice
description: Python AST-based linting via ast-grep — pyright/ruff で書けない構造的 rule 用 (interface rename, deprecated API rewrite, layered constraint check 等)
---

> Source: mizchi/skills ast-grep-practice (https://github.com/mizchi/skills/tree/main/ast-grep-practice)
> Adapted: 2026-05-08 by claude-shared (commit 847e72f)
> License: MIT (mizchi 上流に従う; upstream README 既定 MIT)

# ast-grep Practice (Python)

Complement Python lint tools (ruff, pyright) with ast-grep for structural patterns they cannot express. Use ast-grep for interface renames, deprecated API rewrites, and layered architectural constraints. Always prefer reproducible static rules over natural-language prompts.

## When to reach for ast-grep

| Case | Tool |
|------|------|
| unused import, naming, formatting | ruff / ruff format |
| type error, unreachable code | pyright |
| forbid a specific function-call pattern | **ast-grep** |
| detect & rewrite deprecated APIs | **ast-grep (fix)** |
| forbidden pattern inside a specific context | **ast-grep (inside/has)** |
| project-specific structural constraints (layered architecture, interface rename) | **ast-grep** |

Signs that ast-grep is the right choice: rule depends on parent/child/sibling AST relationships; automatic rewriting (rename, schema migration) is required; ruff config cannot express it.

## Install

```bash
uv tool install ast-grep-cli   # recommended for Python projects
# alternatives: cargo install ast-grep --locked  /  brew install ast-grep
ast-grep --help
```

## Quick start

```bash
mkdir -p rules rule-tests
cat > sgconfig.yml << 'EOF'
ruleDirs:
  - rules
testConfigs:
  - testDir: rule-tests
EOF

cat > rules/no-print.yml << 'EOF'
id: no-print
language: Python
severity: warning
rule:
  pattern: print($$$ARGS)
message: Use logger instead of print().
fix: logger.info($$$ARGS)
EOF

cat > rule-tests/no-print-test.yml << 'EOF'
id: no-print
valid:
  - logger.info('ok')
invalid:
  - print('debug')
EOF

ast-grep test --skip-snapshot-tests   # classification test
ast-grep scan src/                    # scan project
```

For sgconfig fields and full directory layout see `references/rule-yaml.md`.

## Core principles

- First check whether ruff/pyright can cover the rule
- Develop rules with TDD: test-first → rule implementation → CI integration
- Write `fix` only when "replacing everywhere is safe". Otherwise keep detection-only and document the manual migration in `note`
- After applying ast-grep auto-fixes always run the project quality gate (verification-loop)

## Rule file structure

```yaml
id: no-direct-env-access
language: Python
severity: warning
rule:
  pattern: os.environ[$KEY]
  not:
    inside:
      kind: function_definition
      has:
        pattern: get_env
      stopBy: end
message: Do not reference os.environ directly. Go through get_env().
fix: get_env($KEY)
files:
  - "src/**"
```

| Field | Required | Description |
|-------|----------|-------------|
| `id`, `language`, `rule` | Yes | identifier / target language / match condition |
| `severity` | No | `hint`, `warning`, `error` |
| `message`, `note` | No | one-liner / migration guide |
| `fix` | No | auto-fix template |
| `constraints`, `transform` | No | metavariable filtering / textual transform |
| `files`, `ignores`, `url` | No | scope glob / docs link |

Multiple operators directly under `rule` are AND-evaluated. See `references/rule-yaml.md` for `pattern` / `kind` / `has` / `inside` / `not` / `follows` / `precedes`, `stopBy`, `constraints`, `transform`, `utils`, suppression comments, and multi-line fix.

## Metavariable pitfalls

- `$VAR` matches exactly one node; `$$$VARS` matches zero or more (variadic args / multiple statements). **Empty match is allowed** — e.g. `set()` matches `set($$$ARGS)` with `$$$ARGS` empty
- `$_` is a wildcard (no capture; same name can match different content)
- `$OBJ.$PROP` matches **dot access only** — not `obj['key']` (subscript). `obj['key']` is `kind: subscript`
- A metavariable must occupy a whole node: `obj.on$EVENT` and `f"hello {$NAME}"` do not work
- Same `$X` in `pattern` and `has`/`inside` binds to the same subtree — use `$X` / `$Y` when they should differ

## Deciding whether to attach `fix`

`fix` is convenient but applied automatically — it can change semantics. **Do not attach** (detection-only) when:

- The rewrite changes type safety
- Side effects or evaluation order may change (timing of exceptions)
- The correct replacement is context-dependent (API migrations that swap argument order)
- Deletion entangles with other expressions in the same statement

When in doubt, skip `fix` and document manual migration steps in `note`. CLI also supports YAML-less rewrites: `ast-grep run --pattern '...' --rewrite '...' --lang python .`

For deletion fixes (`fix: ''`), range expansion (`expandEnd`), `any:` + fix consolidation/splitting, and the deletion decision flow, see `references/rule-yaml.md`.

## Practical Python rule examples

Three core patterns. See `references/python-rule-examples.md` for five more (bare except, print → logger, layered constraints, silent except, schema rename).

### Rename deprecated function (auto-fix safe)

```yaml
id: rename-old-init
language: Python
severity: error
rule:
  pattern: old_init_l3($$$ARGS)
fix: init_l3_controller($$$ARGS)
message: old_init_l3 is deprecated. Use init_l3_controller (post-Phase 67 schema).
note: |
  Why auto-fix is safe: argument order and semantics are identical;
  only the function name changed. Verify diff with git status before commit.
```

### Layered constraint (forbid cross-layer call)

Forbid `runner.*` calls inside L3 controller (pilotq architectural rule):

```yaml
id: no-runner-call-in-l3
language: Python
severity: error
rule:
  pattern: runner.$METHOD($$$ARGS)
  inside:
    kind: function_definition
    stopBy: end
files:
  - "src/l3/**"
message: L3 must not call runner.* (architectural inversion). Pass dependencies via interface.
```

### Schema migration (dataclass field rename)

Phase 067 schema fix — `theta_w_mean` (formula) → `theta_w_actual` (L3 actual):

```yaml
id: rename-theta-w-field
language: Python
severity: error
rule:
  pattern: $OBJ.theta_w_mean
fix: $OBJ.theta_w_actual
message: theta_w_mean is renamed to theta_w_actual after Phase 067 (L3 actual values, not formula).
note: See MEMORY.md "per_run.csv theta 列の罠 (Phase 065 確定)".
```

## Testing (TDD workflow)

Two test categories — do not conflate:

- **Classification test** (`ast-grep test --skip-snapshot-tests`): verifies `valid`/`invalid` classification. Run in CI.
- **Snapshot test** (`ast-grep test` / `test -U`): pins match positions and fix output as snapshots. Generate locally with `-U`, review, commit.

```yaml
# rule-tests/no-direct-env-access-test.yml — id MUST match the rule's id
id: no-direct-env-access
valid:
  - get_env('NODE_ENV')
invalid:
  - os.environ['NODE_ENV']
```

Markers: `.` pass, `N` noisy (false positive), `M` missing (false negative).

Workflow: write test (Red) → write rule (Green) → `test --skip-snapshot-tests` → `test -U` to pin snapshots → review → commit. Details in `references/testing.md`.

## CI integration

```bash
# Makefile-style
ast-grep-test:
	ast-grep test --skip-snapshot-tests

ast-grep-lint:
	ast-grep scan

check: ruff-check pyright ast-grep-lint pytest
```

```yaml
# GitHub Actions
- run: pip install uv && uv tool install ast-grep-cli
- run: ast-grep test --skip-snapshot-tests
- run: ast-grep scan --error
```

`ast-grep scan` exits non-zero by default only on `error` severity. `--error` includes `warning` / `hint`; `--error=warning` for graduated tightening. JSON output via `--format json`. Full subcommand / flag reference in `references/cli.md`.

## Looking up `kind` names

Kind names depend on Tree-sitter grammar.

```bash
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=ast   # named nodes
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=cst   # all nodes
```

Always run a debug-query before writing a non-trivial pattern. Common Python kinds (`function_definition`, `call`, `attribute`, `subscript`, `except_clause`, `dictionary_comprehension`, ...) are catalogued in `references/kind-catalog.md`.

## Pairing with verification-loop

After applying ast-grep auto-fixes (especially `fix:` rules), always run the project quality gate:

```bash
ast-grep scan --update-all                      # 1. apply fixes
uv run --frozen ruff format .                   # 2. format
uv run --frozen ruff check . --fix              # 3. lint
uv run --frozen pyright                         # 4. typecheck
uv run --frozen pytest                          # 5. test
```

If any step fails after auto-fix, revert and convert the rule to detection-only (drop `fix:`), then migrate manually. ast-grep rewrites are mechanical; verification-loop is the safety net.

## References

In-skill details (Python-focused):

- `references/rule-yaml.md` — full rule YAML: operators, evaluation order, metavariable binding, `constraints` / `transform` / `utils`, `fix` deletion + range expansion, `any:` consolidation, suppression comments, sgconfig fields
- `references/python-rule-examples.md` — eight pilotq-flavored example rules (bare except, print migration, rename, API migration, layered constraints, silent except, schema rename)
- `references/testing.md` — classification vs snapshot tests, multi-line code notation, snapshot operations
- `references/cli.md` — subcommands, flags, exit codes, `--error` / `--format json`
- `references/kind-catalog.md` — Python kind catalog (`function_definition`, `call`, `subscript`, ...) and language-specific notes (subscript vs attribute, PEP 604 unions, f-strings, decorators)

Official:

- ast-grep docs: https://ast-grep.github.io/
- Rule reference: https://ast-grep.github.io/reference/yaml.html
- sgconfig: https://ast-grep.github.io/reference/sgconfig.html
- Playground: https://ast-grep.github.io/playground.html
- Rule catalog: https://ast-grep.github.io/catalog/
