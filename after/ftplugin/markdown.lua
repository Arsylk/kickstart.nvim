local function rfind(s, pattern, init, plain)
  for i = init or #s, 1, -1 do
    local j, k = string.find(s, pattern, i, plain)
    if j then
      return j, k
    end
  end
  return nil
end

vim.keymap.set('n', 'ss', function()
  local modifiable = vim.api.nvim_get_option_value('modifiable', { buf = 0 })
  if not modifiable then
    local n = require 'snacks.notify'
    n.error "E21: Cannot make changes, 'modifiable' is off"
    return
  end

  -- 03:53:07    Error  msg_show.emsg E21: Cannot make changes, 'modifiable' is off
  -- 03:53:36    Error  notify.error E21: Cannot make changes, 'modifiable' is off
  local row, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  local textline = vim.api.nvim_get_current_line()
  local subline = string.sub(textline, 0, col)

  -- right find first non-url character
  local fixcol = rfind(subline, '[%s"\'`;|\\^()]')

  -- if fixcol found, start search at it
  local start, stop = string.find(textline, '([A-z0-9]+://[^%s"\'`;|\\^()]+)', fixcol)
  if start and stop then
    local untogglemin = math.max(1, start - 5)
    local untogglemax = math.min(#textline, stop + 1)
    local untoggle1 = string.sub(textline, untogglemin, untogglemin + 4)
    local untoggle2 = string.sub(textline, untogglemax, untogglemax)
    local url = string.sub(textline, start, stop)

    local off = col
    if not (untoggle1 == '[ss](' and untoggle2 == ')') then
      url = string.format('[ss](%s)', url)
      off = off + 5
    else
      start = start - 5
      stop = stop + 1
      off = off - 5
      off = math.max(off, start - 1)
      off = math.min(off, start - 1 + #url - 1)
    end

    if start <= col + 1 and stop > col then
      vim.api.nvim_buf_set_text(0, row - 1, start - 1, row - 1, stop, { url })
      vim.api.nvim_win_set_cursor(0, { row, off })
    end
  end
end, { desc = 'Toggle [ss](...) tag on url' })
