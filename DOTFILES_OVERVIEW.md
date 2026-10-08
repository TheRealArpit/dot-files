# Dotfiles and System Knowledge Base

Comprehensive overview of this repository, environment setup, architecture, and recent modifications for agent handoff.

---

## 1. Git Repository and Remotes

- **Local Working Branch:** `mirdha/setup`
- **Primary Origin (IBM GitHub Enterprise):** `git@github.ibm.com:Al-Ameen-Adedeji/dotfiles-ibm.git`
- **Personal Remote (GitHub):** `git@github.com:TheRealArpit/dot-files.git`
- **Tracking / Base Branch:** `origin/main` / `personal/mirdha/setup`
- **Workspace Directory:** `/Users/mirdha/Documents/dotfiles-ibm`

---

## 2. Directory Structure and Modules

Managed using [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory corresponds to a stowable package linked directly into `$HOME`:

```
dotfiles-ibm/
├── bash/             # Bash profiles and helper CLI scripts
│   ├── .bashrc
│   ├── .bash_profile
│   └── .local/bin/
│       ├── open-in-nvim       # Intelligent file:line opener
│       ├── tmux-open-path     # Fzf extractor for terminal paths
│       └── tmux-sessionizer   # Project directory session jumper
├── zsh/              # Zsh interactive configuration
│   ├── .zshrc
│   └── .config/zsh/completions/
├── shell/            # Shared shell layer (Bash & Zsh compatible)
│   └── .config/shell/
│       ├── exports.sh         # Core environment variables & EDITOR
│       ├── paths.sh           # PATH assembly helper
│       ├── platform.sh        # OS detection (macOS / Linux)
│       ├── aliases.sh         # General, Git, Kubernetes aliases
│       ├── functions.sh       # ta, tk, tnew, dothelp, kube switchers
│       ├── tools.sh           # starship, zoxide, fzf integration
│       └── docs/              # Markdown cheatsheets used by dothelp
│           ├── tmux.md
│           ├── nvim.md
│           ├── shell.md
│           ├── git.md
│           └── k8s.md
├── tmux/             # Terminal multiplexer configuration
│   └── .tmux.conf             # Catppuccin Mocha theme & tmux 3.4+ config
├── nvim/             # Neovim configuration (lazy.nvim)
│   └── .config/nvim/
│       ├── init.lua
│       └── lua/
│           ├── config/        # keymaps, options, autocmds
│           └── plugins/       # oil, telescope, treesitter, etc.
├── ghostty/          # Ghostty terminal emulator configuration
│   └── .config/ghostty/config
├── starship/         # Starship cross-shell prompt
└── install.sh        # Dotfiles bootstrap and stow automation
```

---

## 3. Core Environment and Key Conventions

| Component | Choice / Standard | Details |
| :--- | :--- | :--- |
| **OS** | macOS Darwin (arm64) | Apple Silicon (`/opt/homebrew`) |
| **Primary Shell** | Zsh | Interactive default shell |
| **Terminal** | Ghostty | Catppuccin Mocha theme, JetBrainsMono Nerd Font |
| **Multiplexer** | Tmux | Prefix key: `Ctrl+S`, vi mode keys |
| **Editor** | Neovim (`nvim`) | `$EDITOR` and `$VISUAL` set to `nvim` |
| **Default K8s NS** | `idig-system` (via `KUBE_NAMESPACE`) | Aliased with `k=kubectl` |

---

## 4. Key Workflows and Shortcuts

### Tmux Navigation and Panes
- **Prefix:** `Ctrl+S` (`unbind C-b; set -g prefix C-s`)
- **Vertical Split (side-by-side):** `<prefix> v`
- **Horizontal Split (stacked):** `<prefix> h`
- **Seamless Vim/Tmux Navigation:** `Ctrl+h`, `Ctrl+j`, `Ctrl+k`, `Ctrl+l` (without prefix)
- **Session Tree Switcher:** `<prefix> s`
- **Floating Sessionizer Popup:** `<prefix> f`

### Terminal Buffer and File Navigation (Recent Additions)
- **Edit Scrollback in Neovim Popup:** Press `<prefix> Enter` (`Ctrl+S` then `Enter`) to capture up to 3000 lines of pane history directly into Neovim inside a floating popup.
- **Path Picker (`<prefix> o`):** In any pane inside tmux, press `<prefix> o` to extract all visible file paths into an interactive `fzf` picker. Hitting `Enter` opens the selected file (and line number) in Neovim on the right.
- **Double-Click on File Path:** Double-clicking on any path (e.g. `tmux/.tmux.conf:52`) passes it to [`bash/.local/bin/open-in-nvim`](bash/.local/bin/open-in-nvim:1), which reuses an nvim pane in the window or splits one to the right. URLs open in the browser.
- **Copy Mode Opener:** In tmux copy mode (`<prefix> [`), navigate over any path and press `o` to open in Neovim.

### Shell Aliases
- `kn`: Expands to `kubectl -n ${KUBE_NAMESPACE}` (e.g. `kn get pods`).
- `t`: Attach to last tmux session or start a new one.
- `tls`: List active tmux sessions.
- `ta`: Fuzzy search active sessions to attach, switch, or kill (`Ctrl+X`).
- `dothelp`: Interactive cheatsheet browser with live preview (`dothelp tmux`, `dothelp nvim`, etc.).

---

## 5. Summary of Recent Changes

1. **Terminal Scrollback in Neovim:**
   Configured `<prefix> Enter` in [`tmux/.tmux.conf`](tmux/.tmux.conf:112) to dump terminal history to a temporary buffer and launch Neovim in a popup.

2. **Split Keybindings Alignment:**
   Updated horizontal split to `<prefix> h` and restored `<prefix> s` for tmux session switching. Synchronized cheatsheet in [`shell/.config/shell/docs/tmux.md`](shell/.config/shell/docs/tmux.md:5).

3. **Kubectl Namespace Alias (`kn`):**
   Updated `kn` in [`shell/.config/shell/aliases.sh`](shell/.config/shell/aliases.sh:29) to dynamically target `${KUBE_NAMESPACE}`.

4. **Terminal Path Opening Tooling:**
   - Created [`bash/.local/bin/tmux-open-path`](bash/.local/bin/tmux-open-path:1) for fast regex extraction of file paths with `fzf`.
   - Updated [`bash/.local/bin/open-in-nvim`](bash/.local/bin/open-in-nvim:1) to resolve relative paths against active pane directories, handle `file:line:col` formats, and open targets in a side-by-side tmux pane (`tmux split-window -h -b`).
   - Added `<prefix> o` path picker and double-click piping in [`tmux/.tmux.conf`](tmux/.tmux.conf:122).
   - Added `stty -ixon` to [`zsh/.zshrc`](zsh/.zshrc:5) to prevent terminal TTY driver freeze on `Ctrl+S`.
   - Enabled OSC 8 hyperlinks and terminal passthrough in [`tmux/.tmux.conf`](tmux/.tmux.conf:36).
   - Cleaned unsupported configuration keys from [`ghostty/.config/ghostty/config`](ghostty/.config/ghostty/config:17).
