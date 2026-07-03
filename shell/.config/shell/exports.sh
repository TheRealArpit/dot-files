# Shared environment exports for Bash and Zsh.

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# Coloured ls output via vivid — hardcoded to catppuccin-mocha.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-mocha 2>/dev/null)"
fi