vim.api.nvim_create_user_command('GhidraToStalker', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fixlines = vim.tbl_map(function(value)
    local name, addr = value:match '(.+)\t(.+)'
    addr = tonumber(addr, 16)
    addr = addr - 0x100000
    return ("  '0x%x': '%s',"):format(addr, name)
  end, lines)
  table.insert(fixlines, 1, '{')
  table.insert(fixlines, '}')

  vim.api.nvim_buf_set_lines(0, 0, -1, false, fixlines)
end, { nargs = 0 })
