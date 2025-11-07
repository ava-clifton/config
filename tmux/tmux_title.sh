#!/usr/bin/env bash
# Usage: tmux-title.sh <pane_id>
set -euo pipefail

pane_id="${1:-}"
[ -z "$pane_id" ] && exit 0

# Grab command and path from that pane
IFS='|' read -r cmd fullpath < <(tmux display-message -p -t "$pane_id" '#{pane_current_command}|#{pane_current_path}')

# Use just the directory name (basename)
dir="${fullpath##*/}"

# Truncate dir to max 10 chars with ellipsis
max=10
if [ "${#dir}" -gt "$max" ]; then
  dir="${dir:0:$max}…"
fi

# Print: "<cmd> <dir>"
printf "%s %s" "$cmd" "$dir"

