return {
  {
    'okuuva/auto-save.nvim',
    init = function()
      local group = vim.api.nvim_create_augroup('autosave', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveEnable',
        group = group,
        callback = function(_)
          vim.g.autosave = true
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveDisable',
        group = group,
        callback = function(_)
          vim.g.autosave = false
        end,
      })
    end,
    opts = {
      enabled = false,
      callbacks = {
        enabling = function()
          vim.notify('autosave on ', vim.log.levels.WARN)
          vim.g.autosave = true
        end,
        disabling = function()
          vim.notify('autosave off', vim.log.levels.WARN)
          vim.g.autosave = false
        end,
      },
    },
  },
}
