-- ============================================================
-- markdown.lua — inline markdown rendering via render-markdown.nvim
-- ============================================================

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft           = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle markdown render" },
    },
    opts = {},
  },
}
