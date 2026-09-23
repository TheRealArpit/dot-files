# Neovim & Bob 2.0 Quick Reference

## Leader Key
- `Space` is `<leader>`

## File & Buffer Navigation
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>e` | Open Oil.nvim | File explorer as a buffer (`-` goes up a dir, `<CR>` opens) |
| `s <c><c>` | Flash Jump | Jump instantly to any 2-character match on screen |
| `S` | Flash Treesitter | Select treesitter syntax nodes visually |
| `<S-l>` / `<S-h>` | Next / Prev Buffer | Switch active buffers |
| `<leader>bd` | Close Buffer | Delete current buffer without closing split |
| `Ctrl + h/j/k/l` | Navigate Splits | Seamless navigation across Neovim splits AND Tmux panes |

## Harpoon 2 (Hot Project Files)
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>ha` | Harpoon Add | Pin / bookmark current file |
| `<leader>hh` | Harpoon Menu | Open Harpoon quick menu list |
| `<leader>1` | Jump to File 1 | Instant jump to slot 1 |
| `<leader>2` | Jump to File 2 | Instant jump to slot 2 |
| `<leader>3` | Jump to File 3 | Instant jump to slot 3 |
| `<leader>4` | Jump to File 4 | Instant jump to slot 4 |

## Telescope (Fuzzy Search)
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>ff` | Find Files | Fuzzy find files by name across project |
| `<leader>fg` | Live Grep | Search text across all files in workspace |
| `<leader>fb` | Buffers | List and switch between open buffers |
| `<leader>fr` | Recent Files | Open previously edited files |
| `<leader>fs` | Symbols | Search LSP document symbols |
| `<leader>fw` | Find Word | Grep for word currently under cursor |

## LSP & Diagnostics
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `gd` | Definition | Jump to symbol definition |
| `gr` | References | List all references in Telescope |
| `K` | Hover | Show hover documentation / type info |
| `<leader>la` | Code Action | Open available LSP quick fixes / code actions |
| `<leader>lr` | Rename | Project-wide symbol rename |
| `<leader>lf` | Format | Format buffer (via Conform + Prettier/Ruff/Stylua) |
| `[d` / `]d` | Prev / Next Diagnostic | Jump between warnings/errors |
| `<leader>df` | Floating Diagnostic | Show full diagnostic error text at cursor |

## Git & Terminal Integration
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>gg` | Lazygit Float | Open full interactive Lazygit floating overlay |
| `Ctrl + \` | Toggle Float Terminal | Quick scratch terminal popup |
| `<leader>th` / `<leader>tv` | Terminal Split | Open horizontal / vertical terminal pane |
| `]h` / `[h` | Next / Prev Git Hunk | Jump between git diff chunks |
| `<leader>gp` | Preview Hunk | Preview git diff for line at cursor |
| `<leader>gb` | Git Blame | Inline git blame for current line |
