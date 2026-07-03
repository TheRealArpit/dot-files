# Shared interactive tool configuration.

if command -v fdfind >/dev/null 2>&1 || command -v fd >/dev/null 2>&1; then
  _fd="$(command -v fdfind 2>/dev/null || command -v fd 2>/dev/null)"
  export FZF_DEFAULT_COMMAND="$_fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  unset _fd
fi

if command -v batcat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'batcat --color=always {}'"
elif command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
fi
