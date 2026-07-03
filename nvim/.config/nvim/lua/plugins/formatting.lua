-- ============================================================
-- formatting.lua — conform (format) + nvim-lint (lint)
-- Replaces the blunt vim.lsp.buf.format() on-save autocmd.
--
-- Formatters / linters are managed by Mason.
if vim.g.vscode then return {} end
-- Run :MasonInstall stylua ruff prettier shfmt eslint_d
-- or let mason-tool-installer do it automatically below.
-- ============================================================

return {
  -- ── Auto-install formatters + linters via Mason ──────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",    -- Lua formatter
          "ruff",      -- Python linter + formatter (replaces black/flake8)
          "prettier",  -- JS / TS / JSON / YAML / HTML / CSS / Markdown
          "shfmt",     -- Shell formatter
        },
        auto_update    = false,
        run_on_start   = true,
      })
    end,
  },

  -- ── conform.nvim — formatter ─────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>lf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua             = { "stylua" },
          python          = { "ruff_format", "ruff_organize_imports" },
          typescript      = { "prettier" },
          javascript      = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          json            = { "prettier" },
          yaml            = { "prettier" },
          markdown        = { "prettier" },
          html            = { "prettier" },
          css             = { "prettier" },
          sh              = { "shfmt" },
          -- anything else falls back to LSP
          ["_"]           = { "trim_whitespace" },
        },
        format_on_save = {
          timeout_ms   = 1500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- ── nvim-lint — linter (beyond what LSP provides) ────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python          = { "ruff" },
        -- eslint_d for JS/TS (install: npm i -g eslint_d)
        -- uncomment when you have an eslint config in your project
        -- typescript      = { "eslint_d" },
        -- javascript      = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd(
        { "BufWritePost", "BufReadPost", "InsertLeave" },
        { callback = function() lint.try_lint() end }
      )
    end,
  },
}
