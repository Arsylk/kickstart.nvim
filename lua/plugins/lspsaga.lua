return {
  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function(_, opts)
      opts = opts or {}
    end,
  },
}
