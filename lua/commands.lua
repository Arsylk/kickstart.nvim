-- Quick inspect lua objects
vim.cmd [[:command! -nargs=1 I lua inspectFn(<f-args>)]]
function inspectFn(obj)
  local cmd = string.format('lua print(vim.inspect(%s))', obj)
  require('noice').redirect(cmd, { view = 'hsplit', filter = {
    cond = function(_)
      return true
    end,
  } })
end

-- Redirect command output into new buffer
vim.api.nvim_create_user_command('Redir', function(ctx)
<<<<<<< HEAD
  local exec = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(exec.output, '\n', { plain = true })
=======
  local lines = vim.split(vim.api.nvim_exec(ctx.nargs, true), '\n', { plain = true })
>>>>>>> 59001e7a4709e4f1ec8a3f53eaec2508008cc44d
  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

-- Perform live(ish) command operations
vim.api.nvim_create_user_command('Playdict', function(ctx)
  local output = vim.api.nvim_exec(ctx.args, true)
  local bufs = vim.fn.tabpagebuflist()
  local selfbuf = vim.api.nvim_get_current_buf()
  for i = 1, #bufs, 1 do
    if selfbuf ~= bufs[i] then
      local lines = vim.split(output, '\n', { plain = true })
      vim.api.nvim_buf_set_lines(bufs[i], 0, -1, false, lines)
      break
    end
  end
end, { bang = true, nargs = '+', complete = 'command' })
