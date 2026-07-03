-- ============================================================
-- autocmds.lua — autocommands
-- ============================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- highlight yanked text briefly
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- remove trailing whitespace on save
-- trailing whitespace removal is handled by conform.nvim (formatting.lua)
-- which uses trim_whitespace as the "_" fallback for unlisted filetypes
-- and explicit formatters (ruff, prettier, stylua) for everything else
-- a second BufWritePre autocmd here would run twice — removed

-- restore cursor position on file open
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- python uses 4 spaces
augroup("FileTypeIndent", { clear = true })
autocmd("FileType", {
  group   = "FileTypeIndent",
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- close certain windows with q
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group   = "QuickClose",
  pattern = { "help", "man", "qf", "checkhealth" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
  end,
})

-- auto-format on save is handled by conform.nvim (plugins/formatting.lua)
-- which gives per-filetype formatter control and LSP fallback
