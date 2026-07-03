-- ============================================================
-- search.lua — project-wide find and replace
-- grug-far: the modern spectre replacement. Opens a buffer
-- where you type a pattern, see all matches across the project,
-- edit replacements inline, then apply them all at once.
-- ============================================================

return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sr",
        function() require("grug-far").open() end,
        desc = "Search & replace (project)",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open({
            prefills = { search = vim.fn.expand("<cword>") },
          })
        end,
        desc = "Search & replace word under cursor",
      },
    },
    config = function()
      require("grug-far").setup({
        headerMaxWidth = 80,
      })
    end,
  },
}
