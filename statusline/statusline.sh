#!/bin/zsh
input=$(cat)

yellow_bold=$'\e[1;33m'
magenta=$'\e[35m'
red_bold=$'\e[1;31m'
green=$'\e[32m'
yellow=$'\e[33m'
blue_bold=$'\e[1;34m'
cyan=$'\e[36m'
green_bold=$'\e[1;32m'
reset=$'\e[0m'

get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd'; }
get_duration() { echo "$input" | jq -r '.cost.total_duration_ms'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }
get_input_tokens() { echo "$input" | jq -r '.context_window.total_input_tokens'; }
get_output_tokens() { echo "$input" | jq -r '.context_window.total_output_tokens'; }
get_context_window_size() { echo "$input" | jq -r '.context_window.context_window_size'; }
get_used_percentage() { echo "$input" | jq -r '.context_window.used_percentage // 0'; }

cwd=$(get_current_dir)
cost=$(get_cost)
short_dir=$(basename "$cwd")
model=$(get_model_name)
used_pct=$(get_used_percentage)

git_branch=$(cd "$cwd" 2>/dev/null && git branch --show-current 2>/dev/null)
git_status=$(cd "$cwd" 2>/dev/null && git status --porcelain 2>/dev/null)
if [ -n "$git_status" ]; then
  git_indicator="${red_bold}±${reset}"
else
  git_indicator="${magenta}✓${reset}"
fi

venv="${VIRTUAL_ENV:+$(basename "$VIRTUAL_ENV")}"
conda="${CONDA_DEFAULT_ENV}"
env_str=""
[ -n "$conda" ] && env_str="${green}🐍${conda}${reset} "
[ -n "$venv" ] && env_str="${green}(${venv})${reset} "

aws_str=""
[ -n "$AWS_PROFILE" ] && aws_str="${yellow}☁️ AWS:${AWS_PROFILE}${reset} "

if [ "$cost" = "null" ] || [ -z "$cost" ]; then
  cost_str="${green_bold}\$0.00${reset}"
else
  cost_str=$(printf "${green_bold}\$%.2f${reset}" "$cost")
fi

if (( $(echo "$used_pct >= 80" | bc -l) )); then
  context_color="${red_bold}"
elif (( $(echo "$used_pct >= 60" | bc -l) )); then
  context_color="${yellow}"
else
  context_color="${cyan}"
fi
context_str=$(printf "${context_color}%.0f%%${reset}" "$used_pct")

git_str=""
[ -n "$git_branch" ] && git_str="${magenta}${git_branch}${reset} "

printf "${yellow_bold}%s${reset} %s%s%s%s ${blue_bold}🤖 %s${reset} 📊 %s 💰 %s\n" \
  "$short_dir" \
  "$env_str" \
  "$aws_str" \
  "$git_str" \
  "$git_indicator" \
  "$model" \
  "$context_str" \
  "$cost_str"
