vim.keymap.set({ 'n', 'c' }, '<F8>', function()
  local wins = vim.api.nvim_list_wins()
  for _, win in pairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local type = vim.bo[buf].filetype

    log { win = win, buf = buf, name = vim.api.nvim_buf_get_name(buf), ft = type }
  end
end)
