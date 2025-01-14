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
    vim.schedule(function()
      vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = params.buf,
        once = true,
        callback = function(ctx)
          vim.schedule(function()
            vim.api.nvim_buf_delete(ctx.buf, {})
          end)
        end,
      })
    end)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'snacks_notif', 'snacks_notif_history' },
  callback = function()
    -- vim.api.nvim_set_hl(0, '@spell.markdown', { link = '@text' })
    vim.api.nvim_set_hl(0, '@markup.strong.markdown_inline', { link = '@spell.markup', bold = true })
    vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { link = '@markup.heading' })
  end,
})
