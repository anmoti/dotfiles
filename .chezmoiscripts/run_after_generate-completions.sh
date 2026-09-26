#!/usr/bin/env bash
set -euo pipefail

COMP_DIR="$HOME/.config/zsh/completions"
mkdir -p "$COMP_DIR"

# proto
if command -v pnpm >/dev/null 2>&1; then
  proto run pnpm --config-mode global -- completion zsh > "$COMP_DIR/_pnpm"
fi
