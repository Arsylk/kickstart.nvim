local highlight_keys = {
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
}

return {
  {
    enabled = not vim.g.vscode,
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'catppuccin/nvim', 'HiPhish/rainbow-delimiters.nvim' },
    main = 'ibl',
    opts = {
      exclude = {
        filetypes = {
          'dashboard',
        },
      },
      indent = {
        char = ' ',
      },
      scope = {
        char = '▏',
        show_start = false,
        include = {
          node_type = { lua = { 'table_constructor' } },
        },
      },
    },
    config = function(_, opts)
      require('ibl').setup(opts)

      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for _, key in pairs(highlight_keys) do
          local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(key)), 'fg#')
          vim.api.nvim_set_hl(0, key, { fg = color })
        end
      end)

      require('rainbow-delimiters.setup').setup { highlight = highlight_keys }
      opts.scope.highlight = highlight_keys
      require('ibl').setup(opts)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
