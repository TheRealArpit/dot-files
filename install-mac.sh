#!/usr/bin/env bash
# =============================================================
# install-mac.sh — dotfiles-ibm bootstrap
# Target: macOS (Apple Silicon + Intel)
# Usage:  bash install-mac.sh
# =============================================================

set -e
DOTFILES_DIR="$HOME/dotfiles-ibm"

# =============================================================
# OUTPUT HELPERS
# =============================================================
OK="\e[32m✓\e[0m"
SKIP="\e[33m~\e[0m"
ERR="\e[31m✗\e[0m"
INFO="\e[34m→\e[0m"

log()  { echo -e "$INFO  $1"; }
ok()   { echo -e "$OK  $1"; }
skip() { echo -e "$SKIP  $1 (already installed)"; }
err()  { echo -e "$ERR  $1"; exit 1; }

brew_install() {
  if brew list "$1" &>/dev/null; then
    skip "$1"
  else
    log "Installing $1..."
    brew install "$1" && ok "$1"
  fi
}

brew_cask_install() {
  if brew list --cask "$1" &>/dev/null; then
    skip "$1 (cask)"
  else
    log "Installing $1 (cask)..."
    brew install --cask "$1" && ok "$1"
  fi
}

# =============================================================
# 0. HOMEBREW
# =============================================================
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  ok "homebrew"
else
  skip "homebrew"
  log "Updating Homebrew..."
  brew update -q
fi

# =============================================================
# 1. SHELLS — zsh interactive, bash compatibility
# =============================================================
brew_install zsh
brew_install bash
brew_install zsh-autosuggestions
brew_install zsh-syntax-highlighting

ZSH_PATH="$(brew --prefix)/bin/zsh"
if ! grep -qxF "$ZSH_PATH" /etc/shells; then
  log "Registering Homebrew zsh as a valid login shell..."
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "${SET_DEFAULT_SHELL:-1}" == "1" ]]; then
  # Compare against the system-recorded shell, not just $SHELL env var,
  # to avoid prompting when zsh is already set but $SHELL path differs.
  _recorded_shell="$(dscl . -read ~/ UserShell 2>/dev/null | awk '{print $2}')"
  if [[ "$_recorded_shell" != "$ZSH_PATH" ]]; then
    log "Setting zsh as default shell (you may be prompted for your password)..."
    chsh -s "$ZSH_PATH"
    ok "default shell -> zsh (takes effect on next login)"
  else
    ok "zsh already default shell"
  fi
  unset _recorded_shell
else
  log "Skipping default shell change (SET_DEFAULT_SHELL=0)"
fi

BASH5="$(brew --prefix)/bin/bash"
if ! grep -qxF "$BASH5" /etc/shells; then
  log "Registering Homebrew bash as a valid login shell..."
  echo "$BASH5" | sudo tee -a /etc/shells >/dev/null
fi

if brew list bash-completion &>/dev/null; then
  log "Unlinking bash-completion v1 to allow v2..."
  brew unlink bash-completion
fi
brew_install bash-completion@2

# =============================================================
# 2. GNU USERLAND (shadow BSD tools transparently)
# =============================================================
for pkg in coreutils findutils gnu-sed gawk grep; do
  brew_install "$pkg"
done

# =============================================================
# 3. CORE CLI STACK
# =============================================================
CORE_CLI=(
  git
  neovim
  tmux
  stow
  python3           # required for Poetry installer — Homebrew Python avoids Xcode CLT venv bug
  eza               # ls with icons, git status, directory-first
  fd                # fast find that respects .gitignore
  ripgrep           # fast recursive grep
  bat               # cat with syntax highlighting
  fzf               # fuzzy finder — wired to Ctrl+R, Ctrl+T, Alt+C in shell config
  zoxide            # smart cd with memory (use z instead of cd)
  lazygit           # terminal UI for git
  lazydocker        # terminal UI for managing containers, images, logs
  git-delta         # syntax-highlighted git diffs with line numbers
  wget              # used for binary/tarball downloads
  starship
  tree-sitter-cli   # needed for nvim-treesitter parser compilation
  maven             # Java build tool — required for apim-ci
  btop              # system monitor — CPU, memory, network, disk
  jq                # JSON processor — query and transform JSON from the command line
  minikube          # local Kubernetes cluster — required for idig-broker
  kubectl           # Kubernetes CLI
)

