local opt = vim.opt
local cmd = vim.cmd
local g = vim.g

g.mapleader = " " -- Set <leader> to Space

opt.autoindent = true -- Enable auto indentation
opt.expandtab = false -- Do not use spaces instead of tabs
opt.tabstop = 2 -- Number of spaces for a tab
opt.softtabstop = 2 -- Number of spaces for a tab when editing
opt.shiftwidth = 2 -- Number of spaces for autoindent
opt.shiftround = true -- Round indent to multiple of shiftwidth

opt.termguicolors = true -- Enable true colors
opt.cmdheight = 0 -- Hide cmdline, shows only when active, on top of statusline
opt.swapfile = false -- Disable swap files
opt.list = false -- Do not show whitespace characters
opt.wrap = false -- Disable line wrapping
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
opt.winborder = "rounded" -- Use rounded borders for windows

opt.number = true -- Show line numbers (fixed)
opt.numberwidth = 2 -- Width of the line number column
opt.cursorline = true -- Highlight the current line
opt.signcolumn = "yes:1" -- Always show sign column
-- opt.colorcolumn = "81" -- Highlight column 81

opt.incsearch = true -- See search while typing
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Smart case in search (needs ignorecase=true too)

opt.undofile = true -- Enable persistent undo
opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Directory for undo files

opt.foldcolumn = '1' -- Show fold column
opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]

cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation
