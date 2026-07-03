# Source the current OS layer.

_shell_os="$(uname -s | tr '[:upper:]' '[:lower:]')"
_shell_platform_file="${XDG_CONFIG_HOME:-$HOME/.config}/shell/platform/${_shell_os}.sh"

[ -r "$_shell_platform_file" ] && . "$_shell_platform_file"

unset _shell_os _shell_platform_file