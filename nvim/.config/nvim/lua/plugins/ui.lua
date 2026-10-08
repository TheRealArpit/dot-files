-- ============================================================
-- ui.lua — statusline, which-key, indent guides, notifications
-- ============================================================
if vim.g.vscode then
  return {}
end

return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    -- catppuccin must be loaded (colorscheme applied) before lualine reads
    -- its theme; marking it as a dependency guarantees the order
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("lualine").setup({
        options = {
          -- catppuccin ships per-flavour lualine themes: catppuccin-mocha,
          -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato
          -- "catppuccin" alone does NOT exist as a theme file
          theme = vim.env.THEME or "catppuccin-mocha",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
      })
    end,
  },

  -- which-key — shows keybindings as you type
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        win = { border = "rounded" },
        delay = 800, -- ms — only fires if you actually pause; fast typists won't see it
      })
      -- v3 API: wk.add() instead of deprecated wk.register()
      wk.add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>l", group = "LSP" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "Diagnostics / DAP" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>t", group = "Terminal" },
        { "<leader>x", group = "Trouble" },
        { "<leader>s", group = "Search & Replace" },
        { "<leader>b", group = "Buffer" },
        { "<leader>m", group = "Markdown" },
      })
      -- manual trigger — show all keymaps for current buffer
      vim.keymap.set("n", "<leader>?", function()
        wk.show()
      end, { desc = "Which Key" })
    end,
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
}
