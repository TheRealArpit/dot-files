# Shared aliases. Keep these Bash/Zsh compatible.

# ── General shell ──────────────────────────────────────────────────────────────
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

# ── Project navigation ─────────────────────────────────────────────────────────
alias velox='cd "${VELOX:-$HOME/apic}"'
alias idig='cd "${VELOX:-$HOME/apic}/idig-broker"'
alias idig-op='cd "${VELOX:-$HOME/apic}/idig-operator"'

# ── IDIG operator — build & run ────────────────────────────────────────────────
# Full local dev sequence: clean → generate → download subsystem-images → install CRDs → build → run.
# Run from ~/apic/idig-operator with kube-local active.
alias idig-run='make clean-profiles profile-files-dev product manifests kustomize install build-dev && make WATCH_NAMESPACE=${WATCH_NAMESPACE:-idig-system} OPERATOR_MODE=${OPERATOR_MODE:-idig} ENABLE_WEBHOOKS=false run-only'

# ── IDIG operator — cluster inspection ────────────────────────────────────────
# kubectl shortcuts scoped to the IDIG namespace.
alias kn='kubectl -n ${IDIG_NS:-idig-system}'
alias idig-status='kubectl get idig -n ${IDIG_NS:-idig-system} -o wide'
alias idig-routes='kubectl get routes -n ${IDIG_NS:-idig-system}'
alias idig-pods='kubectl get pods -n ${IDIG_NS:-idig-system}'
alias idig-logs='kubectl logs -n ${IDIG_NS:-idig-system} -l app.kubernetes.io/name=idig-operator -f'
alias idig-events='kubectl get events -n ${IDIG_NS:-idig-system} --sort-by=.lastTimestamp | tail -20'

# ── Kubernetes — cluster switching ────────────────────────────────────────────
# Functions (not aliases) so that export + kubectl context-use both take effect
# in the current shell session.
kube-local() {
  unset KUBECONFIG
  kubectl config use-context rancher-desktop 2>/dev/null
  echo "✔ switched to local (rancher-desktop)"
}
kube-stack() {
  export KUBECONFIG="$HOME/Downloads/kubeconfig.config"
  echo "✔ switched to stack cluster ($HOME/Downloads/kubeconfig.config)"
}
alias kube-ctx='kubectl config current-context'

# ── Terminal multiplexer ───────────────────────────────────────────────────────
# t    — attach to last session, or start a new one
# tls  — list all running sessions
# tk   — kill a named session: tk [name]  (see functions.sh)
# tnew — create a new named session: tnew <name>  (see functions.sh)
alias t='tmux attach 2>/dev/null && echo "✔ attached to last session" || { tmux && echo "✔ started new tmux session"; }'
alias tls='tmux list-sessions 2>/dev/null || echo "no tmux sessions running"'

# ── Git ────────────────────────────────────────────────────────────────────────
alias gs='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias grb='git rebase'
alias gst='git stash'
alias gstp='git stash pop'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --graph --pretty="%C(yellow)%h%C(auto)%d%C(reset) %s %C(dim)(%cr)%Creset" --abbrev-commit -20'
alias gla='git log --graph --pretty="%C(yellow)%h%C(auto)%d%C(reset) %s %C(dim)(%cr)%Creset" --abbrev-commit --all'
alias gclean='git fetch --prune && git branch --merged main | grep -v "^\*\|main" | xargs -r git branch -d'

# ── TUI tools ─────────────────────────────────────────────────────────────────
alias lg='lazygit'
alias ld='lazydocker'

# ── Better CLI tools (conditional) ────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -la --icons=auto --group-directories-first --git --header'
  alias la='eza -a --icons=auto'
  alias lt='eza --tree --icons=auto --level=2 --git-ignore'
fi

if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
  alias bat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  alias fd='fdfind'
fi
