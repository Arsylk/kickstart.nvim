return {
  {
    'nvimdev/dashboard-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
              group = '@property',
              action = 'enew',
              key = 'n',
            },
            {
              icon = ' ',
              desc = 'jumps',
              group = '@string',
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
