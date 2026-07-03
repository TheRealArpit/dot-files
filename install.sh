#!/usr/bin/env bash
# =============================================================
# install.sh — dotfiles-ibm bootstrap
# Works on: Fedora 42+ KDE, Arch Linux
# Usage: bash install.sh
# Note: On Mac use install-mac.sh instead.
# =============================================================

set -e  # exit on any error
DOTFILES_DIR="$HOME/dotfiles-ibm"
# colours for output
OK="\e[32m✓\e[0m"
SKIP="\e[33m~\e[0m"
ERR="\e[31m✗\e[0m"
INFO="\e[34m→\e[0m"

log()  { echo -e "$INFO  $1"; }
ok()   { echo -e "$OK  $1"; }
skip() { echo -e "$SKIP  $1 (already installed)"; }
err()  { echo -e "$ERR  $1"; exit 1; }

# install_tarball <name> <url> <path/to/binary/inside/tar>
# Downloads a .tar.gz, extracts it, installs the binary to /usr/local/bin, cleans up.
install_tarball() {
  local name="$1" url="$2" bin_path="$3"
  local tmp="/tmp/${name}_install"
  wget -q "$url" -O "${tmp}.tar.gz"
  mkdir -p "$tmp"
  tar -xzf "${tmp}.tar.gz" -C "$tmp"
  sudo install -m 755 "$tmp/$bin_path" /usr/local/bin/"$(basename "$bin_path")"
  rm -rf "${tmp}.tar.gz" "$tmp"
}

# sparse_clone <url> <dest_dir> <sparse_path>
# Shallow-clones only the specified subdirectory of a repo.
sparse_clone() {
  local url="$1" dir="$2" path="$3"
  git clone --depth=1 --filter=blob:none --sparse "$url" "$dir"
  git -C "$dir" sparse-checkout set "$path"
}

# =============================================================
# DISTRO DETECTION
# =============================================================
# shellcheck source=/dev/null
. /etc/os-release
DISTRO="$ID"   # fedora | arch

# install_pkg — wraps the distro package manager
install_pkg() {
  case "$DISTRO" in
    fedora) sudo dnf install -y "$@" ;;
    arch)   sudo pacman -S --noconfirm "$@" ;;
    *)      err "Unsupported distro: $DISTRO (supported: fedora, arch)" ;;
  esac
}

# is_pkg_installed <name> — 0 if installed, 1 if not
is_pkg_installed() {
  case "$DISTRO" in
    fedora) rpm -q "$1" &>/dev/null ;;
    arch)   pacman -Q "$1" &>/dev/null ;;
  esac
}

# pkg_map <name> — resolves cross-distro package name differences
pkg_map() {
  case "$1:$DISTRO" in
    fd-find:arch)               echo "fd" ;;
    java-21-openjdk-devel:arch) echo "jdk21-openjdk" ;;
    postgresql-client:arch)     echo "postgresql" ;;
    *)                          echo "$1" ;;
  esac
}

# =============================================================
# 1. SYSTEM UPDATE
# =============================================================
log "Updating system packages..."
case "$DISTRO" in
  fedora) sudo dnf upgrade -y --refresh -q ;;
  arch)   sudo pacman -Syu --noconfirm ;;
esac

# =============================================================
# 2. ADDITIONAL REPOS (must run before package install)
# =============================================================
if [[ "$DISTRO" == "fedora" ]]; then
  if ! dnf repolist enabled 2>/dev/null | grep -q 'atim/lazygit'; then
    log "Enabling COPR: atim/lazygit..."
    sudo dnf copr enable atim/lazygit -y
  else
    skip "copr: atim/lazygit"
  fi
fi

# =============================================================
# 3. PACKAGES
# =============================================================
PACKAGES=(
  # modern cli replacements
  eza           # ls with icons, git status, directory-first
  fd-find       # fast find that respects .gitignore (mapped → fd on Arch)
  ripgrep       # fast recursive grep
  bat           # cat with syntax highlighting
  fzf           # fuzzy finder — wired to Ctrl+R, Ctrl+T, Alt+C in shell config
  zoxide        # smart cd with memory (use z instead of cd)
  lazygit       # terminal UI for git
  lazydocker    # terminal UI for managing containers, images, logs
  btop          # system monitor — CPU, memory, network, disk
  jq            # JSON processor — query and transform JSON from the command line
  # shell + dev essentials
  git
  curl          # used by most install scripts (nvm, starship, poetry)
  wget          # used for binary/tarball downloads
  unzip
  make
  gcc
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  # terminal utilities
  wl-clipboard  # wl-copy / wl-paste for Wayland clipboard access
  # stow for dotfiles
  stow
  # editor
  neovim
  # multiplexer
  tmux
)

