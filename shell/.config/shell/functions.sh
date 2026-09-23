# Shared shell functions.

# ── dothelp — interactive/direct cheatsheet viewer ────────────────────────────
#
#   dothelp          interactive fzf cheatsheet picker with live preview
#   dothelp nvim     show Neovim & Bob 2.0 shortcuts (Harpoon, Oil, Flash, LSP)
#   dothelp tmux     show Tmux pane/window/session hotkeys
#   dothelp git      show Git aliases and workflows
#   dothelp k8s      show Kubernetes & Fyre cluster helpers
#
dothelp() {
  local doc_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell/docs"
  local topic="${1:-}"

  # Fallback if running directly from repo path before symlink/stow
  if [[ ! -d "$doc_dir" ]]; then
    local repo_docs="${DOTFILES_DIR:-$HOME/dotfiles-ibm}/shell/.config/shell/docs"
    [[ -d "$repo_docs" ]] && doc_dir="$repo_docs"
  fi

  if [[ -z "$topic" ]]; then
    if command -v fzf >/dev/null 2>&1; then
      local chosen
      chosen=$(command find "$doc_dir" -maxdepth 1 -name "*.md" -exec basename {} .md \; \
        | command fzf --prompt="dothelp ❯ " \
                      --reverse \
                      --preview="command -v bat >/dev/null && bat --style=plain --color=always $doc_dir/{}.md || cat $doc_dir/{}.md") || return 0
      [[ -n "$chosen" ]] && dothelp "$chosen"
      return 0
    else
      echo "Usage: dothelp <topic>"
      echo "Available topics:"
      command find "$doc_dir" -maxdepth 1 -name "*.md" -exec basename {} .md \; | sed 's/^/  • /'
      return 0
    fi
  fi

  local target="$doc_dir/${topic}.md"
  if [[ -f "$target" ]]; then
    if command -v bat >/dev/null 2>&1; then
      bat --style=grid --color=always --paging=never --language=markdown "$target"
    else
      cat "$target"
    fi
  else
    echo "✖ No cheatsheet found for '$topic'."
    echo "Available topics:"
    command find "$doc_dir" -maxdepth 1 -name "*.md" -exec basename {} .md \; | sed 's/^/  • /'
  fi
}

# ── Kubernetes — cluster switching ────────────────────────────────────────────
kube-local() {
  unset KUBECONFIG
  kubectl config use-context rancher-desktop 2>/dev/null
  echo "✔ switched to local (rancher-desktop)"
}

kube-stack() {
  export KUBECONFIG="$HOME/Downloads/kubeconfig.config"
  echo "✔ switched to stack cluster ($HOME/Downloads/kubeconfig.config)"
}

# ── Fyre ───────────────────────────────────────────────────────────────────────
fyre-create() {
  local cluster_name="${1:-${FYRE_CLUSTER_NAME:-testing-stack-name}}"
  fyre create 3 43 16 -K \
    -c "$cluster_name" \
    --registry-secret ~/.config/fyre/registry-info.yaml \
    --k8s-version 1.33 \
    --base-os ubuntu \
    --gateway-api \
    --username "${FYRE_USERNAME:-$FYRE_USER_NAME}" \
    --key "${FYRE_APIKEY:-$FYRE_API_KEY}" \
    --site svl "${@:2}"
}

# ── Tmux ───────────────────────────────────────────────────────────────────────
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

# tmux-help — alias to view tmux cheatsheet
tmux-help() {
  dothelp tmux
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
