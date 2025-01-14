return {
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp = {
        diagnostic_update_events = { 'BufWritePost', 'InsertLeave', 'TextChanged' },
      },
      verbose = {
        no_code_found = true,
      },
    },
    config = function(_, opts)
      require('otter').setup(opts)
    end,
  },
}
