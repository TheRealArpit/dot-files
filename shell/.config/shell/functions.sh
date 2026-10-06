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
    local repo_docs="${DOTFILES_DIR:-$HOME/Documents/dotfiles-ibm}/shell/.config/shell/docs"
    [[ -d "$repo_docs" ]] && doc_dir="$repo_docs"
  fi

  if [[ -z "$topic" ]]; then
    if command -v fzf >/dev/null 2>&1; then
      local chosen
      chosen=$(command find "$doc_dir" -maxdepth 1 -name "*.md" -exec basename {} .md \; \
        | command fzf --prompt="dothelp ❯ " \
                      --reverse \
                      --height=70% \
                      --preview-window="right:65%:wrap" \
                      --bind="ctrl-d:preview-down,ctrl-u:preview-up" \
                      --preview="command -v bat >/dev/null && bat --style=plain --color=always --paging=never --language=markdown $doc_dir/{}.md || cat $doc_dir/{}.md") || return 0
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
      # Paged with bat (auto-pages if longer than screen, press 'q' to quit, supports j/k/scroll)
      bat --style=plain --color=always --paging=auto --language=markdown "$target"
    elif command -v less >/dev/null 2>&1; then
      less -RFX "$target"
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
# unalias in case an old alias is still in memory (e.g. from a previous stow)
unalias fyre-create 2>/dev/null
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
# ta — tmux session manager (names only).
#
#   ta          fzf over active session names — attach, switch, or create.
#               If no existing session matches your input, creates a new one.
#               Inside fzf: press Ctrl+X to kill the highlighted session.
#
ta() {
  local query match session code
  # If a session name is passed directly as an argument, use it
  if [ -n "${1:-}" ]; then
    session="$1"
  else
    local output
    output=$(tmux list-sessions -F "#{session_name}" 2>/dev/null \
      | fzf --prompt="session ❯ " --reverse --print-query \
            --header="^x: kill session" \
            --bind='ctrl-x:execute(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" 2>/dev/null)')
    code=$?

    # fzf returns 130 on Esc/Ctrl-C (cancel)
    [ "$code" -eq 130 ] && return 0

    query=$(echo "$output" | sed -n '1p')
    match=$(echo "$output" | sed -n '2p')
    session="${match:-$query}"
  fi

  # Clean session name (remove whitespace and special chars)
  session=$(echo "$session" | tr -cs 'a-zA-Z0-9_-' '_' | sed 's/^_//;s/_$//')
  [ -z "$session" ] && return 0

  if [ -n "${TMUX:-}" ]; then
    if ! tmux has-session -t "=$session" 2>/dev/null; then
      tmux new-session -ds "$session"
    fi
    tmux switch-client -t "$session"
  else
    tmux new-session -As "$session"
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

# explore — cd into a directory and open nvim with oil.nvim
#
#   explore ~/apic/idig-broker   open oil in that directory
#   explore                      open oil in the current directory
#
explore() {
  local target="${1:-.}"
  cd "$target" && nvim -c "Oil"
}
