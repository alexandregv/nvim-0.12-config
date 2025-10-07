local keymap = vim.keymap.set

-- Basic keymaps --
keymap("x", "sy", '"+y',                        { silent = true, desc = "Yank to system clipboard in Visual" })
keymap("t", "<Esc>", [[<C-\><C-n>]],            { silent = true, desc = "Leave terminal" }) -- Leave terminal with Esc
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { silent = true, desc = ":noh" }) -- Turn down current search result highlighting

-- netrw (jump to existing netrw, open it if needed, jump back to file buffer)
keymap("n", "<leader>f", function()
  -- If currently in netrw, go back to file buffer
  if vim.bo.filetype == "netrw" then
    vim.cmd("wincmd p")
    return
  end
  -- Look for an existing netrw window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  -- Otherwise, open netrw
  vim.cmd("Lexplore %:p:h")
  vim.cmd("wincmd p") -- return focus to file buffer
end, { desc = "Toggle netrw" })

-- Plugins keymaps --
if not vim.pack then -- pack needs nvim 0.12+, skip following keymaps if plugins couldn't be installed
	return
end

vim.keymap.set("n", "<leader>F", "<cmd>FzfLua files<CR>", { desc = "Browse files with FzfLua" })

-- LSP
require("which-key").add({
  { "<leader>l", group = "LSP" },
})
keymap("n", "gd", function() vim.lsp.buf.definition() end, { noremap = true, silent = true, desc = "Go to definition (LSP)" })
keymap("n", "<leader>ld", "gd")
keymap("n", "<leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints", silent = true })

-- Comment
keymap("n", "<leader>/", function()
  return require("Comment.api").call("toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"), "g@$")() end,
  { expr = true, silent = true, desc = "Toggle comment line" }
)
keymap("x", "<leader>/","<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Symbols
vim.keymap.set("n", "<leader>s", "<cmd>AerialToggle!<CR>", { desc = "Toggle Symbols (Aerial)" })
