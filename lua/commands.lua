vim.cmd [[:command! -nargs=1 I lua inspectFn(<f-args>)]]
function inspectFn(obj)
  local cmd = string.format('lua print(vim.inspect(%s))', obj)
  require('noice').redirect(cmd, { view = 'hsplit', filter = {
    cond = function(_)
      return true
    end,
  } })
end
vim.api.nvim_create_user_command('Redir', function(ctx)
  local exec = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(exec.output, '\n', { plain = true })
  vim.cmd 'new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })
