function repl(hex)
  local r = tonumber(hex:sub(1 + 2, 1 + 3), 16)
  local g = tonumber(hex:sub(1 + 4, 1 + 5), 16)
  local b = tonumber(hex:sub(1 + 6, 1 + 7), 16)

  local rgb = string.format('"rgb(%d, %d, %d)"', r, g, b)
  local num = string.format('"0xff%02x%02x%02xx"', r, g, b)
  local key = string.format('"\\\\x1b[38;2;%d;%d;%dm"', r, g, b)

  local fmts = { hex, rgb, num, key }
  return '[ ' .. vim.fn.join(fmts, ', ') .. ' ]'
end
function recolor()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i in ipairs(lines) do
    lines[i] = string.gsub(lines[i], '"#%x%x%x%x%x%x"', repl)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
