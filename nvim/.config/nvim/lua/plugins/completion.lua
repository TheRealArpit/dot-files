-- ============================================================
-- completion.lua — blink.cmp (Rust-powered, replaces nvim-cmp)
-- blink.cmp has built-in LSP/path/buffer/snippet sources.
-- LuaSnip is kept for VSCode-style snippet expansion.
-- Capabilities are exposed via require('blink.cmp').get_lsp_capabilities()
if vim.g.vscode then return {} end
-- which is consumed in lsp.lua.
-- ============================================================

return {
  {
    "saghen/blink.cmp",
    version = "1.*",  -- pin to stable 1.x releases
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- LuaSnip as the snippet engine
      snippets = { preset = "luasnip" },

      -- sources: LSP first, then snippets, path, buffer
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },

      -- cmdline completion (separate top-level key in blink v1)
      cmdline = {
        sources = { "path", "cmdline" },
      },

      -- keymap: intentionally close to the old nvim-cmp layout
      keymap = {
        preset          = "none",
        ["<C-Space>"]   = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]       = { "hide", "fallback" },
        ["<CR>"]        = { "accept", "fallback" },
        ["<Tab>"]       = { "snippet_forward",  "select_next", "fallback" },
        ["<S-Tab>"]     = { "snippet_backward", "select_prev", "fallback" },
        ["<C-b>"]       = { "scroll_documentation_up",   "fallback" },
        ["<C-f>"]       = { "scroll_documentation_down", "fallback" },
        ["<Up>"]        = { "select_prev", "fallback" },
        ["<Down>"]      = { "select_next", "fallback" },
      },

      appearance = {
        -- use Nerd Font mono variants (single-width icons)
        nerd_font_variant = "mono",
        kind_icons = {
          Text          = "󰉿", Method      = "󰆧", Function  = "󰊕",
          Constructor   = "",  Field       = "󰜢", Variable  = "󰀫",
          Class         = "󰠱", Interface   = "",  Module    = "",
          Property      = "󰜢", Unit        = "󰑭", Value     = "󰎠",
          Enum          = "",  Keyword     = "󰌋", Snippet   = "",
          Color         = "󰏘", File        = "󰈙", Reference = "󰈇",
          Folder        = "󰉋", EnumMember  = "",  Constant  = "󰏿",
          Struct        = "󰙅", Event       = "",  Operator  = "󰆕",
          TypeParameter = "",
        },
      },

      completion = {
        accept = {
          auto_brackets = { enabled = false },  -- nvim-autopairs owns bracket insertion
        },
        documentation = {
          auto_show = true,
          window    = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          -- show source label (LSP / Snippet / Path / Buffer)
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
          },
        },
      },
    },
  },
}
