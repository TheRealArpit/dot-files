-- ============================================================
-- lsp.lua — LSP + Mason
-- Mason auto-installs and manages language servers
-- Uses the nvim 0.11+ vim.lsp.config / vim.lsp.enable API
-- ============================================================
if vim.g.vscode then return {} end

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons  = {
            package_installed   = "✓",
            package_pending     = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",    -- Python
          "ts_ls",      -- TypeScript/JavaScript
          "lua_ls",     -- Lua (nvim config editing)
          "bashls",     -- Bash
          "jsonls",     -- JSON
          "yamlls",     -- YAML
          "dockerls",   -- Dockerfile
          "cssls",      -- CSS
          "html",       -- HTML
        },
        automatic_enable = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- blink.cmp exposes enhanced capabilities (faster fuzzy, Rust core)
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        map("gd",  vim.lsp.buf.definition,     "Go to definition")
        map("gD",  vim.lsp.buf.declaration,    "Go to declaration")
        map("gr",  vim.lsp.buf.references,     "References")
        map("gi",  vim.lsp.buf.implementation, "Go to implementation")
        map("K",   vim.lsp.buf.hover,          "Hover docs")
        map("<leader>lk", vim.lsp.buf.signature_help, "Signature help")
        map("<leader>lr", vim.lsp.buf.rename,       "Rename symbol")
        map("<leader>la", vim.lsp.buf.code_action,  "Code action")
        -- <leader>lf is owned by conform.nvim (formatting.lua) — do NOT re-register here
        -- conform uses lsp_fallback = true so LSP formatting still happens via conform

        -- enable native inlay hints (nvim 0.11+)
        -- shows parameter names and return types inline while you type
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Global defaults applied to every server
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach    = on_attach,
      })

      -- Server-specific settings
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode       = "basic",
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        -- Only activate inside a JS/TS project — prevents the
        -- "no valid TypeScript installation" error when opening
        -- arbitrary files outside a project with a package.json.
        root_dir = function(fname)
          return vim.fs.root(fname, { "package.json", "tsconfig.json", "jsconfig.json" })
        end,
        settings = {
          typescript  = { inlayHints = { includeInlayParameterNameHints = "all" } },
          javascript  = { inlayHints = { includeInlayParameterNameHints = "all" } },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals  = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable   = false },
          },
        },
      })

      -- diagnostic display (nvim 0.10+ API — sign_define is legacy)
      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
        severity_sort = true,
        float         = { border = "rounded", source = "always" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })
    end,
  },
}
