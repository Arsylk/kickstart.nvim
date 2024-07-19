return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- icons = true,
      use_diagnostic_signs = true,
      signs = {
        -- icons / text used for a diagnostic
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
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
  },
}
