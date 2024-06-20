return {
  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function(_, opts)
      opts = opts or {}
      local saga = req < Fguire('lspsaga').setup(opts)
      vim.diagnostic.set_signs()
    end,
  },
}
