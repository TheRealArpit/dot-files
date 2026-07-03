-- ============================================================
-- navigation.lua — fast movement and file switching
-- ============================================================

return {
  -- ── Flash — 2-char jump to anywhere on screen ────────────
  -- s<char><char> jumps; much faster than / or repeated f/t
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        modes = {
          char = { enabled = false }, -- keep native f/t/F/T unchanged
        },
      })
    end,
    keys = {
      { "s", function() require("flash").jump() end,               desc = "Flash jump",              mode = { "n", "x", "o" } },
      { "S", function() require("flash").treesitter() end,         desc = "Flash treesitter select", mode = { "n", "x", "o" } },
      { "r", function() require("flash").remote() end,             desc = "Flash remote (op)",       mode = "o" },
      { "R", function() require("flash").treesitter_search() end,  desc = "Flash treesitter search", mode = { "o", "x" } },
    },
  },

  -- ── Harpoon 2 — instant switching between your 4 hot files ─
  -- <leader>ha   mark current file
  -- <leader>hh   open harpoon menu
  -- <leader>1-4  jump to slot 1-4
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end,                                               desc = "Harpoon add file" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,            desc = "Harpoon menu" },
      { "<leader>1",  function() require("harpoon"):list():select(1) end,                                           desc = "Harpoon file 1" },
      { "<leader>2",  function() require("harpoon"):list():select(2) end,                                           desc = "Harpoon file 2" },
      { "<leader>3",  function() require("harpoon"):list():select(3) end,                                           desc = "Harpoon file 3" },
      { "<leader>4",  function() require("harpoon"):list():select(4) end,                                           desc = "Harpoon file 4" },
    },
  },

  -- ── vim-tmux-navigator — <C-h/j/k/l> across nvim AND tmux ─
  -- works transparently: same keys navigate nvim splits or tmux panes
  -- tmux.conf needs matching bindings (see dotfiles/tmux/.tmux.conf)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp",   "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left  (nvim/tmux)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down  (nvim/tmux)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up    (nvim/tmux)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (nvim/tmux)" },
    },
  },
}
