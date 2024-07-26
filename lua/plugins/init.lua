<<<<<<< HEAD
=======
local function get_highlight()
  local theme = require 'catppuccin.groups.integrations.rainbow_delimiters'
  local highlight = {
    RainbowCyan = theme.teal,
    RainbowRed = theme.red,
    RainbowYellow = theme.yellow,
    RainbowBlue = theme.blue,
    RainbowOrange = theme.peach,
    RainbowGreen = theme.green,
    RainbowViolet = theme.maroon,
  }
  return { highlight = highlight }
end

>>>>>>> 59001e7a4709e4f1ec8a3f53eaec2508008cc44d
return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        noice = true,
        neogit = true,
        lsp_saga = true,
        native_lsp = {
          enabled = true,
          hints = { 'italic' },
        },
        rainbow_delimiters = true,
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
<<<<<<< HEAD
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  { 'tpope/vim-sleuth' },
=======
  },
  { 'tpope/vim-sleuth' },
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'catppuccin/nvim' },
    main = 'ibl',
    config = function()
      require 'catppuccin'
      local highlight = get_highlight()
      print('highlight:', highlight)
      local opts = {
        indent = highlight,
        exclude = {
          filetypes = {
            'dashboard',
          },
        },
      }
      require('ibl').setup(opts)
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for name, value in pairs(highlight) do
          vim.api.nvim_set_hl(0, name, { fg = value })
        end
      end)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
>>>>>>> 59001e7a4709e4f1ec8a3f53eaec2508008cc44d
}
