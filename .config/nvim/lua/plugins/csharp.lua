local function get_easy_dotnet_session()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return nil
  end

  local session = dap.session()
  if not session or not session.config then
    return nil
  end

  if session.config.type ~= "easy-dotnet" then
    return nil
  end

  return session
end

local function show_csharp_debug_value(expr)
  local session = get_easy_dotnet_session()
  if not session then
    require("dapui").eval(expr)
    return
  end

  local keys = vim.api.nvim_replace_termcodes("T", true, false, true)
  vim.api.nvim_feedkeys(keys, "m", false)
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = { "csharpier", "roslyn", "netcoredbg", "html-lsp" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "c_sharp", "css", "html", "javascript", "jsdoc", "json", "xml" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = {
        enabled = true,
      },
      servers = {
        html = {},
        roslyn = {
          settings = {
            ["csharp|background_analysis"] = {
              dotnet_analyzer_diagnostics_scope = "openFiles",
              dotnet_compiler_diagnostics_scope = "openFiles",
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
              dotnet_enable_tests_code_lens = true,
            },
            ["csharp|completion"] = {
              dotnet_show_completion_items_from_unimported_namespaces = true,
              dotnet_show_name_completion_suggestions = true,
            },
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
          },
        },
      },
    },
  },

  {
    "seblj/roslyn.nvim",
    opts = {
      filewatching = "auto",
    },
  },

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

  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },

  -- Disable nvim-dap-ui (replaced by nvim-dap-view)
  { "rcarriga/nvim-dap-ui", enabled = false },

  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("dap-view").setup(opts)

      local dap = require("dap")
      dap.listeners.after.event_initialized["dapview_auto"] = function()
        vim.cmd("DapViewOpen")
      end
      dap.listeners.before.event_terminated["dapview_auto"] = function()
        vim.cmd("DapViewClose")
      end
      dap.listeners.before.event_exited["dapview_auto"] = function()
        vim.cmd("DapViewClose")
      end
    end,
    keys = {
      { "<leader>du", "<cmd>DapViewOpen<cr>",  desc = "Open Debug View" },
      { "<leader>dU", "<cmd>DapViewClose<cr>", desc = "Close Debug View" },
      { "<leader>dw", function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft:match("^dap") then
              vim.api.nvim_set_current_win(win)
              return
            end
          end
          vim.cmd("DapViewOpen")
        end, desc = "Focus Debug View" },
      { "<leader>de", show_csharp_debug_value, desc = "Inspect Word",      mode = "n" },
      { "<leader>de", function() require("dap-view").add_expr() end, desc = "Watch Expression", mode = "x" },
      { "<leader>dE", function()
          local expr = vim.fn.input("Watch expression: ")
          if expr ~= "" then require("dap-view").add_expr(expr) end
        end, desc = "Watch Expression (input)" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
      },
    },
  },

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
      {
        "<leader>dq",
        function()
          require("dap").disconnect({ terminateDebuggee = true })
          vim.cmd("DapViewClose")
        end,
        desc = "Terminate & Kill",
      },
    },
  },

  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("easy-dotnet").setup({
        lsp = {
          enabled = false,
        },
        debugger = {
          console = "internalConsole",
          auto_register_dap = true,
        },
      })

      require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
    end,
  },
}
