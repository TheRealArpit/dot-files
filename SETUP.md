# My Development Setup

Personal dotfiles for IBM API Connect engineering work.
Managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## System Overview

| Layer           | Tool / Config                                   |
| --------------- | ----------------------------------------------- |
| OS              | macOS (primary), Fedora / Arch Linux (secondary) |
| Shell           | Zsh (interactive), Bash (scripts / SSH)         |
| Terminal        | Ghostty                                         |
| Multiplexer     | Tmux (prefix `Ctrl+S`)                          |
| Editor          | Neovim (lazy.nvim)                              |
| Prompt          | Starship                                        |
| Window manager  | Rectangle + Hammerspoon                         |
| Containers      | Rancher Desktop (macOS), Podman (Linux)         |
| Font            | JetBrainsMono Nerd Font 13pt                    |
| Theme           | Catppuccin Mocha (everywhere)                   |

---

## Terminal — Ghostty

Config: [`ghostty/.config/ghostty/config`](ghostty/.config/ghostty/config)

- Theme: Catppuccin Mocha (built-in)
- Font: JetBrainsMono Nerd Font, 13pt
- Window padding 8px each side
- Pure black background (`#000000`), opacity `1.0` (no transparency)
- Shell integration: `detect` (auto-detects Zsh/Bash)
- Mouse hides while typing
- Copy-on-select off, no close confirmation

---

## Shell

### Layout

All interactive logic lives in a shared layer at `~/.config/shell/`,
sourced by both Zsh and Bash:

```
~/.config/shell/
├── exports.sh    — environment variables
├── paths.sh      — PATH management (path_prepend helper)
├── platform.sh   — OS detection (sources darwin.sh / linux.sh)
├── aliases.sh    — all aliases
├── functions.sh  — shell functions (ta, explore)
├── tools.sh      — fzf, zoxide, nvm, vivid, starship
└── work.sh       — secrets (not committed; see work.sh.example)
```

Entry points: [`zsh/.zshrc`](zsh/.zshrc) and [`bash/.bashrc`](bash/.bashrc).

### Zsh features

- History: 10 000 in memory, 20 000 on disk, shared across sessions
- `hist_ignore_dups`, `hist_ignore_space`, `share_history`, `auto_cd`
- Completions cached in `~/.cache/zsh/zcompdump`
- Case-insensitive tab completion (`m:{a-zA-Z}={A-Za-z}`)
- **zsh-autosuggestions**: `Alt+l` accept full suggestion, `Alt+k` accept next word
- **zsh-syntax-highlighting**: live command colouring as you type

### Bash features

- `stty -ixon` — disables `Ctrl+S`/`Ctrl+Q` flow control freeze (required for
  tmux prefix `Ctrl+S`)
- History search on `↑`/`↓`
- Starship + zoxide both initialised

### PATH

Managed in [`paths.sh`](shell/.config/shell/paths.sh) via `path_prepend()`
which skips duplicates and non-existent directories. On macOS, GNU userland
binaries (coreutils, findutils, gnu-sed, gawk, grep) prepend the Homebrew
prefix via [`darwin.sh`](shell/.config/shell/platform/darwin.sh) — avoids
running `brew --prefix` subprocess on every shell start by hardcoding the
prefix at `/opt/homebrew` or `/usr/local`.

### Key aliases

| Alias          | Expands to / purpose                               |
| -------------- | -------------------------------------------------- |
| `k`            | `kubectl`                                          |
| `t`            | `tmux attach \|\| tmux`                            |
| `lg`           | `lazygit`                                          |
| `ld`           | `lazydocker`                                       |
| `bp`           | `nvim ~/.zshrc`                                    |
| `sp`           | `source ~/.zshrc`                                  |
| `velox`        | `cd $VELOX` (or `~/apic`)                          |
| `idig`         | `cd $VELOX/idig-broker`                            |
| `config`       | `explore ~/dotfiles-ibm/shell/.config/shell`       |
| `ls`           | `eza --icons=auto --group-directories-first`       |
| `ll`           | `eza -la --icons --git --header`                   |
| `lt`           | `eza --tree --level=2 --git-ignore`                |
| `cat`          | `bat` / `batcat`                                   |
| `search`       | `rg --color=always --line-number --smart-case`     |
| `aliases`      | list all aliases from `aliases.sh`                 |
| `gl`           | pretty git log graph (last 20)                     |
| `gla`          | same but `--all` branches                          |
| `gclean`       | prune remote + delete merged local branches        |
| `fyre-create`  | one-shot Fyre stack provisioning command           |

