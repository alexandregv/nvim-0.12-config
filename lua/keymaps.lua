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

local function lsp_definition() vim.lsp.buf.definition() end
local function lsp_declaration() vim.lsp.buf.declaration() end
local function lsp_references() vim.lsp.buf.references() end
local function lsp_implem() vim.lsp.buf.implementation() end
local function lsp_rename() vim.lsp.buf.rename() end
local function lsp_code_action() vim.lsp.buf.code_action() end
local function lsp_codelens_run() vim.lsp.codelens.run() end
local function lsp_format() vim.lsp.buf.format({ async = true }) end
local function lsp_inlay_hint() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
local function diag_float() vim.diagnostic.open_float() end

keymap("n", "gd", lsp_definition,  { noremap = true, silent = true, desc = "Go to definition (LSP)" })
keymap("n", "gD", lsp_declaration, { noremap = true, silent = true, desc = "Go to declaration (LSP)" })
keymap("n", "gr", lsp_references,  { noremap = true, silent = true, desc = "Go to references (LSP)" })
keymap("n", "gi", lsp_implem,      { noremap = true, silent = true, desc = "Go to implementation (LSP)" })
keymap("n", "gl", diag_float,      { noremap = true, silent = true, desc = "Show diagnostics (LSP)" })
keymap("n", "<leader>ld", lsp_definition,   { desc = "Go to definition" })
keymap("n", "<leader>lr", lsp_references,   { desc = "Go to references" })
keymap("n", "<leader>li", lsp_implem,       { desc = "Go to implementation" })
keymap("n", "<leader>lD", lsp_declaration,  { desc = "Go to declaration" })
keymap("n", "<leader>ls", diag_float,       { desc = "Show line diagnostics" })
keymap("n", "<leader>ln", lsp_rename,       { desc = "Rename symbol" })
keymap("n", "<leader>la", lsp_code_action,  { desc = "Code action" })
keymap("n", "<leader>lf", lsp_format,       { desc = "Format file" })
keymap("n", "<leader>lh", lsp_inlay_hint,   { desc = "Toggle Inlay Hints", silent = true })
keymap("n", "<leader>lc", lsp_codelens_run, { desc = "Run CodeLens" })

-- Comment
keymap("n", "<leader>/", function()
  return require("Comment.api").call("toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"), "g@$")() end,
  { expr = true, silent = true, desc = "Toggle comment line" }
)
keymap("x", "<leader>/","<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Symbols
vim.keymap.set("n", "<leader>s", "<cmd>AerialToggle!<CR>", { desc = "Toggle Symbols (Aerial)" })


-- Keep track of the last window we came from
local last_win = nil
local function jump_float()
  local cur_win = vim.api.nvim_get_current_win()

  -- If we're in a floating window and have a stored window, go back
  if vim.api.nvim_win_get_config(cur_win).relative ~= "" and last_win and vim.api.nvim_win_is_valid(last_win) then
    vim.api.nvim_set_current_win(last_win)
    last_win = nil
    return
  end

  -- Otherwise, try to find a floating window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- floating window
      last_win = cur_win
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

vim.keymap.set("n", "<C-w>f", jump_float, { desc = "Jump to/from floating window" })
