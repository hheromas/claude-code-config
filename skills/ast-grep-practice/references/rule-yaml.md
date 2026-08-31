# ast-grep rule YAML reference

Companion to SKILL.md. Field details, evaluation order, edge cases for rule YAML. (Python-focused.)

## rule operators

| Operator | Meaning |
|---|---|
| `pattern` | Match a code snippet (most basic; metavariables allowed) |
| `kind` | Specify by AST node kind directly (`function_definition` etc.) |
| `regex` | Regex on identifier names etc. (usually combined with constraints / pattern, not standalone) |
| `all: [...]` | Match all child rules (AND) |
| `any: [...]` | Match any child rule (OR) |
| `not: {...}` | Child rule does not match |
| `has: {...}` | A descendant matches the child rule |
| `inside: {...}` | An ancestor matches the child rule |
| `follows: {...}` | A sibling appears immediately before |
| `precedes: {...}` | A sibling appears immediately after |

`has` / `inside` / `follows` / `precedes` accept `stopBy` to bound the search (`end` / `neighbor` / `{kind: X}`).

## Evaluation order and AND semantics

Multiple operators directly under `rule` are evaluated as **AND**:

```yaml
rule:
  pattern: 'list({k: $V for $K, $V in $D.items()})'
  has:
    kind: dictionary_comprehension
    pattern: '{$K: $V for $K, $V in $D.items()}'
    stopBy: end
```

Both conditions must be true. Equivalent to `all:`. If `pattern` alone already expresses the same condition, `has` is redundant (keep it only when you want to express the structural constraint independently).

## Metavariable binding scope

**When the same `$X` appears in `pattern` and in `has` / `inside`, both bind to the same subtree** (the `$X` in `pattern: list({k: $V ...})` and in `has.pattern` is shared). Use a different name (`$X` / `$Y`) when they should differ.

## Metavariable kinds

- `$VAR` — exactly one AST node
- `$$$VARS` — zero or more nodes (variadic args / multiple statements). **Empty match allowed** (e.g. `set()` matches `set($$$ARGS)` with `$$$ARGS` empty)
- `$_` — wildcard (no capture; same name can match different content)
- A metavariable must occupy a whole node: `obj.on$EVENT` and `f"hello {$NAME}"` do not work

When `$$$` matches empty, the corresponding `$$$` in a `fix:` template also expands to empty. To avoid unintended empty matches, add `constraints` per variable or tighten the pattern.

## constraints behavior

Add extra conditions to a metavariable's contents. **Single `$VAR` only**, not `$$$VARS`.

```yaml
constraints:
  X:
    regex: '^[A-Z]'      # regex
    kind: identifier     # AST kind
    pattern: some_func   # pattern (acts like a separate rule)
```

### Multi-line regex matching

`constraints.X.regex` uses Rust's `regex` crate. **By default `.` does not match newlines** (toggle with the `(?s)` flag). When the metavariable spans multiple lines (multiple statements, multi-line expressions), explicitly write `(?s).+`.

### Caveat: constrained metavariables inside `not`

A constrained metavariable inside `not` may behave unexpectedly (constraints sometimes ignored). Keep `not` for structural negation; place metavariable conditions on the outer level.

## fix kinds

### String template (basic)

```yaml
fix: logger.info($ARG)
```

Metavariables expand directly. Unmatched metavariables (empty `$$$` etc.) become empty strings.

### Empty deletion

```yaml
fix: ''
```

Removes the matched node. A blank line may remain.

### FixConfig (range expansion)

```yaml
fix:
  template: ''
  expandEnd:
    regex: '[,\n]'     # extend the deletion to additional regex-matched bytes after the node
```

Use to also remove a trailing `,` or newline. `expandStart` exists too. `stopBy` bounds the range.

### Decision flow for deletion-style fixes

