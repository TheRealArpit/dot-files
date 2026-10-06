-- ============================================================
-- catppuccin.lua — theme, loads first
-- ============================================================

return {
  "catppuccin/nvim",
  name     = "catppuccin",
  priority = 1000,
  config   = function()
    local flavor = (vim.env.THEME or "catppuccin-mocha"):gsub("catppuccin%-", "")
    require("catppuccin").setup({
      flavour    = flavor,
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      custom_highlights = function(colors)
        return {
          Normal      = { bg = "#000000" },
          NormalNC    = { bg = "#000000" },
          NormalFloat = { bg = "#000000" },
          SignColumn  = { bg = "#000000" },
          -- match cmdline row to black background
          MsgArea     = { bg = "#000000", fg = colors.subtext1 },
        }
      end,
      integrations = {
        blink_cmp        = true,
        gitsigns         = true,
        telescope        = { enabled = true },
        treesitter       = true,
        which_key        = true,
        mason            = true,
        noice            = false,
        trouble          = true,
        render_markdown  = true,
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled    = true,
          underlines = {
            errors      = { "underline" },
            hints       = { "underline" },
            warnings    = { "underline" },
            information = { "underline" },
          },
        },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
