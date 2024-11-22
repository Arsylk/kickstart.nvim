return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      toggle = {
        enabled = true,
        map = vim.keymap.set,
        which_key = true,
        notify = true,
        icon = {
          enabled = '󰨚',
          disabled = '󰨙',
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          -- create basic toggle mappings
          Snacks.toggle.option('background', { name = 'Dark Background', on = 'dark', off = 'light' }):map '<leader>tb'
          Snacks.toggle.option('wrap', { name = 'Wrapr' }):map '<leader>tw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>trn'
          Snacks.toggle.diagnostics():map '<leader>td'
          Snacks.toggle.line_number():map '<leader>tln'
          Snacks.toggle.treesitter():map '<leader>tt'
          Snacks.toggle.inlay_hints():map '<leader>tih'
        end,
      })
    end,
  },
}
