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
    # Sessions-only mode — fzf over active sessions, attach on select.
    # Works from inside or outside tmux.
    local session
    session=$(tmux list-sessions -F "#{session_name}: #{session_path}" 2>/dev/null \
      | fzf --prompt="session ❯ " --reverse) || return 0
    if [ -n "${TMUX:-}" ]; then
      tmux switch-client -t "${session%%:*}"
    else
      tmux attach -t "${session%%:*}"
    fi
  elif [ -n "${TMUX:-}" ]; then
    # Inside tmux — open sessionizer as a floating popup
    tmux display-popup -E -w 55% -h 45% -b rounded -S 'fg=#cba6f7' tmux-sessionizer
  else
    # Outside tmux — run sessionizer inline (no extra args passed)
    tmux-sessionizer
  fi
}

# tk — kill a tmux session by name, or the current one if no arg given.
#      Triggers a resurrect save after kill so the session is never
#      restored on next tmux start. Previous snapshots are kept on disk
#      so you can recover with: ln -sf <snapshot> ~/.local/share/tmux/resurrect/last
#
#   tk            kill the session you're currently attached to
#   tk mysession  kill a specific named session
#
tk() {
  local target="${1:-$(tmux display-message -p '#S' 2>/dev/null)}"
  if [[ -z "$target" ]]; then
    echo "✖ no session name given and not inside tmux — usage: tk <session-name>"; return 1
  fi
  if ! tmux has-session -t "$target" 2>/dev/null; then
    echo "✖ no session named '$target'"; return 1
  fi
  read "reply?kill session '$target'? [y/N] "
  [[ "${reply:l}" == "y" ]] || { echo "aborted"; return 0; }
  tmux kill-session -t "$target" \
    && echo "✔ killed session: $target" \
    && tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh \
    && echo "✔ snapshot updated"
}

# tmux-help — print all custom tmux commands and key bindings
tmux-help() {
  cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  tmux cheatsheet — alameen-adedeji
  prefix = Ctrl+A
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SHELL COMMANDS
  t               attach to last session, or start a new one
  tls             list all running sessions
  ta              fzf picker — create or switch to a session (project dirs + active sessions)
  ta -s           fzf picker — active sessions only
  tnew <name>     create a new named session via dir picker (errors if name exists)
  tk [name]       kill session (defaults to current) — confirms before killing, saves snapshot

SESSION LIFECYCLE
  Sessions are auto-saved every 15 min by tmux-continuum.
  Restore happens once on tmux server start (after reboot).
  tk always updates the snapshot so killed sessions are never restored.
  To recover an accidentally killed session:
    1.  ls -lt ~/.local/share/tmux/resurrect/   ← find snapshot before the kill
    2.  ln -sf <snapshot> ~/.local/share/tmux/resurrect/last
    3.  prefix + Ctrl+r                          ← restore

KEY BINDINGS — SESSIONS
  prefix + d      detach from current session (leaves it running)
  prefix + s      visual session tree switcher
  prefix + f      floating sessionizer popup (same as ta, inside tmux)
  prefix + $      rename current session
  prefix + Ctrl+s force-save snapshot now
  prefix + Ctrl+r restore from snapshot

KEY BINDINGS — WINDOWS
  prefix + c      new window (inherits current dir)
  prefix + ,      rename current window
  prefix + [      previous window
  prefix + ]      next window
  prefix + X      kill window (no confirmation)

KEY BINDINGS — PANES
  prefix + |      split vertical
  prefix + -      split horizontal
  prefix + h/j/k/l  navigate panes (vim-style)
  C-h/j/k/l       navigate panes without prefix (vim-tmux-navigator aware)
  prefix + R      enter resize mode, then H/J/K/L to resize, Esc to exit
  prefix + x      kill pane (no confirmation)

KEY BINDINGS — COPY MODE
  prefix + Enter  enter copy mode
  v               start visual selection
  y               yank selection to clipboard (pbcopy) and exit
  Escape          cancel copy mode
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# tnew — create a new named tmux session in a directory chosen via the sessionizer picker.
#
#   tnew <name>   asks for a name, shows the same fzf dir picker as `ta`,
#                 then creates and switches to the session with that name.
#                 Errors if a session with that name already exists.
#
tnew() {
  local name="${1:?usage: tnew <session-name>}"
  if tmux has-session -t "$name" 2>/dev/null; then
    echo "✖ session '$name' already exists — use 'ta -s' to attach or pick a different name"
    return 1
  fi
  local dir
  dir=$(tmux-sessionizer --pick) || return 0
  [[ -z "$dir" ]] && return 0
  tmux new-session -d -s "$name" -c "$dir" \
    && echo "✔ created session '$name' in $dir" \
    && { [ -n "${TMUX:-}" ] && tmux switch-client -t "$name" || tmux attach -t "$name"; }
}
