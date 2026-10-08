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
    config = function()
      -- main branch: setup() only takes select/move options; keymaps are
      -- set manually (the old `keymaps` / `goto_*` tables are ignored)
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,  -- jump forward to textobject if not on one
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"]    = "V",
          },
        },
        move = { set_jumps = true },  -- add to jumplist so <C-o>/<C-i> works
      })

      local select = require("nvim-treesitter-textobjects.select")
      for key, spec in pairs({
        af = { "@function.outer", "Around function" },
        ["if"] = { "@function.inner", "Inside function" },
        ac = { "@class.outer", "Around class" },
        ic = { "@class.inner", "Inside class" },
        aa = { "@parameter.outer", "Around argument" },
        ia = { "@parameter.inner", "Inside argument" },
        ab = { "@block.outer", "Around block" },
        ib = { "@block.inner", "Inside block" },
      }) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(spec[1], "textobjects")
        end, { desc = spec[2] })
      end

      local move = require("nvim-treesitter-textobjects.move")
      for key, spec in pairs({
        ["]f"] = { "goto_next_start", "@function.outer", "Next function start" },
        ["]c"] = { "goto_next_start", "@class.outer", "Next class start" },
        ["]F"] = { "goto_next_end", "@function.outer", "Next function end" },
        ["]C"] = { "goto_next_end", "@class.outer", "Next class end" },
        ["[f"] = { "goto_previous_start", "@function.outer", "Prev function start" },
        ["[c"] = { "goto_previous_start", "@class.outer", "Prev class start" },
        ["[F"] = { "goto_previous_end", "@function.outer", "Prev function end" },
        ["[C"] = { "goto_previous_end", "@class.outer", "Prev class end" },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          move[spec[1]](spec[2], "textobjects")
        end, { desc = spec[3] })
      end
    end,
  },
}
