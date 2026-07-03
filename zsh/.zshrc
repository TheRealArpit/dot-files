# ~/.zshrc - Zsh-specific interactive wrapper.
# Shared shell logic lives in ~/.config/shell and is also sourced by Bash.

[[ -o interactive ]] || return

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt auto_cd
setopt interactive_comments
setopt prompt_subst

bindkey -e

_shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[[ -r "$_shell_config_dir/exports.sh" ]] && source "$_shell_config_dir/exports.sh"
[[ -r "$_shell_config_dir/paths.sh" ]] && source "$_shell_config_dir/paths.sh"
[[ -r "$_shell_config_dir/platform.sh" ]] && source "$_shell_config_dir/platform.sh"
[[ -r "$_shell_config_dir/aliases.sh" ]] && source "$_shell_config_dir/aliases.sh"
[[ -r "$_shell_config_dir/functions.sh" ]] && source "$_shell_config_dir/functions.sh"
[[ -r "$_shell_config_dir/tools.sh" ]] && source "$_shell_config_dir/tools.sh"
unset _shell_config_dir

# Custom completions — add before compinit so they're picked up
fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" $fpath)

_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$_zsh_cache_dir"
autoload -Uz compinit
compinit -d "$_zsh_cache_dir/zcompdump"
unset _zsh_cache_dir

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

if [[ -r "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
elif [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
  [[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
elif [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

for _plugin in \
  "${HOMEBREW_PREFIX:-}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -r "$_plugin" ]] && source "$_plugin" && break
done

for _plugin in \
  "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r "$_plugin" ]] && source "$_plugin" && break
done
unset _plugin

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"