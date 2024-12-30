vim.b.minihipatterns_disable = true
vim.keymap.set('n', '<leader>fg', function()
  local cmd = [[FzfLua live_grep]]
  local dir = require('oil').get_current_dir()
  if dir then
    cmd = string.format('%s cwd=%s', cmd, dir)
  end
  vim.cmd(cmd)
end, {
  buffer = true,
  noremap = true,
  desc = '[F]ind by [G]rep',
})
vim.keymap.set('n', '<leader>ff', function()
  local cmd = [[FzfLua files]]
  local dir = require('oil').get_current_dir()
  if dir then
    cmd = string.format('%s cwd=%s', cmd, dir)
  end
  vim.cmd(cmd)
end, {
  buffer = true,
  noremap = true,
  desc = '[F]ind [F]iles',
})