### Shell functions

**`ta`** — tmux session manager
([`functions.sh`](shell/.config/shell/functions.sh))

```
ta              fzf over active session names; attach/switch or create new
ta myproject    jump directly to named session
Ctrl+X (fzf)    kill highlighted session
```

Uses `--print-query` so typing a name that doesn't match any session creates
it. Sanitises the session name (strips special chars). Inside tmux uses
`switch-client`; outside uses `new-session -As`.

**`explore`** — cd + open Neovim with oil.nvim

```
explore ~/apic/idig-broker   open oil in that directory
explore                      open oil in current directory
```

---

## Tmux

Config: [`tmux/.tmux.conf`](tmux/.tmux.conf)

### Core settings

- Prefix: `Ctrl+S` (flow control disabled in `.bashrc` via `stty -ixon`)
- Base index: 1 (windows and panes), auto-renumber on close
- History limit: 50 000 lines
- Mouse on (scroll wheel enters copy mode)
- Login shell: `/opt/homebrew/bin/zsh -l` (hardcoded — avoids `$SHELL`
  being empty when tmux server starts via launchd on macOS)
- True colour: RGB + Tc overrides for WezTerm compatibility
- Extended keys on (lets Neovim see `Ctrl+Enter`, `Shift+Tab`)

### Keybindings

| Key                 | Action                                         |
| ------------------- | ---------------------------------------------- |
| `<prefix>v`         | Split vertically (current path)                |
| `<prefix>h`         | Split horizontally (current path)              |
| `<prefix>c`         | New window (current path)                      |
| `<prefix>n`         | Rename window (locks auto-rename)              |
| `<prefix>[` / `]`   | Previous / next window                         |
| `<prefix>s`         | Session tree picker                            |
| `<prefix>f`         | tmux-sessionizer (floating fzf popup)          |
| `<prefix>R`         | Enter resize mode; HJKL resize, Esc/Enter exit |
| `<prefix><` / `>`   | Swap pane with previous / next                 |
| `<prefix>x` / `X`  | Kill pane / window (no confirmation)           |
| `Ctrl+h/j/k/l`      | Navigate panes (passes through to Neovim)      |
| `<prefix>H/J/K/L`   | Navigate panes (prefix-bound, uppercase)       |
| `<prefix>r`         | Reload tmux.conf                               |
| `<prefix>Enter`     | Enter copy mode (vi keys)                      |
| `v` (copy mode)     | Begin selection                                |
| `y` (copy mode)     | Copy to clipboard (`pbcopy` / `wl-copy`)       |

### Plugins (TPM)

| Plugin            | Purpose                                          |
| ----------------- | ------------------------------------------------ |
| tmux-sensible     | Sane defaults                                    |
| tmux-resurrect    | Persist sessions across reboot                   |
| tmux-continuum    | Auto-save every 15 min, auto-restore on start    |
| tmux-yank         | Clipboard integration                            |

Resurrect saves Neovim sessions via `nvim -S`.
Session data in `~/.tmux/resurrect/` (local only, never transmitted).

### tmux-sessionizer

Script: [`bash/.local/bin/tmux-sessionizer`](bash/.local/bin/tmux-sessionizer)
Bound to `<prefix>f` as a floating popup (55% wide, 45% tall, rounded border,
mauve accent). The popup explicitly invokes `/opt/homebrew/bin/zsh -l -c
tmux-sessionizer` to ensure a login shell with the full PATH.

- Lists active sessions (tagged with path) + all dirs under `$HOME` depth 4
  (`fd`, excludes `.git`, `node_modules`, `Library`, `.cache`)
- Active session paths are deduplicated — no double entries
- fzf preview: git log for repos, `ls` for plain dirs
- `X` in fzf kills the highlighted session (switches away first if current)
- Derives clean session name from directory `basename`

