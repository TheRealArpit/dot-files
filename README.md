# dotfiles-ibm

Development environment dotfiles for IBM API Connect engineering.
Managed with [GNU Stow](https://www.gnu.org/software/stow/) — symlinks everything into place from a single repo clone.

---

## Quick setup

### macOS

```bash
git clone https://github.ibm.com/Al-Ameen-Adedeji/dotfiles-ibm.git ~/dotfiles-ibm
cd ~/dotfiles-ibm
bash install-mac.sh
```

### Linux (Fedora / Arch)

```bash
git clone https://github.ibm.com/Al-Ameen-Adedeji/dotfiles-ibm.git ~/dotfiles-ibm
cd ~/dotfiles-ibm
bash install.sh
```

---

## What's included

### Shell — Zsh interactive, Bash compatible
- Zsh as the default interactive shell; Bash remains fully functional for scripts and SSH
- Shared config layer in `~/.config/shell`: exports, paths, aliases, functions, tools, OS detection
- fzf wired to fd as backend + bat for file preview (`Ctrl+T`, `Ctrl+R`, `Alt+C`)
- zoxide for smart directory jumping (`z` instead of `cd`)
- vivid for Catppuccin Mocha `LS_COLORS`
- NVM sourced at shell start
- **tmux-sessionizer** — `Ctrl+F` / `ta` — fzf over project dirs, create/switch named sessions

### Prompt — Starship
- Two-line layout with Catppuccin Mocha palette
- Shows: `user@host ❯ path on branch status duration exitcode`
- Auto-detects Python venv, Node, Rust, Docker context when relevant
- Hostname turns red over SSH; root turns red — visual danger signals

### Neovim
- Full IDE layer: LSP, treesitter, DAP debugging, formatting, git integration
- Plugin manager: lazy.nvim (auto-installs on first launch)
- Key plugins: telescope, oil, harpoon, blink.cmp, conform, gitsigns, which-key
- DAP (debugger): Python via debugpy, JS/Node via js-debug-adapter

### Tmux
- Prefix: `Ctrl+A`
- TPM plugin manager with: sensible, resurrect, continuum, yank
- Seamless nvim/tmux pane navigation via `Ctrl+h/j/k/l`
- Session persistence across reboots (resurrect + continuum)

---

## CLI tool stack

| Tool | Replaces | Purpose |
|------|----------|---------|
| `eza` | `ls` | File listing with icons, git status, directory-first |
| `bat` | `cat` | Syntax highlighted file viewing |
| `fd` | `find` | Fast file finding, respects .gitignore |
| `ripgrep` (`rg`) | `grep` | Fast recursive code search |
| `fzf` | — | Fuzzy finder — `Ctrl+R` history, `Ctrl+T` files, `Alt+C` dirs |
| `zoxide` | `cd` | Smart directory jumping with memory |
| `lazygit` | — | Terminal UI for git |
| `lazydocker` | — | Terminal UI for container management |
| `btop` | `htop` | System monitoring |
| `starship` | PS1 | Cross-shell prompt |
| `vivid` | — | Catppuccin Mocha LS_COLORS generator |
| `jq` | — | JSON processor — query, filter, transform JSON |

---

## Developer tooling

### Node — NVM
```bash
nvm install --lts     # install latest LTS
nvm use 24            # switch to v24 (apim-ci standard)
nvm ls                # list installed versions
```

### Python — Poetry
```bash
poetry new my-project       # scaffold a new project
poetry install              # install deps from pyproject.toml
poetry run python app.py    # run inside the virtualenv
poetry shell                # activate the virtualenv
```

### Containers — Rancher Desktop (macOS) / Podman (Linux)
IBM does not permit Docker Desktop. Use one of:
- **macOS**: Rancher Desktop (installed by `install-mac.sh`) — provides a `docker`-compatible CLI
- **Linux**: Podman + podman-docker shim (installed by `install.sh`) — `docker` commands route through Podman transparently

### PostgreSQL
Runs as a container on port 5432 (started by the install script):
```bash
docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:15.4
```
Credentials: `postgres` / `password` — local dev only.

---

## Stow structure

```
dotfiles-ibm/
├── shell/      # shared shell layer (exports, paths, aliases, functions, tools, platform)
├── bash/       # .bashrc, .bash_profile, tmux-sessionizer
├── zsh/        # .zshrc, .zprofile
├── starship/   # starship.toml
├── nvim/       # full Neovim config (lazy.nvim, LSP, DAP, treesitter)
├── tmux/       # .tmux.conf (TPM, catppuccin statusbar, sessionizer binding)
├── ghostty/    # ghostty terminal config + catppuccin-mocha theme
├── install.sh      # Linux bootstrap (Fedora / Arch)
└── install-mac.sh  # macOS bootstrap
```

To restow after pulling changes:
```bash
cd ~/dotfiles-ibm
stow -R shell bash zsh starship nvim tmux ghostty
```

---

## Work secrets

Work-specific environment variables (API keys, tokens, `VELOX_*` vars) go in:

```
~/.config/shell/work.sh
```

This file is sourced automatically by the shell but is **never committed** — add it manually on each machine.

Example:
```bash
# ~/.config/shell/work.sh
export VELOX_DEVELOPMENT=true
export ARTIFACTORY_TOKEN=...
```

---

## Troubleshooting

### Symlinks broken after OS update
```bash
cd ~/dotfiles-ibm && stow -R shell bash zsh starship nvim tmux ghostty
```

### Ghostty not the default terminal
macOS does not expose a URI scheme that tools like `duti` can target for terminals.
Set Ghostty as default manually — either option works:
- **Ghostty**: Settings → General → "Make Default Terminal"
- **System Settings** (Sonoma+): Desktop & Dock → Default terminal app → Ghostty

### Icons look broken / boxes instead of glyphs
This config uses Nerd Font icons throughout — in Neovim (LSP diagnostics, completion
kinds, file icons), Tmux (status bar), and Starship (prompt symbols). A Nerd Font
**must** be active in your terminal or everything will render as `?` boxes.

The bootstrap scripts install JetBrains Mono Nerd Font automatically:
- **macOS**: installed via `brew install --cask font-jetbrains-mono-nerd-font`, set in Ghostty config automatically
- **Linux**: installed to `~/.local/share/fonts/`, set in Ghostty config automatically

If you're using a terminal other than Ghostty, you need to set the font manually:
- **GNOME Terminal**: Preferences → your profile → Text → Custom font → `JetBrainsMono Nerd Font`
- **Konsole**: Settings → Edit Current Profile → Appearance → Font → `JetBrainsMono Nerd Font`
- **Any other terminal**: look for font settings and select `JetBrainsMono Nerd Font Mono`

If the font isn't installed at all:
```bash
# macOS
brew install --cask font-jetbrains-mono-nerd-font

# Linux
mkdir -p ~/.local/share/fonts
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" -O /tmp/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -f
rm /tmp/JetBrainsMono.zip
```

### Starship not rendering correctly
```bash
tail -3 ~/.zshrc ~/.bashrc       # confirm starship init is present
echo $TERM                        # should be xterm-256color or similar
```

### fzf not finding files
```bash
echo $FZF_DEFAULT_COMMAND         # should reference fd or fdfind
which fd fdfind                   # confirm fd is installed
```

### Poetry command not found after install
```bash
# macOS (brew install): should already be on PATH via Homebrew
brew list poetry

# Linux (curl installer): add to PATH
export PATH="$HOME/.local/bin:$PATH"
```
