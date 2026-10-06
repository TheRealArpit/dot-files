-- ============================================================
-- treesitter.lua — real syntax highlighting + code structure
-- nvim-treesitter v1.x: parser manager only; highlight is
-- provided by nvim's built-in vim.treesitter
-- ============================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    config = function()
      -- nvim-treesitter v1: setup() only takes install_dir
      -- Parsers are installed with :TSInstall or by calling install()
      -- Pass parsers as separate arguments (not a table wrapper)
      require("nvim-treesitter").install(
        "lua", "python", "typescript", "javascript",
        "tsx", "json", "yaml", "bash", "html", "css",
        "markdown", "markdown_inline", "dockerfile",
        "gitignore", "regex", "vim", "vimdoc"
      )

      -- nvim 0.9+ built-in: enable treesitter highlighting per filetype
      -- also enable treesitter indent only for filetypes with a loaded parser
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          -- pcall so unknown parsers silently skip rather than error
          if pcall(vim.treesitter.start) then
            -- only set indentexpr when a parser is actually active
            vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- ── Treesitter text objects ───────────────────────────────
  -- adds af/if (function), ac/ic (class), aa/ia (argument) text objects
  -- ALSO adds ]f/[f, ]c/[c navigation between functions and classes
  -- This is what separates powerusers: `vaf` selects whole function body,
  -- `dac` deletes entire class, `]f` jumps to next function start
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy  = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      select = {
        enable    = true,
        lookahead = true,  -- jump forward to textobject if not on one
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Around function" },
          ["if"] = { query = "@function.inner", desc = "Inside function" },
          ["ac"] = { query = "@class.outer",    desc = "Around class" },
          ["ic"] = { query = "@class.inner",    desc = "Inside class" },
          ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
          ["ab"] = { query = "@block.outer",    desc = "Around block" },
          ["ib"] = { query = "@block.inner",    desc = "Inside block" },
        },
        selection_modes = {
          ["@function.outer"] = "V",
          ["@class.outer"]    = "V",
        },
      },
      move = {
        enable    = true,
        set_jumps = true,  -- add to jumplist so <C-o>/<C-i> works
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]c"] = { query = "@class.outer",    desc = "Next class start" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]C"] = { query = "@class.outer",    desc = "Next class end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Prev function start" },
          ["[c"] = { query = "@class.outer",    desc = "Prev class start" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "Prev function end" },
          ["[C"] = { query = "@class.outer",    desc = "Prev class end" },
        },
      },
    },
  },
}