---

## Neovim

Config: [`nvim/.config/nvim/`](nvim/.config/nvim/)
Plugin manager: lazy.nvim (auto-installs on first launch)

### Colour / appearance

Pure black background (`#000000`) applied to `Normal`, `NormalNC`,
`NormalFloat`, and `SignColumn` via catppuccin `custom_highlights` — matches
the Ghostty terminal background precisely.

### Key plugins

| Plugin                       | Purpose                                        |
| ---------------------------- | ---------------------------------------------- |
| telescope.nvim               | Fuzzy finding: files, grep, buffers, LSP       |
| oil.nvim                     | File browser as an editable buffer             |
| harpoon                      | Per-project file bookmarks                     |
| blink.cmp                    | Completion engine                              |
| nvim-lspconfig               | LSP client configuration                       |
| conform.nvim                 | Format on save                                 |
| nvim-lint                    | Async linting (ruff, shellcheck)               |
| gitsigns.nvim                | Git hunk signs, inline blame                   |
| which-key.nvim               | Keybind discovery popup (delay 800 ms)         |
| nvim-dap                     | Debug adapter protocol                         |
| catppuccin.nvim              | Mocha colour scheme                            |
| nvim-treesitter              | Syntax + text objects                          |
| nvim-treesitter-textobjects  | `af/if/ac/ic/aa/ia` motions; `]f/[f` jumps     |
| render-markdown.nvim         | Inline markdown rendering in normal mode       |
| lualine.nvim                 | Status line (catppuccin-mocha theme)           |
| indent-blankline.nvim        | Indent guides (`│` char, scope enabled)        |

### Formatters and linters

| Filetype        | Formatter  | Linter      |
| --------------- | ---------- | ----------- |
| Lua             | stylua     |             |
| Python          | ruff       | ruff        |
| JS/TS/JSON/YAML | prettier   |             |
| Markdown/HTML   | prettier   |             |
| sh / bash       | shfmt      | shellcheck  |

`shfmt` runs with `-ln bash -i 2` (bash dialect, 2-space indent).
Extensionless files (e.g. `~/.kube/config`) skip prettier and fall
back to LSP only.

### oil.nvim keymaps (inside oil buffer)

| Key            | Action                     |
| -------------- | -------------------------- |
| `<CR>`         | Open file                  |
| `<C-s>`        | Open in vertical split     |
| `<C-p>`        | Preview                    |
| `-`            | Go to parent directory     |
| `_`            | Open cwd                   |
| `g.`           | Toggle hidden files        |
| `gs`           | Change sort                |
| `gx`           | Open with external app     |
| `gy`           | Copy entry path            |
| `<leader>cd`   | Set window cwd to this dir |
| `g?`           | Show help                  |

### render-markdown.nvim

- Activates on `markdown` filetype
- `<leader>mt` — toggle inline rendering on/off
- Catppuccin integration enabled (`render_markdown = true`)

### LSP languages

TypeScript, JavaScript, Python, Lua, Rust, Go, Bash, YAML, JSON,
Dockerfile, HTML, CSS (and more via mason.nvim auto-install).

### DAP (debugger)

- Python: debugpy
- JavaScript/Node: js-debug-adapter

### which-key groups

`<leader>l` LSP, `<leader>g` Git, `<leader>d` Diagnostics/DAP,
`<leader>h` Harpoon, `<leader>t` Terminal, `<leader>x` Trouble,
`<leader>s` Search/Replace, `<leader>b` Buffer, `<leader>m` Markdown.

`<leader>?` — show all keymaps for current buffer.

### Leader key: `Space`

---

## Prompt — Starship

Config: [`starship/.config/starship.toml`](starship/)

- Two-line layout, Catppuccin Mocha palette
- Line 1: `user@host  path  branch  status  duration`
- Line 2: `❯` prompt character
- Auto-shows Python venv, Node version, Rust toolchain, Docker context
- Hostname turns red over SSH; root shell turns red

---

## Window Management (macOS)

### Rectangle

Keyboard-driven tiling:

