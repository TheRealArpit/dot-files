# Shared shell functions.

# ta — open tmux-sessionizer.
# Outside tmux: runs inline. Inside tmux: opens the styled popup (matches <prefix>f).
ta() {
  if [ -n "${TMUX:-}" ]; then
    tmux display-popup -E -w 55% -h 45% -b rounded -S 'fg=#cba6f7' tmux-sessionizer
  else
    tmux-sessionizer "$@"
  fi
}