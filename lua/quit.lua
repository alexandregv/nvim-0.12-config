-- Auto close terminals and netrw when no real file windows remain
vim.api.nvim_create_augroup("netrw_term_close", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = "netrw_term_close",
  callback = function()
    local wins = vim.api.nvim_list_wins()
    local only_netrw_or_term = true
    local has_netrw = false
    local term_bufs = {}

    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft  = vim.bo[buf].filetype
      local bt  = vim.bo[buf].buftype
      if ft == "netrw" then
        has_netrw = true
      elseif bt == "terminal" then
        table.insert(term_bufs, buf)
      else
        only_netrw_or_term = false
        break
      end
    end

    if not only_netrw_or_term then return end

    -- Close all terminal buffers (kills jobs; avoids hanging Neovim)
    for _, b in ipairs(term_bufs) do
      pcall(vim.api.nvim_buf_delete, b, { force = true })
    end

    -- After terminals are gone, if netrw is the only remaining window, quit it.
    vim.schedule(function()
      if #vim.api.nvim_list_wins() == 1 and has_netrw then
        local buf = vim.api.nvim_win_get_buf(0)
        if vim.bo[buf].filetype == "netrw" then
          vim.cmd("quit")
        end
      end
    end)
  end,
})
