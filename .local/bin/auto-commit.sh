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

# Ambil nama folder/file unik dari perubahan
ITEMS=$(echo "$CHANGES" | awk -F/ '{print $1}' | sort -u | tr '\n' ' ')
COMMIT_MSG="auto: update ${ITEMS}"

# Commit & push
git commit -m "$COMMIT_MSG"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push origin "$BRANCH"
