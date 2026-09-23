-- ============================================================
-- keymaps.lua — all keybindings
-- ============================================================

local map = vim.keymap.set

-- leader key — space
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── NORMAL MODE ──────────────────────────────────────────────

-- clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- toggle 80/100 char column guide
map("n", "<leader>tc", function()
  vim.opt.colorcolumn = vim.opt.colorcolumn:get()[1] and "" or "80"
end, { desc = "Toggle colorcolumn ruler" })

-- save and quit
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- better up/down on wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- window navigation — handled by vim-tmux-navigator plugin
-- (<C-h/j/k/l> work across both nvim splits AND tmux panes)

-- window resizing
map("n", "<C-Up>",    "<cmd>resize +2<CR>")
map("n", "<C-Down>",  "<cmd>resize -2<CR>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>",       { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>",   { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- move lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- oil.nvim
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "File explorer" })

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",              { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",               { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",                 { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",               { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",                { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",   { desc = "Symbols" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>",             { desc = "Find word" })
map("n", "<leader>fc", "<cmd>Telescope git_commits<CR>",             { desc = "Git commits" })

-- LSP  (<leader>lf is owned by conform.nvim in formatting.lua)
-- <leader>la and <leader>lr are registered buffer-locally in lsp.lua on_attach
-- (they only make sense when LSP is active anyway)
map("n", "<leader>ld", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

-- gitsigns — buffer-local bindings are set in plugins/git.lua on_attach
-- (only active inside git-tracked files; global registration here is redundant)

-- diagnostics
map("n", "[d", vim.diagnostic.goto_prev,  { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- ── VISUAL MODE ──────────────────────────────────────────────

-- stay in visual after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move selection
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- don't overwrite clipboard when pasting over selection
map("v", "p", '"_dP')

-- ── INSERT MODE ──────────────────────────────────────────────

-- quick escape
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "kj", "<Esc>", { desc = "Escape insert mode" })

-- ── TERMINAL MODE ────────────────────────────────────────────

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
