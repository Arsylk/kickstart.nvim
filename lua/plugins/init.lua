return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
        },
        dashboard = true,
        fidget = true,
        mason = true,
        telescope = {
          enabled = true,
        },
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      local theme = require 'catppuccin.palettes.mocha'
      local highlight = {
        RainbowCyan = theme.teal,
        RainbowRed = theme.red,
        RainbowYellow = theme.yellow,
        RainbowBlue = theme.blue,
        RainbowOrange = theme.peach,
        RainbowGreen = theme.green,
        RainbowViolet = theme.maroon,
      }
      vim.g.rainbow_delimiters = { highlight = highlight }
    end,
  },
  { 'tpope/vim-sleuth' },
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'catppuccin/nvim' },
    main = 'ibl',
    opts = {
      indent = vim.g.rainbow_delimiters,
      exclude = {
        filetypes = {
          'dashboard',
        },
      },
    },
    config = function(_, opts)
      require 'catppuccin'
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for name, value in pairs(vim.g.rainbow_delimiters) do
          print(name, value)
          vim.api.nvim_set_hl(0, name, { fg = value })
        end
      end)

      opts.scope = {
        highlight = {
          'RainbowDelimiterCyan',
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
        },
      }
      require('ibl').setup(opts)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
