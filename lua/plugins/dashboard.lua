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
              desc = 'New',
              group = '@property',
              action = 'enew',
              key = 'n',
            },
            {
              icon = ' ',
              desc = 'dotfiles',
              group = 'Number',
              action = 'FzfLua files cwd=~/.config/nvim',
              key = 'd',
            },
          },
        },
      }
    end,
  },
}
