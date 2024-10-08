-- Auto create directories before file save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '/*', 'file://*' },
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ':p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})
