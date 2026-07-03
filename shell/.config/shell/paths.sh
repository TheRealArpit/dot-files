# Shared PATH setup. Keep this file shell-portable.

path_prepend() {
  [ -d "$1" ] || return 0

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

export PATH