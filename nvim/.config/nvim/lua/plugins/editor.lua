-- ============================================================
-- editor.lua — quality of life editing plugins
-- ============================================================

return {
  -- auto close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      -- blink.cmp's auto_brackets is disabled in completion.lua
      -- to prevent double-bracket insertion — nvim-autopairs owns this
      require("nvim-autopairs").setup({ check_ts = true })
    end,
  },

  -- auto close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- gcc / gc are built into nvim 0.10+ via vim.comment — no plugin needed

  -- surround text objects
  -- ys<motion><char> add, cs<old><new> change, ds<char> delete
  -- e.g. ysiw" wraps word in quotes, cs"' changes " to '
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = function()
      require("nvim-surround").setup()
    end,
  },

  -- highlight TODO, FIXME, HACK, NOTE comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- visual undo history — cycle through every past state of a file
  -- ThePrimeagen's #1 essential: your undofile is persistent; this makes it visible
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },
}