for pkg in "${CORE_CLI[@]}"; do
  brew_install "$pkg"
done

# =============================================================
# 4. JAVA 21 (Temurin — IBM-compatible OpenJDK distribution)
# =============================================================
if java -version 2>&1 | grep -q "21\."; then
  skip "java 21"
else
  log "Installing Java 21 (Temurin)..."
  brew install --cask temurin@21
  ok "java 21 (temurin)"
fi

# =============================================================
# 5. NVM + NODE 24 (matches apim-ci required version)
# =============================================================
brew_install nvm

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"

if ! nvm ls 24 &>/dev/null 2>&1; then
  log "Installing Node 24..."
  nvm install 24
  nvm alias default 24
  ok "node 24"
else
  skip "node 24"
fi

# =============================================================
# 6. GIT CONFIG — delta pager (idempotent)
# =============================================================
log "Configuring git-delta..."
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictstyle diff3
ok "git-delta config"

# =============================================================
# 7. FONTS — JetBrains Mono Nerd Font
# =============================================================
if fc-list 2>/dev/null | grep -qi "JetBrainsMono" || \
   ls ~/Library/Fonts/JetBrainsMono* &>/dev/null 2>&1; then
  skip "JetBrains Mono Nerd Font"
else
  log "Installing JetBrains Mono Nerd Font..."
  brew install --cask font-jetbrains-mono-nerd-font
  ok "JetBrains Mono Nerd Font"
fi

# =============================================================
# 8. RANCHER DESKTOP (IBM-approved Docker Desktop replacement)
# Docker Desktop is not permitted on IBM machines.
# Rancher Desktop provides a docker-compatible CLI via containerd/moby.
# =============================================================
if brew list --cask rancher 2>/dev/null | grep -q rancher; then
  skip "rancher desktop"
else
  log "Installing Rancher Desktop..."
  brew install --cask rancher
  ok "rancher desktop (open it once to complete setup, then 'rdctl start')"
fi

# =============================================================
# 9. POSTGRESQL (via container — matches apim-ci dev setup)
# Runs postgres:15.4 as a container on port 5432.
# Credentials: postgres / password  (dev only — never use in prod)
# Requires Rancher Desktop to be running first.
# =============================================================
if ! command -v docker &>/dev/null; then
  log "Skipping postgres container — docker not available (open Rancher Desktop and complete setup, then re-run this script)"
elif docker ps -a --format "{{.Names}}" 2>/dev/null | grep -q "^postgres$"; then
  skip "postgres container"
else
  log "Starting postgres:15.4 container (ensure Rancher Desktop is running first)..."
  docker run -d \
    --name postgres \
    --restart unless-stopped \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=password \
    postgres:15.4 \
    postgres -c log_statement=all -c log_line_prefix='%t %d '
  ok "postgres:15.4 (port 5432, user: postgres, password: password)"
fi

# =============================================================
# 10. GHOSTTY
# =============================================================
brew_cask_install ghostty

# =============================================================
# 11. WINDOW MANAGEMENT
# Rectangle — conflict-free window tiling and display moves
# Hammerspoon — focus shifting between monitors
# No AeroSpace — macOS modifier conflicts made it unreliable
# =============================================================
brew_cask_install rectangle
brew_cask_install hammerspoon

# =============================================================
# 12. POETRY (Python dependency manager — pinned to v1.8.5)
# api-assistant explicitly requires Poetry v1 (v2 not yet supported).
# Pinned via the official installer's POETRY_VERSION env var.
# =============================================================
if command -v poetry &>/dev/null && poetry --version 2>/dev/null | grep -q "^Poetry (version 1\."; then
  skip "poetry 1.x"
else
  log "Installing poetry 1.8.5..."
  # Use Homebrew Python explicitly — macOS system Python 3.9 (Xcode CLT) cannot
  # create venvs without symlinks and will crash the installer.
  _py="$(command -v python3.12 || command -v python3.11 || command -v python3 2>/dev/null)"
  curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.8.5 "$_py" -
  unset _py
  ok "poetry 1.8.5"