1. Target is a standalone statement (a one-line `print(...)`) → `fix: ''` + `expandEnd: {regex: '\n'}` to delete the line entirely
2. Target is part of an expression (entangled with other expressions, e.g. `foo(debug(), x)`'s `debug()`) → no fix (detection only, manual review)
3. Deletion would lose debug-intent info → no fix
4. A formatter (ruff format) runs pre-commit → `expandEnd` unnecessary, blank lines are tidied automatically

## `any:` + fix consolidation / split

If every branch under `any:` can use the **same fix template + same metavariables**, you may consolidate into one rule. If the fix differs per branch, always split the rule (you cannot write a per-branch fix inside `any:`).

### Trick: invert symbols via transform

`transform` can absorb the `== 0` / `!= 0` difference and consolidate into one rule, in some cases:

```yaml
rule:
  any:
    - pattern: len([x for x in $ARR if $P]) == 0
    - pattern: len([x for x in $ARR if $P]) != 0
transform:
  BANG:
    replace:
      source: $ARR
      replace: '.*'
      by: ''   # cannot directly switch per-branch — splitting is preferred
```

In practice, you cannot bind different metavariables per `any:` branch, so **two separate rules are usually better** (more readable, easier to maintain). Consolidation via `transform` is an advanced trick and rarely needed.

## Other fix-related notes

- CLI `ast-grep run --pattern ... --rewrite ...` is a YAML-less one-shot rewrite
- `ast-grep scan --update-all` applies fixes to every violation (dry-run with `--interactive`)
- Pin fixes via TDD with snapshots and use them for regression detection (see `references/testing.md`)

## url field

```yaml
url: https://docs.python.org/3/library/dataclasses.html
```

Links rule violations to related documentation. Useful for IDE / editor integration.

## files / ignores

`files: ["src/**"]` restricts the target glob; `ignores:` excludes. When both are specified, files narrows first then ignores excludes. For rules you want to allow in tests (e.g. `no-print-in-src`), set `files: ["src/**"]` to scope it to src/.

## transform

Textually transform matched metavariables before using them in `fix`.

### replace (regex replacement)

```yaml
transform:
  NEW_NAME:
    replace:
      source: $NAME
      replace: 'get_(\w+)'
      by: 'fetch_$1'
fix: $NEW_NAME($$$ARGS)
```

### substring

```yaml
transform:
  INNER:
    substring:
      source: $STR
      startChar: 1
      endChar: -1
```

Negative indices count from the end. Same semantics as Python slicing.

### convert (case conversion)

```yaml
transform:
  SNAKE:
    convert:
      source: $NAME
      toCase: snakeCase
      separatedBy: [caseChange]
```

Supported cases: `camelCase`, `snakeCase`, `kebabCase`, `pascalCase`, `upperCase`, `lowerCase`, `capitalize`

### rewrite (experimental)

Recursively rewrite nodes inside a metavariable using rewriter rules.

```yaml
transform:
  REWRITTEN:
    rewrite:
      source: $$$BODY
      rewriters: [migrate-api-call]
      joinBy: "\n"
```

## utils (utility rules)

Reference shared rules defined under `utilDirs` with `matches`.

```yaml
# rule-utils/is-async-function.yml
id: is-async-function
language: Python
rule:
  kind: function_definition
  has:
    field: async
    regex: async
```

```yaml
# rules/async-no-try-except.yml
id: async-no-try-except
language: Python
rule:
  all:
    - matches: is-async-function
    - has:
        pattern: await $EXPR
        stopBy: end
    - not:
        has:
          kind: try_statement
          stopBy: end
message: async function lacks try-except.
severity: warning
```

## sgconfig.yml fields

```yaml
ruleDirs:            # required: directories holding rule files
  - rules
testConfigs:         # optional: test configuration
  - testDir: rule-tests
utilDirs:            # optional: shared utility rules
  - rule-utils
```

`ast-grep scan` runs every rule under `ruleDirs` starting from the directory that contains `sgconfig.yml`.

## Suppression comments

```python
# ast-grep-ignore
some_code()

# ast-grep-ignore: no-direct-env-access
os.environ['NODE_ENV']
```

## Multi-line fix

```yaml
rule:
  pattern: |
    def foo($X):
      $$$S
fix: |-
  def bar($X):
    $$$S
```

Indentation is preserved relative to the original code's position.
