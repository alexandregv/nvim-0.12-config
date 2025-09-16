local function find_any_terminal_win()
	for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local b = vim.api.nvim_win_get_buf(w)
		if vim.bo[b].buftype == "terminal" and vim.api.nvim_win_get_config(w).relative == "" then
			return w
		end
	end
	return nil
end

-- Jump to any existing terminal in the current tab, otherwise create one (below, height 10).
local function quickterm(autoinsert)
	local term_win = find_any_terminal_win()
	if term_win then
		vim.api.nvim_set_current_win(term_win)
		if autoinsert then
			vim.cmd("startinsert")
		end
		return
	end

	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_open_win(buf, true, { split = "below", win = 0, height = 10 })
	vim.cmd("terminal")

	if autoinsert then
		vim.cmd("startinsert")
	end
end

-- Always open terminal
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local previousWin = vim.api.nvim_get_current_win()
		quickterm(false)
		vim.api.nvim_set_current_win(previousWin)
	end,
})

-- Keymap
-- //TODO: Replace by a new command, mapped in keymaps.lua
vim.keymap.set("n", "<leader>t", function() quickterm(true) end, { desc = "Jump/Open quick terminal", silent = true })