| Shortcut               | Action                           |
| ---------------------- | -------------------------------- |
| `Ctrl+Opt+←/→`         | Left / right half                |
| `Ctrl+Opt+↑`           | Maximise                         |
| `Ctrl+Opt+↓`           | Centre                           |
| `Ctrl+Opt+Cmd+←/→`     | Move to previous / next display  |

### Hammerspoon

Config: [`hammerspoon/.hammerspoon/init.lua`](hammerspoon/.hammerspoon/init.lua)

Focus shifting between monitors (no window is moved):

| Shortcut       | Action                |
| -------------- | --------------------- |
| `Ctrl+Opt+]`   | Focus next monitor    |
| `Ctrl+Opt+[`   | Focus previous monitor|

Focuses the frontmost window on the target screen, or warps the mouse
to the screen centre if no windows are open there.

### macOS native

- `Ctrl+1/2` — switch desktops
- `Ctrl+Cmd+Q` — lock screen

---

## Developer Tooling

### Node — NVM

```bash
nvm install --lts     # install latest LTS
nvm use 24            # switch to v24 (apim-ci standard)
nvm ls                # list installed versions
```

### Python — Poetry

```bash
poetry new my-project       # scaffold a new project
poetry install              # install from pyproject.toml
poetry run python app.py    # run inside virtualenv
poetry shell                # activate the virtualenv
```

### Rust

Installed via rustup. Cargo env sourced in `darwin.sh`:

```bash
rustup update
cargo build --release
```

### Containers

IBM does not permit Docker Desktop.

- **macOS**: Rancher Desktop — provides `docker`-compatible CLI.
  Rancher Desktop injects `~/.rd/bin` into PATH automatically.
- **Linux**: Podman + podman-docker shim (`docker` routes through Podman)

### Kubernetes

```bash
k get pods -n idig-test          # default namespace
k config get-contexts            # list clusters
minikube start                   # local cluster for idig-broker dev
```

---

## Work Secrets

Work-specific env vars go in `~/.config/shell/work.sh` (never committed):

```bash
cp ~/.config/shell/work.sh.example ~/.config/shell/work.sh
nvim ~/.config/shell/work.sh   # fill in VELOX_W3_EMAIL, FYRE_*, keys, etc.
```

Sourced automatically on every shell start via `tools.sh`.
At minimum set `VELOX_W3_EMAIL` and `VELOX_ARTIFACTORY_KEY`.

---

## CLI Tool Stack

| Tool             | Replaces | Purpose                                        |
| ---------------- | -------- | ---------------------------------------------- |
| `eza`            | `ls`     | File listing with icons, git status            |
| `bat`            | `cat`    | Syntax-highlighted file viewing                |
| `fd`             | `find`   | Fast file finding, respects `.gitignore`       |
| `ripgrep` (`rg`) | `grep`   | Fast recursive code search                     |
| `fzf`            | —        | Fuzzy finder: `Ctrl+R` history, `Ctrl+T` files |
| `zoxide`         | `cd`     | Smart directory jumping with memory            |
| `lazygit`        | —        | Terminal UI for git                            |
| `lazydocker`     | —        | Terminal UI for containers                     |
| `btop`           | `htop`   | System monitoring                              |
| `starship`       | PS1      | Cross-shell prompt                             |
| `vivid`          | —        | Catppuccin Mocha `LS_COLORS` generator         |
| `jq`             | —        | JSON processor                                 |
| `minikube`       | —        | Local Kubernetes cluster                       |
| `kubectl`        | —        | Kubernetes CLI                                 |

---

## Repo Structure

```
dotfiles-ibm/
├── shell/          shared shell layer (exports, paths, aliases, functions)
├── bash/           .bashrc, .bash_profile, tmux-sessionizer
├── zsh/            .zshrc, .zprofile
├── starship/       starship.toml
├── nvim/           full Neovim config (lazy.nvim, LSP, DAP, treesitter)
├── tmux/           .tmux.conf
├── ghostty/        terminal config
├── hammerspoon/    init.lua — monitor focus shifting
├── install.sh      Linux bootstrap (Fedora / Arch)
└── install-mac.sh  macOS bootstrap
```

Restow after pulling changes:

```bash
cd ~/dotfiles-ibm
stow -R shell bash zsh starship nvim tmux ghostty hammerspoon
```
