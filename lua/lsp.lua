if not vim.pack then -- pack needs nvim 0.12+, LSP can't be configured without pack/plugins
	return
end

require("lspkind").setup()
require("mason").setup()
require("mason-lspconfig").setup({ automatic_enable = true })
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",

		"gopls",
		"goimports",
		"golangci-lint",
	},
})

vim.diagnostic.config({ virtual_text = true }) -- Enable diagnostics as virtual_text (appears to the right of the line)

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
