# ast-grep testing reference

Details for the SKILL.md "Testing" section. (Python-focused.)

## Two test categories

| Category | Command | What it verifies |
|---|---|---|
| Classification test | `ast-grep test --skip-snapshot-tests` | Whether `valid` / `invalid` is classified correctly (rule detection accuracy) |
| Snapshot test | `ast-grep test` / `ast-grep test -U` | Whether match positions and fix output on invalid code are pinned (regression detection) |

**CI**: run classification tests (`--skip-snapshot-tests`). Snapshot diffs require human review, so do not gate CI on them.

**Local development**: generate / update snapshots with `-U`, eyeball the diff, commit.

## Test file format

```yaml
# rule-tests/my-rule-test.yml
id: my-rule               # must match the id in rules/*.yml
valid:
  - "valid code 1"
  - "valid code 2"
invalid:
  - "invalid code 1"
  - "invalid code 2"
```

Filename is free (convention: `{rule-id}-test.yml`).

## Multi-line code notation

YAML block scalars allow multi-line code:

```yaml
id: async-no-try-except
valid:
  - |
    async def good():
      try:
        await do_work()
      except Exception as e:
        handle(e)
invalid:
  - |
    async def bad():
      await do_work()
      return 42
```

`|` (literal block scalar) preserves indentation, includes trailing newline. `|-` strips trailing newline. Use when you need to write whole functions for complex `inside:` / `has:` checks.

## Test result markers

- `.` — pass (expected)
- `N` — **noisy** (false positive — matched valid code)
- `M` — **missing** (false negative — failed to match invalid code)

Fix the rule or test when N / M appear.

## Snapshot operations

### First-time generation

```bash
ast-grep test -U
```

Generates YAML files under `rule-tests/__snapshots__/`. Records the invalid code, match positions, and fix results.

### Handling updates

After editing a rule, snapshot diffs may appear:
- Diff is intentional → re-generate with `-U` → review diff → commit
- Diff is unintentional → revisit the rule

Approve / reject one at a time with `--interactive`:

```bash
ast-grep test --interactive
```

### Why commit snapshots

- Documents rule intent ("this code is detected by this rule")
- Detects regressions (notices when rule edits change match scope)
- Enables review (snapshot diff visualizes behavior changes)

### Snapshot handling in CI

- Skip with `--skip-snapshot-tests`: run only classification tests, do not fail on snapshot diffs
- Do not run `-U` in CI (generated files are not committed, so it is meaningless)
- Snapshot maintenance is the developer's responsibility

## Test-driven flow

1. **Red**: write `valid` / `invalid` in `rule-tests/foo-test.yml` (no rule yet) → `ast-grep test` fails (no rule means invalid code does not match)
2. **Green**: write the rule in `rules/foo.yml` → `ast-grep test --skip-snapshot-tests` passes
3. **Snapshot**: generate snapshots with `ast-grep test -U`, review content
4. **Commit**: commit rule / test / snapshots together
5. **CI**: classification test + scan (see `references/cli.md`)

## Common pitfalls

- **id mismatch**: when `rule-tests/`'s `id` does not match `rules/`'s `id`, the test is not recognized
- **YAML indentation**: keep block scalar `|` indentation consistent (do not mix tabs)
- **single / double quotes**: when the string contains `'` / `"` / `:`, choose quoting carefully. When in doubt, use a block scalar
- **Insufficient `valid` cases**: without similar-but-not-identical edge cases in `valid`, you cannot detect false positives. For a "no `set(arr)`" rule, include `set()` (no arg), `arr` (no Set), `frozenset(arr)` etc. in `valid` explicitly