log "Installing packages..."
for pkg in "${PACKAGES[@]}"; do
  actual=$(pkg_map "$pkg")
  [ -z "$actual" ] && continue
  if is_pkg_installed "$actual"; then
    skip "$actual"
  else
    install_pkg "$actual" && ok "$actual"
  fi
done

# =============================================================
# 4. ZSH — set as default interactive shell
# Keep scripts explicitly Bash (#!/usr/bin/env bash) but use Zsh interactively.
# Set SET_DEFAULT_SHELL=0 to leave $SHELL unchanged.
# =============================================================
# (section numbering continues from packages above)
# =============================================================
if command -v zsh &>/dev/null; then
  ZSH_PATH="$(command -v zsh)"

  if ! grep -qxF "$ZSH_PATH" /etc/shells; then
    log "Registering zsh as a valid login shell..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "${SET_DEFAULT_SHELL:-1}" == "1" ]]; then
    if [[ "$SHELL" != "$ZSH_PATH" ]]; then
      log "Setting zsh as default shell (takes effect on next login)..."
      chsh -s "$ZSH_PATH" && ok "default shell -> zsh"
    else
      ok "zsh already default shell"
    fi
  else
    log "Skipping default shell change (SET_DEFAULT_SHELL=0)"
  fi
fi

# =============================================================
# 5. PODMAN (IBM APIConnect standard container runtime)
# podman-docker provides a drop-in docker CLI shim so any tooling
# that calls `docker` transparently routes through Podman.
# =============================================================
if command -v podman &>/dev/null; then
  skip "podman"
else
  log "Installing Podman..."
  case "$DISTRO" in
    fedora) install_pkg podman podman-compose podman-docker ;;
    arch)   install_pkg podman podman-compose ;;
  esac
  ok "podman (docker CLI shim active via podman-docker)"
fi

# =============================================================
# 6. JAVA 21 + MAVEN
# =============================================================
if is_pkg_installed "$(pkg_map java-21-openjdk-devel)"; then
  skip "java 21 + maven"
else
  log "Installing Java 21 + Maven..."
  install_pkg "$(pkg_map java-21-openjdk-devel)" maven
  ok "java 21 + maven"
fi

# =============================================================
# 7. STARSHIP PROMPT
# =============================================================
if command -v starship &>/dev/null; then
  skip "starship"
else
  log "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  ok "starship"
fi

# =============================================================
# 8. POETRY (Python dependency manager)
# Enterprise standard — manages virtualenvs and pyproject.toml deps.
# =============================================================
if command -v poetry &>/dev/null; then
  skip "poetry"
else
  log "Installing poetry..."
  curl -sSL https://install.python-poetry.org | python3 -
  ok "poetry"
fi

# =============================================================
# 9. VIVID (LS_COLORS)
# Generates LS_COLORS from a named theme — wired to $THEME in exports.sh.
# =============================================================
if command -v vivid &>/dev/null; then
  skip "vivid"
else
  log "Installing vivid..."
  VIVID_VERSION="0.11.1"
  install_tarball vivid \
    "https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid-v${VIVID_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
    "vivid-v${VIVID_VERSION}-x86_64-unknown-linux-gnu/vivid"
  ok "vivid"
fi

# =============================================================
# 10. NVM + NODE
# =============================================================
if [ -d "$HOME/.nvm" ]; then
  skip "nvm"
else
  log "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install 24
  nvm alias default 24
  ok "nvm + node 24"
fi

# =============================================================
# 11. NPM GLOBALS (neovim, tree-sitter-cli)
# neovim: node provider required by some nvim plugins
# tree-sitter-cli: compiles language parsers for nvim-treesitter
# =============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

for pkg in neovim tree-sitter-cli; do
  if npm list -g "$pkg" &>/dev/null 2>&1; then
    skip "npm: $pkg"
  else
    log "Installing npm global: $pkg..."
    npm install -g "$pkg" && ok "npm: $pkg"
  fi
done

# =============================================================
# 12. GIT-DELTA (diff pager)
# Replaces the default git diff output with syntax highlighting,
# line numbers, and side-by-side view.
# =============================================================
if command -v delta &>/dev/null; then
  skip "git-delta"
