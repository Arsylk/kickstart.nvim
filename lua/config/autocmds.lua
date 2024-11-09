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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase' },
  desc = 'Auto delete git commit and rebase buffers',
  callback = function(params)
    vim.api.nvim_create_autocmd('BufWritePost', {
      buffer = 0,
      once = true,
      callback = vim.schedule(function()
        vim.api.nvim_buf_delete(0, {})
      end),
    })
  end,
})
