# Python rule examples (pilotq-flavored)

Practical Python ast-grep rules. Companion to SKILL.md. Each example shows the real-world scenario and the rule YAML.

## 1. Forbid bare `except`

Detection-only (no fix — manual review of exception type required).

```yaml
id: no-bare-except
language: Python
severity: warning
rule:
  kind: except_clause
  not:
    has:
      kind: identifier
      stopBy: neighbor
message: Do not use bare except. Specify the exception type.
```

## 2. Migrate `print()` → logger (src/ only)

Excludes `def main` so CLI entry-points keep their print().

```yaml
id: no-print-in-src
language: Python
severity: warning
rule:
  pattern: print($$$ARGS)
  not:
    inside:
      kind: function_definition
      regex: 'def main'
      stopBy: end
message: Use logger instead of print().
fix: logger.info($$$ARGS)
files:
  - "src/**"
```

## 3. Rename deprecated function (whole codebase)

Argument order / semantics unchanged → auto-fix is safe.

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

## 4. Rewrite deprecated method (API migration)

`compute_skip_rate` removed; `compute_rate` returns the complement.

```yaml
id: migrate-old-skip-rate
language: Python
severity: error
rule:
  pattern: $OBJ.compute_skip_rate($$$ARGS)
fix: 1.0 - $OBJ.compute_rate($$$ARGS)
message: compute_skip_rate is removed. compute_rate returns its complement.
note: |
  pilotq terminology: skip_rate = 1 - compute_rate. See MEMORY.md "用語トラップ".
```

## 5. Layered constraint: forbid `os.environ` inside L3

Architectural rule — L3 must remain config-pure.

```yaml
id: no-os-environ-in-l3
language: Python
severity: warning
rule:
  pattern: os.environ[$$$KEYS]
  inside:
    kind: function_definition
    pattern: |
      def $NAME($$$):
        $$$BODY
    stopBy: end
files:
  - "src/l3/**"
message: Do not access os.environ in L3 controller. Inject config via constructor.
note: Layered constraint — L3 must remain config-pure for reproducibility.
```

## 6. Forbid cross-layer call (`runner.*` inside L3)

Architectural inversion guard.

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

## 7. Detect silently-swallowed exception

`except: pass` is a smell.

```yaml
id: no-silent-except
language: Python
severity: warning
rule:
  kind: except_clause
  has:
    kind: block
    has:
      kind: pass_statement
      stopBy: neighbor
message: Do not silently swallow exceptions. Log or re-raise.
```

## 8. Schema migration: rename dataclass field

Phase 067 schema fix — `theta_w_mean` (formula) → `theta_w_actual` (L3 actual).

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
