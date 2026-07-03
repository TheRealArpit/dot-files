-- ============================================================
-- diagnostics.lua — trouble.nvim v3
-- Replaces the built-in quickfix / loclist / diagnostic panes
-- with a better UI that groups errors by file and severity.
-- ============================================================

return {
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                       desc = "Workspace diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",          desc = "Buffer diagnostics" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                           desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                            desc = "Quickfix list" },
      { "<leader>xs", "<cmd>Trouble lsp_document_symbols toggle focus=false<cr>",  desc = "Document symbols" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle focus=false<cr>",        desc = "LSP references" },
    },
    config = function()
      require("trouble").setup({
        use_diagnostic_signs = true, -- use the same icons as DiagnosticSign*
      })
    end,
  },
}
