return {
  {
    'folke/snacks.nvim',
    priority = 1001,
    lazy = false,
    opts = function()
      --- @type table<any, snacks.win.Config>
      local styles = {
        notification = {
          wo = {
            wrap = true,
          },
        },
        notification_history = {
          wo = {
            number = false,
            relativenumber = false,
            signcolumn = 'no',
          },
        },
      }

      --- @type snacks.Config
      return {
        styles = styles,
        notifier = {
          enabled = true,
          style = 'compact',
          date_format = '%I:%M %p',
          margin = {
            right = 0,
            left = 0,
          },
          width = { min = 10, max = 0.4 },
        },
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = {
          enabled = false,
          left = { 'git', 'fold' },
          right = {},
          folds = {
            open = true,
            git_hl = true,
          },
          git = {
            patterns = { 'GitSigns' },
          },
        },
        words = { enabled = false },
        toggle = {
          enabled = true,
          map = vim.keymap.set,
          which_key = true,
          notify = true,
          icon = {
            enabled = '󰨚',
            disabled = '󰨙',
          },
          color = {
            enabled = 'blue',
            disabled = 'black',
          },
        },
      }
    end,
    init = function()
      require 'snacks'
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.log = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.log

          -- enable notifier
          Snacks.notifier.health()

          -- create basic toggle mappings
          Snacks.toggle.option('background', { name = 'Dark Background', on = 'dark', off = 'light' }):map '<leader>tb'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>trn'
          Snacks.toggle.diagnostics():map '<leader>td'
          Snacks.toggle.line_number():map '<leader>tln'
          Snacks.toggle.treesitter():map '<leader>tt'
          Snacks.toggle.inlay_hints():map '<leader>th'
        end,
      })
    end,
    keys = {
      {
        '<leader>nd',
        function()
          Snacks.notifier.hide()
        end,
        desc = '[N]otify [D]ismiss',
      },
      {
        '<leader>nN',
        function()
          Snacks.notifier.show_history()
        end,
        desc = '[N]otify History',
      },
      {
        '<leader>nn',
        function()
          local history = Snacks.notifier.get_history()
          local last = history[#history]
          Snacks.notifier.show_history {
            --- @param notif snacks.notifier.Notif
            filter = function(notif)
              return notif.id == last.id
            end,
          }
        end,
        desc = '[N]otify History',
      },
    },
  },
}
