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
            icon = ' ',
            desc = 'New',
            action = 'enew',
            key = 'n',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Recent',
            group = 'Label',
            action = 'find_files',
            key = 'f',
          },
          {
            icon = ' ',
            desc = 'Apps',
            group = 'DiagnosticHint',
            action = 'Telescope app',
            key = 'a',
          },
          {
            desc = ' dotfiles',
            group = 'Number',
            action = 'Telescope dotfiles',
            key = 'd',
          },
        },
      }
    end,
  },
}
