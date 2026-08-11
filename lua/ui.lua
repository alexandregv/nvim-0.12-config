require("vim._core.ui2").enable({
	enable = true,
	msg = { targets = "msg" },
})

-- Make cmdline overwrite statusline (opt.cmdheight=0 doesn't work anymore with ui2)
local laststatus = vim.o.laststatus
local depth = 0
vim.api.nvim_create_autocmd('CmdlineEnter', {
	callback = function()
		if depth == 0 then
			vim.o.laststatus = 0
		end
		depth = depth + 1
	end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
	callback = function()
		depth = math.max(0, depth - 1)
		if depth == 0 then
			vim.o.laststatus = laststatus
		end
	end,
})
