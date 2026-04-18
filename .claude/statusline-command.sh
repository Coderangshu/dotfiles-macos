#!/bin/zsh
input=$(cat)

# Extract data from JSON
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')

# Context calculations
used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0 + .context_window.total_output_tokens // 0')
total_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Format tokens to match /context precisely: 26.7k/200k tokens (13%)
# Use jq to handle the k-formatting for consistency with /context output
used_k=$(echo "$input" | jq -r '(.context_window.total_input_tokens // 0 + .context_window.total_output_tokens // 0) / 1000 | tostring | if . == "0" then "0" else (if (sub("(\\.[0-9]+)$"; "") | tonumber) == . then . + "k" else (sub("(\\.[0-9]{3})$"; "k")) end) end')
# Correction: /context uses a simpler k-suffix for total
total_k=$(echo "$input" | jq -r '(.context_window.context_window_size // 0) / 1000 | tostring + "k"')
# Since the above jq for used_k is complex, let's use a more reliable shell approach for "X.Yk"
used_k=$(printf "%.1fk" "$(echo "scale=2; $used_tokens/1000" | bc)")
# Remove trailing .0 if it exists to match /context style (e.g., 26k instead of 26.0k)
used_k=$(echo "$used_k" | sed 's/\.0k/k/')
total_k=$(printf "%.0fk" "$(echo "scale=2; $total_tokens/1000" | bc)")

# Get git branch
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Format project name
project_name=$(basename "$project_dir")

# Define colors (using printf for ANSI)
# Blue: \033[34m, Cyan: \033[36m, Yellow: \033[33m, Magenta: \033[35m, Reset: \033[0m
C_GREEN='\033[32m'
C_BLUE='\033[34m'
C_CYAN='\033[36m'
C_YELLOW='\033[33m'
C_MAGENTA='\033[35m'
C_RESET='\033[0m'

# Build status line with colors
out=$(printf "${C_BLUE}%s${C_RESET} | ${C_YELLOW}%s${C_RESET}" "$project_name" "$current_dir")
[ -n "$branch" ] && out="$out | ${C_GREEN}$branch${C_RESET}"
out="$out | ${C_MAGENTA}$model_name${C_RESET}"

# Context Bar and Stats
if [ -n "$used_pct" ] && [ "$total_tokens" -gt 0 ]; then
    # Create a simple bar [####------]
    bar_width=10
    filled=$(printf "%.0f" "$(echo "scale=0; ($used_pct * $bar_width / 100) + 0.5" | bc)")
    empty=$((bar_width - filled))
    bar=$(printf "%${filled}s" | tr ' ' '#')$(printf "%${empty}s" | tr ' ' '-')

    out="$out | ${C_CYAN}Context: [${C_YELLOW}$bar${C_CYAN}] (${used_pct}%)${C_RESET}"
fi

echo -e "$out"
