# Neovim & Bob 2.0 Quick Reference
# Leader key is Space (<leader>)

── Navigation & Buffers ──────────────────────────────────────────
  `<leader>e`         Open Oil file explorer ('-' goes up, <CR> opens)
  `s <c><c>`          Flash jump to 2-character match on screen
  `S`                 Flash treesitter syntax selection
  `<S-l>` / `<S-h>`   Next / previous buffer
  `<leader>bd`        Close current buffer (keeps split open)
  `<leader>tc`        Toggle 80-char column guideline on/off
  `Ctrl + h/j/k/l`    Navigate splits across Neovim and Tmux

── Harpoon 2 (Hot Files) ─────────────────────────────────────────
  `<leader>ha`        Pin / mark current file into Harpoon
  `<leader>hh`        Open Harpoon menu list
  `<leader>1`         Jump to hot file 1
  `<leader>2`         Jump to hot file 2
  `<leader>3`         Jump to hot file 3
  `<leader>4`         Jump to hot file 4

── Telescope (Fuzzy Search) ──────────────────────────────────────
  `<leader>ff`        Find files by name across project
  `<leader>fg`        Live grep text across entire repository
  `<leader>fb`        List and switch between open buffers
  `<leader>fr`        Open recently closed files
  `<leader>fs`        Search LSP document symbols
  `<leader>fw`        Grep for word currently under cursor

── LSP & Code Intelligence ───────────────────────────────────────
  `gd`                Jump to symbol definition (Ctrl+O to jump back)
  `gr`                List all references across project in Telescope
  `K`                 Show hover documentation & type signature
  `<leader>la`        Open available LSP code actions / quick fixes
  `<leader>lr`        Rename symbol project-wide
  `<leader>lf`        Format current buffer (Prettier / Ruff / Stylua)
  `[d` / `]d`         Jump to previous / next diagnostic error/warning
  `<leader>df`        Show floating diagnostic tooltip at cursor

── File Path Navigation ──────────────────────────────────────────
  `gf`                Open file path under cursor in current window
  `gF`                Open file path under cursor, jump to line number
                      (works on paths like src/foo.ts:42)
  Note: Cmd+click in Ghostty opens Finder; use gf/gF inside Neovim
        or `e <path>` from the terminal shell instead.

── Git & Terminal Integration ────────────────────────────────────
  `<leader>gg`        Open floating Lazygit window ('q' to close)
  `Ctrl + \`          Toggle floating scratch terminal
  `<leader>th` / `tv` Open horizontal / vertical terminal split
  `]h` / `[h`         Jump to next / previous git diff hunk
  `<leader>gp`        Preview git diff for hunk under cursor
  `<leader>gb`        Show inline git blame for current line
