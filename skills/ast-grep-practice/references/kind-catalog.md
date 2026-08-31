# Python kind catalog

AST node names to specify in the ast-grep `kind` field, restricted to Python (this skill is Python-only). Names depend on the Tree-sitter grammar — when in doubt, run `ast-grep run --pattern '...' --lang python --debug-query=ast` to confirm.

## Python

| kind | Corresponding code |
|------|-------------------|
| `function_definition` | `def foo():` |
| `class_definition` | `class Foo:` |
| `call` | `foo()` |
| `attribute` | `obj.attr` |
| `subscript` | `obj[key]` |
| `import_statement` | `import ...` |
| `import_from_statement` | `from ... import ...` |
| `if_statement` | `if ...:` |
| `try_statement` | `try: ...` |
| `except_clause` | `except SomeError as e:` |
| `with_statement` | `with ...:` |
| `decorator` | `@decorator` |
| `lambda` | `lambda x: x + 1` |
| `assignment` | `x = 1` |
| `augmented_assignment` | `x += 1` |
| `comparison_operator` | `a < b` |
| `boolean_operator` | `a and b` |
| `await` | `await x` |
| `yield` | `yield x` |
| `list_comprehension` | `[x for x in xs]` |
| `set_comprehension` | `{x for x in xs}` |
| `dictionary_comprehension` | `{k: v for k, v in d.items()}` |
| `generator_expression` | `(x for x in xs)` |
| `for_statement` | `for x in xs: ...` |
| `while_statement` | `while cond: ...` |
| `return_statement` | `return x` |
| `raise_statement` | `raise SomeError(...)` |
| `pass_statement` | `pass` |
| `assert_statement` | `assert x` |
| `block` | The indented body of a function / class / if etc. |
| `parameters` | `(self, x, y=1)` parameter list |
| `argument_list` | `(arg1, arg2)` call arguments |

## Looking up kind names

```bash
# AST dump (named nodes only — what you write rules against)
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=ast

# CST dump (all nodes, including anonymous tokens)
ast-grep run --pattern 'YOUR_CODE' --lang python --debug-query=cst
```

Always run a debug-query first when writing a non-trivial pattern to verify the structure.

## Python-specific notes

- **Indentation sensitivity**: Python's grammar is indent-aware. When writing a multi-line `fix:`, prefer YAML block scalars (`|`) and verify indentation in snapshot output.
- **`subscript` vs `attribute`**: `obj['key']` (subscript) and `obj.key` (attribute) are different AST nodes. `$OBJ.$ATTR` does **not** match the bracket form.
- **Type hints**: PEP 604 union types (`int | None`) parse as `binary_operator` with `|` operator. `Optional[int]` parses as `subscript`. Match accordingly.
- **f-strings**: An f-string is `string` → contains `interpolation` nodes. Metavariables cannot be embedded inside f-string text directly.
- **Decorators**: `@deco` precedes the `function_definition`. To match a decorator on a function, use `inside: { kind: decorated_definition }` or `precedes:`.

## References

- Official Tree-sitter Python grammar: https://github.com/tree-sitter/tree-sitter-python (`grammar.js` `rule` names map directly to kind names)
- ast-grep playground: https://ast-grep.github.io/playground.html (try patterns in browser to inspect kind names)
