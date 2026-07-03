-- ============================================================
-- dap.lua — Debug Adapter Protocol
-- Gives you VS Code-style breakpoints and step debugging inside
-- nvim. Works for Python out of the box; Node/TS via launch.json.
--
-- Note: DAP attaches a debugger process to running code. On IBM
-- machines CrowdStrike/EDR may occasionally flag this — if so,
-- allowlist debugpy or js-debug-adapter in the security console.
-- The plugins themselves are inert until you actively start a
-- debug session with <F5>.
--
if vim.g.vscode then return {} end
-- Adapters are installed through Mason (mason-nvim-dap).
-- Run :MasonInstall debugpy   (Python)
--     :MasonInstall js-debug-adapter  (JS/TS/Node)
-- ============================================================

return {
  -- ── Core DAP ─────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI (the floating panels for variables, stack, breakpoints)
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            layouts = {
              {
                elements = {
                  { id = "scopes",      size = 0.35 },
                  { id = "breakpoints", size = 0.20 },
                  { id = "stacks",      size = 0.25 },
                  { id = "watches",     size = 0.20 },
                },
                size    = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl",    size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size     = 10,
                position = "bottom",
              },
            },
          })

          -- auto open/close dapui when a debug session starts/ends
          dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
        end,
      },

      -- inline virtual text showing variable values while stepping
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled                 = true,
            enabled_commands        = true,
            highlight_changed_variables = true,
            virt_text_pos           = "eol",
          })
        end,
      },

      -- Mason bridge: auto-installs debug adapters
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
          require("mason-nvim-dap").setup({
            ensure_installed  = { "python", "js" },
            automatic_install = true,
            handlers          = {},   -- empty = use default mason-nvim-dap handlers
          })
        end,
      },
    },

    keys = {
      -- run / control
      { "<F5>",         function() require("dap").continue() end,              desc = "DAP: Continue / Start" },
      { "<F10>",        function() require("dap").step_over() end,             desc = "DAP: Step over" },
      { "<F11>",        function() require("dap").step_into() end,             desc = "DAP: Step into" },
      { "<F12>",        function() require("dap").step_out() end,              desc = "DAP: Step out" },
      { "<F9>",         function() require("dap").terminate() end,             desc = "DAP: Terminate" },

      -- breakpoints
      { "<leader>db",   function() require("dap").toggle_breakpoint() end,     desc = "DAP: Toggle breakpoint" },
      { "<leader>dB",   function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,                                                                     desc = "DAP: Conditional breakpoint" },
      { "<leader>dl",   function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
        end,                                                                     desc = "DAP: Logpoint" },

      -- UI
      { "<leader>du",   function() require("dapui").toggle() end,              desc = "DAP: Toggle UI" },
      { "<leader>de",   function() require("dapui").eval() end,                desc = "DAP: Eval under cursor",  mode = { "n", "v" } },

      -- inspection
      { "<leader>dr",   function() require("dap").repl.open() end,             desc = "DAP: Open REPL" },
      { "<leader>dR",   function() require("dap").run_last() end,              desc = "DAP: Run last config" },
    },

    config = function()
      -- ── signs ───────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError",   linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarning", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◉", texthl = "DiagnosticInfo",    linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",      linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "✗", texthl = "DiagnosticError",   linehl = "", numhl = "" })
    end,
  },

  -- ── Python adapter ───────────────────────────────────────
  -- Uses debugpy (installed by mason-nvim-dap above).
  -- <F5> in a .py file → picks up the current virtual env automatically.
  {
    "mfussenegger/nvim-dap-python",
    ft   = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local python_path = (function()
        -- 1. active virtualenv
        local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
        if venv then
          local p = venv .. "/bin/python"
          if vim.fn.executable(p) == 1 then return p end
        end
        -- 2. mason-installed debugpy
        local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        if vim.fn.executable(mason_python) == 1 then return mason_python end
        -- 3. system python
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end)()

      require("dap-python").setup(python_path)

      -- extra keymaps only in Python files
      local map = vim.keymap.set
      map("n", "<leader>dm", function() require("dap-python").test_method()  end, { desc = "DAP: Test method" })
      map("n", "<leader>dC", function() require("dap-python").test_class()   end, { desc = "DAP: Test class" })
      map("v", "<leader>ds", function() require("dap-python").debug_selection() end, { desc = "DAP: Debug selection" })
    end,
  },
}
