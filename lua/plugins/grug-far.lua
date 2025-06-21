return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup {}

      vim.api.nvim_set_keymap('n', '<leader>gr', '', {
        callback = function()
          require('grug-far').open {
            prefills = {
              search = vim.fn.expand '<cword>',
              paths = vim.fn.expand '%',
            },
          }
        end,
      })
      vim.api.nvim_set_keymap('n', '<leader>gR', '', {
        callback = function()
          require('grug-far').open {
            prefills = {
              search = vim.fn.expand '<cword>',
            },
          }
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'grug-far' },
        desc = 'Quicker close for grug-far',
        callback = function(ctx)
          vim.api.nvim_buf_set_keymap(ctx.buf, 'n', 'qq', [[<Cmd>lua require('grug-far').get_instance(0):close()]], {})
        end,
      })

      local ok, oil = pcall(require, 'oil')
      if ok then
        oil.setup {
          keymaps = {
            ['<leader>gr'] = {
              callback = function()
                local prefills = { paths = oil.get_current_dir() }
                local grug_far = require 'grug-far'
                local instance = grug_far.get_instance 'explorer'
                if instance == nil then
                  grug_far.open {
                    instanceName = 'explorer',
                    prefills = prefills,
                    staticTitle = 'Find and Replace - Oil',
                  }
                else
                  instance:open()
                  instance:update_input_values(prefills, false)
                end
              end,
            },
          },
        }
      end
    end,
  },
}
