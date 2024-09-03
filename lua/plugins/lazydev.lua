return {
  {
    'folke/lazydev.nvim',
    dependencies = { 'hrsh7th/nvim-cmp', optional = true },
    ft = 'lua',
    opts = {
      library = {
        vim.env.HOME .. '.local/share/nvim/lazy/luvit-meta/library/',
        vim.env.LAZY_PATH,
        -- You can also add plugins you always want to have loaded.
        -- Useful if the plugin has globals or types you want to use
        -- vim.env.LAZY .. "/LazyVim", -- see below
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
}
