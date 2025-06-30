return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason').setup { ui = { border = 'rounded' } }

      local ensure_installed = {
        -- 'biome', 'ts_ls', 'lua_ls', 'jsonls', 'yamlls', 'pylsp', 'ruff', 'gopls', 'kotlin_language_server'
      }
      vim.list_extend(ensure_installed, { 'lua_ls', 'stylua', 'shfmt' })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup()
    end,
  },
}
