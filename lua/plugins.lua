if not vim.pack then -- pack needs nvim 0.12+
	return
end

vim.pack.add({
	"https://github.com/folke/tokyonight.nvim", -- Colorscheme

	-- Libs
	"https://github.com/nvim-lua/plenary.nvim", -- Utils lib
	--"https://github.com/MunifTanjim/nui.nvim",  -- UI lib
	--"https://github.com/rcarriga/nvim-notify",  -- Notifications lib

	-- LSP
	"https://github.com/mason-org/mason.nvim",                      -- Install external tools (LSPs, linters, etc) easily
	"https://github.com/mason-org/mason-lspconfig.nvim",            -- Use lspconfig names instead of Mason names + automatically enable servers
	"https://github.com/neovim/nvim-lspconfig",	                    -- Pre-made LSP configs
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- Ensure installation of tools (declaratively)

	-- Formatting & completion
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },  -- Parsing and syntax lib (master branch, main is a complete rework, not ready yet)
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range('1.0') }, -- Completion

	-- UI
	"https://github.com/nvim-lualine/lualine.nvim",             -- Status line
	"https://github.com/yavorski/lualine-macro-recording.nvim", -- Macro recording section for Lualine
	"https://github.com/lukas-reineke/indent-blankline.nvim",   -- Identation guides
	"https://github.com/HiPhish/rainbow-delimiters.nvim",       -- Rainbow matching ({[]}) etc
	"https://github.com/norcalli/nvim-colorizer.lua",           -- Hex color codes preview
	"https://github.com/folke/todo-comments.nvim",              -- Highlight and find TODO comments
	"https://github.com/lewis6991/gitsigns.nvim.git",           -- Git signs

	-- Misc
	"https://github.com/folke/which-key.nvim",         -- Keybinds help menu
	"https://github.com/NMAC427/guess-indent.nvim",    -- Auto detect indentation width
	"https://github.com/olexsmir/gopher.nvim",         -- Go utils (e.g :GoIferr)
	"https://github.com/windwp/nvim-autopairs",        -- Automatically add closing pairs
	"https://github.com/max397574/better-escape.nvim", -- Map jj or jk without delay
	"https://github.com/numToStr/Comment.nvim",        -- Easy comments (might require github.com/JoosepAlviste/nvim-ts-context-commentstring later, will see)
	"https://github.com/stevearc/aerial.nvim",         -- Code outline window (symbols)
	"https://github.com/ibhagwan/fzf-lua",             -- Fuzzy
})

require("better_escape").setup()
require("guess-indent").setup({})
require("Comment").setup()
require("gopher").setup({})

require("aerial").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "_", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "-", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "+", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

--- UI
require("colorizer").setup({})
require("nvim-autopairs").setup()
require("todo-comments").setup()
require("ibl").setup()
require("which-key").setup()
require("rainbow-delimiters.setup").setup({})
require("gitsigns").setup()
require("lualine").setup({
	sections = {
		lualine_c = { "filename", "macro_recording", "%S" },
		lualine_x = { "aerial", "lsp_status", "encoding", "fileformat", "filetype" },
	},
})

require("nvim-treesitter.configs").setup({
	modules = {},
	auto_install = true,
	ensure_installed = { "go" },
	ignore_install = {},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

require("blink.cmp").setup({
	keymap = { preset = 'default' }, -- See https://cmp.saghen.dev/installation.html#lazy-nvim and https://cmp.saghen.dev/configuration/keymap.html#presets
	appearance = { nerd_font_variant = 'mono' },
	completion = { documentation = { auto_show = false } },
	sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
