#!/usr/bin/env bash
set -euo pipefail

# Pastikan di repo git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Bukan repo git!"
    exit 1
fi

# Tambahkan semua perubahan
git add .

# Ambil file yang berubah
CHANGES=$(git diff --cached --name-only)

if [ -z "$CHANGES" ]; then
    echo "✅ Tidak ada perubahan untuk di-commit"
    exit 0
fi

# Ambil direktori/folder level-2 (misal: srcpkgs/telegram-desktop-bin)
ITEMS=$(echo "$CHANGES" | awk -F/ '{print $1"/"$2}' | sort -u | tr '\n' ' ')
COMMIT_MSG="auto: update ${ITEMS}"

# Commit & push
echo "📦 Commit: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📤 Push ke origin/$BRANCH..."
git push origin "$BRANCH"
