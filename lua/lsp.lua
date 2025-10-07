if not vim.pack then -- pack needs nvim 0.12+, LSP can't be configured without pack/plugins
	return
end

local lsp_servers = {
	"lua_ls",
	"gopls",
}

local tools = {
	"stylua",

	"goimports",
	"golangci-lint",
}

require("mason").setup()
require("mason-lspconfig").setup({ automatic_enable = true, ensure_installed = lsp_servers })
require("mason-tool-installer").setup({ ensure_installed = tools })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.enable(lsp_servers)
vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
