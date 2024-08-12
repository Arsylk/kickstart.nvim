-- Disable highlight line in terminal
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Detect terminal & disable line highlight',
  pattern = 'term://*',
  callback = function(params)
    local winnr = vim.fn.bufwinid(params.buf)
    vim.api.nvim_set_option_value('cursorline', false, { win = winnr })
  end,
})

-- Auto create directories before file save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ':p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})
