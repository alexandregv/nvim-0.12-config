if not vim.pack then -- pack needs nvim 0.12+, LSP can't be configured without pack/plugins
	return
end

local mason_servers = {
	"lua_ls",
	"gopls",
}

local lsp_servers = {
	unpack(mason_servers),
	"yamlls",
	"pyright",
	"nil_ls",
}

local tools = {
	"stylua",

	"goimports",
	"golangci-lint",
}

require("mason").setup()
require("mason-lspconfig").setup({ automatic_enable = true, ensure_installed = mason_servers })
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
  settings = { -- https://go.dev/gopls/settings
    gopls = {
      semanticTokens = true,
      staticcheck = true,
      gofumpt = true,
      renameMovesSubpackages = true,
      analyses = { -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        unusedparams = true,
      },
      hints = { -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        ignoredError = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
vim.lsp.config('yamlls', {
	cmd = { 'yaml-schema-router' },
})
vim.lsp.config('pyright', {
	root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.venv', 'requirements.txt' },
	settings = {
		python = {
			pythonPath = '',
			venvPath = '.',
			venv = '.venv',
			analysis = {
				typeCheckingMode = 'basic',
			},
		},
	},
})

vim.lsp.enable(lsp_servers)
vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
