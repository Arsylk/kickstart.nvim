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
<<<<<<< HEAD
=======
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
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
>>>>>>> b36a320a240fbe0c351dea13f855ec46433f6012
        },
      }
    end,
  },
}
