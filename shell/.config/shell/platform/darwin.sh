# macOS-specific shell config. Keeps GNU userland and Homebrew paths consistent.

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix)"

  for _gnudir in coreutils findutils gnu-sed gawk grep; do
    path_prepend "$_brew_prefix/opt/${_gnudir}/libexec/gnubin"
  done

  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  [ -s "$_brew_prefix/opt/nvm/nvm.sh" ] && . "$_brew_prefix/opt/nvm/nvm.sh"

  alias update='brew update'
  alias upgrade='brew upgrade'
fi

unset _brew_prefix _gnudir