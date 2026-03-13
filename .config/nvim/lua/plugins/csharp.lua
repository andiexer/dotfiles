return {
  -- Mason: custom registry needed for roslyn
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = { "csharpier", "roslyn", "netcoredbg" },
    },
  },

  -- Roslyn LSP
  {
    "seblj/roslyn.nvim",
    opts = {
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_parameters = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      },
    },
  },

  -- Format on save with csharpier
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = false,
      },
    },
  },

  -- Inline variable values while debugging (Rider-style)
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    event = "VeryLazy",
    opts = {
      virt_text_pos = "inline",
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
    },
  },

  -- which-key group label for <leader>d
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
      },
    },
  },

  -- DAP keymaps
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end,         desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "Step Into" },
      { "<leader>dO", function() require("dap").step_out() end,          desc = "Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dq", function() require("dap").disconnect({ terminateDebuggee = true }) require("dapui").close() end, desc = "Terminate & Kill" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle UI" },
      { "<leader>dE", function() require("dapui").eval(vim.fn.input("Expression: ")) end, desc = "Evaluate Expression" },
      -- Eval: bypass dapui caching by going directly to the DAP session
      { "<leader>de", function()
          local session = require("dap").session()
          if not session then
            vim.notify("No active debug session", vim.log.levels.WARN)
            return
          end
          local expr = vim.fn.expand("<cword>")
          session:evaluate(expr, function(err, resp)
            vim.schedule(function()
              if err then
                vim.notify("Eval: " .. (err.message or "error"), vim.log.levels.ERROR)
                return
              end
              require("dapui").eval(expr)
            end)
          end)
        end, desc = "Evaluate Word" },
      { "<leader>de", function()
          local session = require("dap").session()
          if not session then return end
          require("dapui").eval()
        end, desc = "Evaluate Selection", mode = "v" },
    },
  },

  -- easy-dotnet: debugger, launchSettings, test runner, project management
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("easy-dotnet").setup({
        lsp = {
          enabled = false, -- roslyn.nvim handles LSP
        },
        debugger = {
          console = "internalConsole",
          auto_register_dap = true,
        },
      })
    end,
  },
}
