# ~/.bash_profile — Bash login entry point.
# Sources shared login-shell environment then hands off to .bashrc
# for interactive config. Mirrors what .zprofile + .zshrc do for Zsh.

_shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[ -r "$_shell_config_dir/exports.sh" ] && . "$_shell_config_dir/exports.sh"
[ -r "$_shell_config_dir/paths.sh" ] && . "$_shell_config_dir/paths.sh"
unset _shell_config_dir

# Source .bashrc for interactive sessions (login shells don't do this automatically)
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/mirdha/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
