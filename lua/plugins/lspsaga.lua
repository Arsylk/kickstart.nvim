return {
  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
<<<<<<< HEAD
    config = function(_, opts)
      opts = opts or {}
      require 'lspconfig.util'
=======
    opts = {
      ui = {
        devicon = true,
      },
    },
    config = function(_, opts)
      opts = opts or {}
>>>>>>> 59001e7a4709e4f1ec8a3f53eaec2508008cc44d
    end,
  },
}
