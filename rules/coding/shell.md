# シェルスクリプト ルール

## 必須ヘッダー

すべてのスクリプトの先頭に記述:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

## shellcheck 準拠

すべてのスクリプトは `shellcheck` をパスすること。CI に組み込み推奨。

## 変数クォート (SC2086)

変数は常にダブルクォートで囲む:

```bash
# Good
echo "${name}" > "$output_file"

# Bad - word splitting, globbing の危険
echo $name > $output_file
```

## コマンド置換

バッククォートではなく `$()` を使用:

```bash
# Good
current_date=$(date +%Y-%m-%d)

# Bad
current_date=`date +%Y-%m-%d`
```

## エラーハンドリング

```bash
cleanup() {
  rm -f "$tmpfile"
}
trap cleanup EXIT ERR

command_that_may_fail || { echo "Failed" >&2; exit 1; }
```

## sed -i の使用禁止

macOS/Linux で挙動が異なるため直接使用しない。一時ファイル経由で対処:

```bash
sed 's/old/new/' file.txt > file.txt.tmp && mv file.txt.tmp file.txt
```

## mktemp のポータブルな使用

```bash
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT
```
