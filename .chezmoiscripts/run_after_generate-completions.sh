#!/usr/bin/env bash
set -euo pipefail

COMP_DIR="$HOME/.config/zsh/completions"
mkdir -p "$COMP_DIR"

# proto
if command -v pnpm >/dev/null 2>&1; then
  proto run pnpm --config-mode global -- completion zsh > "$COMP_DIR/_pnpm"
fi

if command -v uv >/dev/null 2>&1; then
  proto run uv --config-mode global -- generate-shell-completion zsh > "$COMP_DIR/_uv"
fi
