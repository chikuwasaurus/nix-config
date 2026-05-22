#!/usr/bin/env zsh

set -euo pipefail

DEV_DIR="${DEV_DIR:-$HOME/Developer}"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    print -u2 "$1 is not found"
    exit 1
  }
}

require fzf
require zed

project_name="$(
  find "$DEV_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; |
    sort |
    fzf \
      --prompt="Open in Zed > " \
      --preview="bat --color=always --style=header,grid --line-range :80 \"$DEV_DIR\"/{}/README.* 2>/dev/null"
)"

[[ -z "${project_name:-}" ]] && exit 0

project="$DEV_DIR/$project_name"

if command -v direnv >/dev/null 2>&1 && [[ -f "$project/.envrc" ]]; then
  direnv exec "$project" zed "$project"
else
  zed "$project"
fi