fi

# =============================================================
# 12. NEOVIM NODE PROVIDER
# neovim npm package: node provider required by some nvim plugins.
# Installed via npm directly — no need for pnpm on Mac.
# =============================================================
if npm list -g neovim &>/dev/null 2>&1; then
  skip "npm: neovim"
else
  log "Installing npm global: neovim..."
  npm install -g neovim && ok "npm: neovim"
fi

# =============================================================
# 13. RUST (required by idig-broker to build the apic2gw native module)
# Uses rustup — the standard Rust toolchain installer.
# =============================================================
# Source cargo env first so 'command -v rustc' works on re-runs
# even before the shell config (platform/darwin.sh) is stowed.
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

if command -v rustc &>/dev/null; then
  skip "rust"
else
  log "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
  ok "rust ($(rustc --version))"
fi

# =============================================================
# 14. DOTFILES — stow
# Stow must run before TPM so ~/.tmux.conf is in place before
# TPM tries to read TMUX_PLUGIN_MANAGER_PATH from it.
# =============================================================
if [ ! -d "$DOTFILES_DIR" ]; then
  err "Dotfiles not found at $DOTFILES_DIR — clone them first:\n  git clone https://github.ibm.com/Al-Ameen-Adedeji/dotfiles-ibm.git ~/dotfiles-ibm"
fi

log "Stowing dotfiles..."
cd "$DOTFILES_DIR"

BACKUP_DIR="$HOME/.backups/dotfiles-$(date +%Y%m%d_%H%M%S)"

# backup_if_real — if the path exists as a real file (not a symlink),
# move it into ~/.backups before stow creates a symlink there.
# Symlinks are left alone so re-running the script is safe.
backup_if_real() {
  local target="$HOME/$1"
  [ -e "$target" ] && [ ! -L "$target" ] || return 0
  mkdir -p "$BACKUP_DIR/$(dirname "$1")"
  mv "$target" "$BACKUP_DIR/$1" && log "Backed up $target"
}

# Back up every file stow will replace — explicit list is easier to
# reason about than parsing stow's simulate output.
# Add a line here whenever a new stow module introduces a new target.
backup_if_real ".bashrc"
backup_if_real ".bash_profile"
backup_if_real ".zshrc"
backup_if_real ".zprofile"
backup_if_real ".config/shell"
backup_if_real ".config/starship.toml"
backup_if_real ".config/nvim"
backup_if_real ".config/ghostty"
backup_if_real ".tmux.conf"
backup_if_real ".hammerspoon/init.lua"

for mod in shell bash zsh starship nvim tmux ghostty hammerspoon; do
  stow "$mod" && ok "stowed: $mod"
done

[ -d "$BACKUP_DIR" ] && log "Pre-existing configs backed up to $BACKUP_DIR" || true

# =============================================================
# 15. TMUX PLUGIN MANAGER (TPM)
# Runs after stow so ~/.tmux.conf (with TMUX_PLUGIN_MANAGER_PATH)
# is already in place.
# =============================================================
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  skip "tpm"
else
  log "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  ok "tpm"
fi

log "Installing tmux plugins via TPM..."
tmux new-session -d -s tpm-install 2>/dev/null || true
"$TPM_DIR/bin/install_plugins" && ok "tmux plugins"
tmux kill-session -t tpm-install 2>/dev/null || true

# #############################################################
# DONE
# #############################################################
echo ""
echo -e "\e[32m=== Bootstrap complete ===\e[0m"
echo "  • Open a new terminal window to pick up zsh + all PATH changes"
echo "  • If Ghostty's font looks wrong, ensure 'JetBrainsMono Nerd Font' is selected in its config"
echo "  • To set Ghostty as default terminal: open Ghostty → Settings → General → 'Make Default Terminal'"
echo "  •   or: System Settings → Desktop & Dock → Default terminal app → Ghostty"
echo "  • Open Rancher Desktop once and follow the setup wizard before using docker/kubectl"
echo "  • Work secrets (VELOX_*, API keys) → ~/.config/shell/work.sh  (never commit this file)"
