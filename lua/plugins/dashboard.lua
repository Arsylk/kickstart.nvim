return {
  {
    'nvimdev/dashboard-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            {
              icon = ' ',
              desc = 'new',
              group = '@string',
              action = 'enew',
              key = 'n',
            },
            {
              icon = '󰋚 ',
              desc = 'recent',
              group = '@exception',
              action = 'FzfLua oldfiles',
              key = 'r',
            },
            {
              icon = ' ',
              desc = 'jumps',
              group = '@property',
              action = 'FzfLua jumps',
              key = 'j',
            },
            {
              icon = ' ',
              desc = 'dotfiles',
              group = 'Number',
              action = 'FzfLua files cwd=~/.config/nvim',
              key = 'd',
            },
          },
          project = {
            enable = true,
            action = 'FzfLua files cwd=',
          },
        },
      }
    end,
  },
}
