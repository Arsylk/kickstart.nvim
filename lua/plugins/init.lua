return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
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
        dap = true,
        lsp_trouble = true,
        overseer = true,
        illuminate = {
          enabled = true,
          lsp = true,
        },
      },
      term_colors = true,
    },
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
