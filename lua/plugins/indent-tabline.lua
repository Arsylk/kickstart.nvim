local highlight = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}
return {
  {
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
        -- highlight = highlight,
        char = ' ',
      },
      scope = {
        highlight = highlight,
        char = '»',
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
        for _, name in pairs(highlight) do
          vim.api.nvim_set_hl(0, name .. 'Dim', { ctermfg = 'dim', link = name })
        end
      end)

      require('rainbow-delimiters.setup').setup { highlight = highlight }
      -- require('ibl').setup { scope = { highlight = highlight } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
