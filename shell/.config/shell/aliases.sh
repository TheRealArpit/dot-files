# Shared aliases. Keep these Bash/Zsh compatible.

alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

alias t='tmux attach 2>/dev/null || tmux'   # attach to last session or start new

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
alias lg='lazygit'
alias ld='lazydocker'
alias gl='git log --graph --pretty="%C(yellow)%h%C(auto)%d%C(reset) %s %C(dim)(%cr)%Creset" --abbrev-commit -20'
alias gla='git log --graph --pretty="%C(yellow)%h%C(auto)%d%C(reset) %s %C(dim)(%cr)%Creset" --abbrev-commit --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gclean='git fetch --prune && git branch --merged main | grep -v "^\*\|main" | xargs -r git branch -d'

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