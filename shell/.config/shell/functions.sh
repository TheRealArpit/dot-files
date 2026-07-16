# Shared shell functions.

# ta — tmux session manager.
#
#   ta          fzf over active sessions + project dirs — create or switch.
#               Inside tmux: opens as a floating popup.
#               Outside tmux: takes over the terminal inline.
#
#   ta -s       fzf over active sessions only — attach to an existing one.
#               Useful when you know a session is already running and don't
#               want project dirs cluttering the list.
#
ta() {
  if [ "${1}" = "-s" ] || [ "${1}" = "--sessions" ]; then
    local session
    session=$(tmux list-sessions -F "#{session_name}: #{session_path}" 2>/dev/null \
      | fzf --prompt="session ❯ " --reverse) || return 0
    tmux attach -t "${session%%:*}"
  elif [ -n "${TMUX:-}" ]; then
    tmux display-popup -E -w 55% -h 45% -b rounded -S 'fg=#cba6f7' tmux-sessionizer
  else
    tmux-sessionizer "$@"
  fi
}