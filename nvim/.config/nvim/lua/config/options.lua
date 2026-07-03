-- ============================================================
-- options.lua — vim options
-- ============================================================

local opt = vim.opt

-- line numbers
opt.number         = true
opt.relativenumber = true   -- relative numbers — essential for vim motions

-- indentation
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true
opt.autoindent     = true

-- search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true    -- <Esc> in keymaps.lua clears it
opt.incsearch      = true

-- appearance
opt.termguicolors  = true
opt.signcolumn     = "yes"
opt.cursorline     = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.colorcolumn    = "80"

-- splits
opt.splitright     = true
opt.splitbelow     = true

-- behaviour
opt.mouse          = "a"
opt.clipboard      = "unnamedplus"
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.updatetime     = 250
opt.timeoutlen     = 300

-- completion
opt.completeopt    = "menu,menuone,noselect"
opt.infercase      = true    -- completion matches case of typed text

-- folds
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable     = false

-- show invisible characters
opt.list           = true
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

-- disable netrw — using oil.nvim
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- hide the cmdline when not in use (removes the empty line between lualine and tmux)
opt.cmdheight  = 1

-- silence the terminal bell on out-of-bounds moves
opt.errorbells = false
opt.belloff    = "all"