else
  log "Installing git-delta..."
  DELTA_VERSION="0.19.2"
  install_tarball delta \
    "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
    "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta"
  ok "git-delta"
fi
# Wire delta into git (idempotent)
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictstyle diff3

# =============================================================
# 15. FONTS — JetBrains Mono Nerd Font
# =============================================================
FONT_DIR="$HOME/.local/share/fonts"
if fc-list | grep -qi "JetBrainsMono"; then
  skip "JetBrains Mono Nerd Font"
else
  log "Installing JetBrains Mono Nerd Font..."
  mkdir -p "$FONT_DIR"
  wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" \
    -O /tmp/JetBrainsMono.zip
  unzip -q /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
  fc-cache -fv &>/dev/null
  rm /tmp/JetBrainsMono.zip
  ok "JetBrains Mono Nerd Font"
fi

# =============================================================
# 16. DOTFILES — stow
# =============================================================
if [ ! -d "$DOTFILES_DIR" ]; then
  err "Dotfiles not found at $DOTFILES_DIR — clone them first:\n  git clone https://github.ibm.com/Al-Ameen-Adedeji/dotfiles-ibm.git ~/dotfiles-ibm"
fi

log "Stowing dotfiles..."
cd "$DOTFILES_DIR"

BACKUP_DIR="$HOME/.backups/dotfiles-$(date +%Y%m%d_%H%M%S)"

# backup_conflict — moves any real file that would block stow into ~/.backups.
# Existing symlinks are left alone so re-running the script is idempotent.
backup_conflict() {
  local target="$1"
  [ -e "$target" ] || [ -L "$target" ] || return 0
  [ -L "$target" ] && return 0
  mkdir -p "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
  mv "$target" "$BACKUP_DIR/${target#$HOME/}" && log "Backed up $target"
}

backup_conflict "$HOME/.bashrc"
backup_conflict "$HOME/.zshrc"
backup_conflict "$HOME/.zprofile"
backup_conflict "$HOME/.config/shell"
backup_conflict "$HOME/.config/starship.toml"
backup_conflict "$HOME/.config/nvim"
backup_conflict "$HOME/.config/ghostty"

stow shell bash zsh starship nvim tmux ghostty
ok "dotfiles stowed"
[ -d "$BACKUP_DIR" ] && log "Pre-existing configs backed up to $BACKUP_DIR" || true

# =============================================================
# 17. TMUX PLUGIN MANAGER (TPM)
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

# =============================================================
# 18. POSTGRESQL CLIENT + CONTAINER (matches apim-ci dev setup)
# The client package provides psql, pg_dump etc. for local use.
# The server runs as postgres:15.4 container on port 5432 via
# Podman (podman-docker shim routes docker commands transparently).
# Credentials: postgres / password  (dev only — never use in prod)
#
# To run natively instead of as a container:
#   Fedora: sudo dnf install postgresql postgresql-server
#           sudo postgresql-setup --initdb
#           sudo systemctl enable --now postgresql
#   Arch:   sudo pacman -S postgresql
#           sudo -u postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data
#           sudo systemctl enable --now postgresql
# =============================================================
log "Installing PostgreSQL client tools..."
case "$DISTRO" in
  fedora) install_pkg postgresql ;;
  arch)   install_pkg "$(pkg_map postgresql-client)" ;;
esac

if docker ps -a --format "{{.Names}}" 2>/dev/null | grep -q "^postgres$"; then
  skip "postgres container"
else
  log "Starting postgres:15.4 container..."
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
# 23. GHOSTTY (terminal emulator)
# Available in official Fedora 42+ and Arch repos — no COPR needed.
# =============================================================
if command -v ghostty &>/dev/null; then
  skip "ghostty"
else
  log "Installing Ghostty..."
  install_pkg ghostty
  ok "ghostty"
fi

# =============================================================
# DONE
# =============================================================
echo ""
echo -e "\e[32m╔══════════════════════════════════════╗\e[0m"
echo -e "\e[32m║       Bootstrap complete!            ║\e[0m"
echo -e "\e[32m╚══════════════════════════════════════╝\e[0m"
echo ""
echo "Manual steps:"
echo "  1. Log out and back in  (group memberships take effect)"
echo "  2. Open a new terminal  (zsh default shell takes effect after login)"
echo "  3. Open nvim            (lazy.nvim auto-installs plugins on first launch)"
echo ""
echo "Work secrets (API keys, tokens) → ~/.config/shell/work.sh  (never commit this file)"
echo ""
