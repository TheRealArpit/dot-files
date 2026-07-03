-- ============================================================
-- terminal.lua — terminal and git UI inside nvim
-- ============================================================
if vim.g.vscode then return {} end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { [[<C-\>]],      desc = "Toggle float terminal" },
      { "<leader>tf",   desc = "Float terminal" },
      { "<leader>th",   desc = "Horizontal terminal" },
      { "<leader>tv",   desc = "Vertical terminal" },
      { "<leader>gg",   desc = "Lazygit" },
    },
    config = function()
      require("toggleterm").setup({
        open_mapping    = [[<C-\>]],
        direction       = "float",
        float_opts      = {
          border   = "rounded",
          winblend = 3,
        },
        -- when inside the terminal, <Esc><Esc> exits insert mode
        -- (already in keymaps.lua)
        persist_mode    = true,
        auto_scroll     = true,
        shade_terminals = false,
      })

      -- ── additional direction shortcuts ─────────────────────
      local map = vim.keymap.set
      map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",      { desc = "Float terminal" })
      map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal terminal" })
      map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",   { desc = "Vertical terminal" })

      -- ── lazygit float ──────────────────────────────────────
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit  = Terminal:new({
        cmd       = "lazygit",
        hidden    = true,
        direction = "float",
        float_opts = { border = "double" },
        on_open   = function(term)
          vim.cmd("startinsert!")
          -- q/Ctrl+C still closes the pane when lazygit exits
          vim.api.nvim_buf_set_keymap(
            term.bufnr, "n", "q", "<cmd>close<CR>",
            { noremap = true, silent = true }
          )
        end,
      })
      map("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })
    end,
  },
}
