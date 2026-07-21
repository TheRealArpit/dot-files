# ~/.bashrc - Bash-specific interactive wrapper.
# Shared shell logic lives in ~/.config/shell and is also sourced by Zsh.

case $- in
    *i*) ;;
    *) return ;;
esac

# Bash history and behavior.
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T  "

shopt -s checkwinsize
shopt -s globstar

_shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[ -r "$_shell_config_dir/exports.sh" ] && . "$_shell_config_dir/exports.sh"
[ -r "$_shell_config_dir/paths.sh" ] && . "$_shell_config_dir/paths.sh"
[ -r "$_shell_config_dir/platform.sh" ] && . "$_shell_config_dir/platform.sh"
[ -r "$_shell_config_dir/aliases.sh" ] && . "$_shell_config_dir/aliases.sh"
[ -r "$_shell_config_dir/functions.sh" ] && . "$_shell_config_dir/functions.sh"
[ -r "$_shell_config_dir/tools.sh" ] && . "$_shell_config_dir/tools.sh"
unset _shell_config_dir

# Bash-only completion/keybinding integrations.
if [ -n "${NVM_DIR:-}" ]; then
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

if [ -n "${HOMEBREW_PREFIX:-}" ]; then
    [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
    [ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash" ] && . "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash"
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"

bind 'set bell-style none'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/al-ameenadedeji/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
