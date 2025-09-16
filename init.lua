-- Speedup startup time by byte-compiling Lua files (nvim 0.9+)
if vim.loader then
	vim.loader.enable()
end

require("options")
require("netrw")
require("plugins")
require("lsp")
require("keymaps")
require("terminal")
require("quit")

vim.cmd.colorscheme("tokyonight-storm")
