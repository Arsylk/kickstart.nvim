return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = function()
      local colors = require('fancyutil').palette()

      --- @type CatppuccinOptions
      return {
        flavour = 'mocha',
        highlight_overrides = {
          all = {
            SnacksNotifierInfo = { fg = colors.mauve },
            SnacksNotifierIconInfo = { fg = colors.mauve },
            SnacksNotifierTitleInfo = { fg = colors.mauve, style = { 'italic' } },
            SnacksNotifierFooterInfo = { link = 'DiagnosticInfo' },
            SnacksNotifierBorderInfo = { fg = colors.mauve },
          },
        },
        integrations = {
          cmp = true,
          blink_cmp = true,
          gitsigns = true,
          treesitter = true,
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
          fzf = true,
          fidget = true,
          mason = true,
          telescope = {
            enabled = true,
          },
          which_key = true,
          dap = true,
          lsp_trouble = true,
          overseer = true,
          grug_far = true,
          snacks = true,
          illuminate = {
            enabled = true,
            lsp = true,
          },
        },
        term_colors = true,
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = function()
          vim.cmd('Catppuccin ' .. (vim.v.option_new == 'light' and 'latte' or 'mocha'))
        end,
      })
    end,
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    opts = {},
  },
  { 'tpope/vim-sleuth' },
}
