# ~/.zprofile - login-shell environment for Zsh.

_shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[ -r "$_shell_config_dir/exports.sh" ] && . "$_shell_config_dir/exports.sh"
[ -r "$_shell_config_dir/paths.sh" ] && . "$_shell_config_dir/paths.sh"
unset _shell_config_dir