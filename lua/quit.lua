-- Auto close terminals and netrw when no real file windows remain
local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

vim.api.nvim_create_augroup("netrw_term_close", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = "netrw_term_close",
  callback = function()
    local wins = vim.api.nvim_list_wins()
    local only_netrw_or_term = true
    local has_netrw = false
    local term_bufs = {}

    for _, win in ipairs(wins) do
      -- Skip floating windows (ui2 cmd/msg/dialog/pager, LSP popups, ...)
      if not is_floating(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        local ft  = vim.bo[buf].filetype
        local bt  = vim.bo[buf].buftype
        local is_real = ft ~= "netrw" and bt ~= "terminal" and ft ~= "qf"
        if is_real then
          only_netrw_or_term = false
          break
        end
        if ft == "netrw" then
          has_netrw = true
        elseif bt == "terminal" then
          table.insert(term_bufs, buf)
        end
      end
    end

    if not only_netrw_or_term then return end

    -- Close all terminal buffers (kills jobs; avoids hanging Neovim)
    for _, b in ipairs(term_bufs) do
      pcall(vim.api.nvim_feedkeys(":q\r", "n", false), b, {})
    end

    -- After terminals are gone, if netrw is the only remaining window, quit it.
    vim.schedule(function()
      local real_wins = vim.tbl_filter(function(w)
        return not is_floating(w)
      end, vim.api.nvim_list_wins())

      if #real_wins == 1 and has_netrw then
        local buf = vim.api.nvim_win_get_buf(real_wins[1])
        if vim.bo[buf].filetype == "netrw" then
          vim.cmd("quit")
        end
      end
    end)
  end,
})
