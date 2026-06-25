#!/usr/bin/env bash
# Шифрует незашифрованный source.html в index.html для публикации на GitHub.
# Локально работаешь с source.html (без пароля), перед коммитом запускаешь ./build.sh.
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f source.html ]]; then
  echo "✗ Нет source.html — нечего шифровать." >&2
  exit 1
fi
if [[ ! -f .staticrypt-password ]]; then
  echo "✗ Нет .staticrypt-password." >&2
  exit 1
fi

PASSWORD="$(cat .staticrypt-password)"
SALT="$(node -e "process.stdout.write(require('./.staticrypt.json').salt)")"

TMP=".build-tmp"
rm -rf "$TMP"
mkdir -p "$TMP"
cp source.html "$TMP/index.html"

# Вырезать временные dev-контролы — в продакшен (index.html / GitHub) они не идут
sed -i '' '/DEV:ANIM-CONTROLS:START/,/DEV:ANIM-CONTROLS:END/d' "$TMP/index.html"

npx staticrypt "$TMP/index.html" -p "$PASSWORD" --salt "$SALT" -d "$TMP/out" >/dev/null

cp "$TMP/out/index.html" index.html
rm -rf "$TMP"

echo "✓ index.html зашифрован из source.html"
