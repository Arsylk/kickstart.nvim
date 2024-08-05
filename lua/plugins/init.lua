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
        dap = true,
        lsp_trouble = true,
        overseer = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  { 'tpope/vim-sleuth' },
}
