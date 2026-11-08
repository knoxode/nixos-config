#!/usr/bin/env bash
set -euo pipefail

TARGET="$1"

mkdir -p "$(dirname "$TARGET")"

if [ ! -f "$TARGET" ]; then
  touch "$TARGET"
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.final"' EXIT

# 1. Write common words first.
cat "$WORDLIST" > "$tmp"

# 2. Append existing words that are not in commonWords.
while IFS= read -r line; do
  [ -z "$line" ] && continue

  if ! grep -Fxq "$line" "$WORDLIST"; then
    echo "$line"
  fi
done < "$TARGET" >> "$tmp"

# 3. Deduplicate while preserving order.
awk '!seen[$0]++' "$tmp" > "$tmp.final"

# 4. Replace atomically.
mv "$tmp.final" "$TARGET"
