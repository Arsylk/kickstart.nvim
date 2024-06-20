return {
  {
    'folke/trouble.nvim',
    opts = {
      modes = {
        test = {
          mode = 'diagnostics',
          preview = {
            relative = 'win',
            type = 'split',
            position = 'right',
            size = 0.35,
          },
        },
      },
    },
    cmd = 'Trouble',
  },
}
