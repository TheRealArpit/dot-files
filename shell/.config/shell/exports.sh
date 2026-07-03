# Shared environment exports for Bash and Zsh.

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# Theme name — used by vivid (LS_COLORS) and Neovim colorscheme.
export THEME="${THEME:-catppuccin-mocha}"

# Generate LS_COLORS from the active theme via vivid.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate "$THEME" 2>/dev/null || vivid generate catppuccin-mocha 2>/dev/null)"
fi