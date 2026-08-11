# Shared environment exports for Bash and Zsh.

# Work-specific exports (credentials, cluster config, feature flags).
# Sourced here so they're available in every interactive shell automatically.
_work_sh="${XDG_CONFIG_HOME:-$HOME/.config}/shell/work.sh"
[[ -r "$_work_sh" ]] && source "$_work_sh"
unset _work_sh

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# Coloured ls output via vivid — hardcoded to catppuccin-mocha.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-mocha 2>/dev/null)"
fi