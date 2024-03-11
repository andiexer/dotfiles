local M = {
	"jmederosalvarado/roslyn.nvim",
}

function M.config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities = vim.tbl_deep_extend("force", capabilities, {
		filetypes = { "cs", "razor" },
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = false,
			},
		},
	})

	local on_attach = function(_, bufnr)
		local function sign_define(args)
			vim.fn.sign_define(args.name, {
				texthl = args.name,
				text = args.text,
				numhl = "",
			})
		end

		local icon = require("andiexer.icons").diagnostics
		sign_define({ name = "DiagnosticSignError", text = icon.BoldError })
		sign_define({ name = "DiagnosticSignWarn", text = icon.BoldWarning })
		sign_define({ name = "DiagnosticSignHint", text = icon.BoldHint })
		sign_define({ name = "DiagnosticSignInfo", text = icon.BoldInformation })
	end

	require("roslyn").setup({
		dotnet_cmd = "dotnet", -- this is the default
		roslyn_version = "4.8.0-3.23475.7", -- this is the default
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

return M
