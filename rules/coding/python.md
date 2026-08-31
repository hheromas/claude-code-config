# Python コーディング規約

共通規約 (`common.md`) に加え、Python 固有の品質基準を定義。

## 品質保証コマンド

```bash
uv run --frozen ruff format .
uv run --frozen ruff check . --fix
uv run --frozen pyright
uv run --frozen bandit -r .
uv run --frozen pytest --cov
```

PostToolUse hook (`python-autoformat.sh`) が ruff format/check を自動実行するが、pyright/bandit/pytest は手動確認が必要。

## 非同期テスト

`asyncio` ではなく `anyio` を使用。

## Docstring 規約 (Google スタイル)

すべての公開関数に `doctest` を含む詳細な Docstring を付与:

```python
def function_name(param: ParamType) -> ReturnType:
    """この関数が何をするかの簡潔な説明。

    Args:
        param (ParamType): パラメータの説明。

    Returns:
        ReturnType: 返される値の説明。

    Raises:
        ErrorType: エラー条件。

    Example:
        >>> result = function_name("input")
        >>> print(result)
        'expected output'
    """
```

## Python 固有スタイル

- **関数型**: ネストしたループより `itertools` や内包表記
