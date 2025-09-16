local g = vim.g
local cmd = vim.cmd

-- See https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer
g.netrw_keepdir = 0                        -- Keep the current directory and the browsing directory synced. This helps you avoid the move files error.
g.netrw_winsize = 10                       -- Change the size of the Netrw window when it creates a split.
g.netrw_banner = 0                         -- Hide the banner (if you want). To show it temporarily you can use I inside Netrw.
g.netrw_localcopydircmd = 'cp -r'          -- Change the copy command. Mostly to enable recursive copy of directories.
cmd.highlight("link netrwMarkFile Search") -- Highlight marked files in the same way search matches are.
g.netrw_liststyle=3                        -- Proper tree view

-- Always open netrw
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("Lexplore %:p:h")
    vim.cmd("wincmd p")
  end,
})

-- Custom netrw keymaps (see https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.keymap.set('n', '<C-c>', '<cmd>bd<CR>', { buffer = true, silent = true })        -- Close the current Netrw buffer
        vim.keymap.set('n', '<Tab>', 'mf', { buffer = true, remap = true, silent = true })   -- Mark the file/directory to the mark list
        vim.keymap.set('n', '<S-Tab>', 'mF', { buffer = true, remap = true, silent = true }) -- Unmark all the files/directories
    end
})
