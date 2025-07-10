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

# Ubah daftar file jadi format natural
FILES=($CHANGES)
COUNT=${#FILES[@]}

if [[ $COUNT -eq 1 ]]; then
    FILE_LIST="modified ${FILES[0]}"
else
    FILE_LIST="modified ${FILES[*]:0:$((COUNT - 1))} and ${FILES[-1]}"
fi

COMMIT_MSG="update: ${FILE_LIST}"

# Commit & push
echo "📦 Commit: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📤 Push ke origin/$BRANCH..."
git push origin "$BRANCH"
