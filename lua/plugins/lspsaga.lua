return {
  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    opts = {
      ui = {
        devicon = true,
      },
    },
    config = function(_, opts)
      opts = opts or {}
    end,
  },
}
