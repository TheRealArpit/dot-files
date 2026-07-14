# Linux-specific shell config. Keep Bash-only completion setup in ~/.bashrc.

_shell_distro=""
if [ -r /etc/os-release ]; then
  . /etc/os-release
  _shell_distro="${ID:-}"
fi

case "$_shell_distro" in
  fedora)
    alias update='sudo dnf check-update'
    alias upgrade='sudo dnf upgrade'
    ;;
  arch)
    alias update='sudo pacman -Sy'
    alias upgrade='sudo pacman -Syu'
    ;;
  ubuntu|debian)
    alias update='sudo apt update'
    alias upgrade='sudo apt upgrade'
    ;;
esac

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Rust — source cargo env if present (installed via rustup)
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

unset _shell_distro