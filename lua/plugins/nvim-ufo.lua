local handler = function(_virtText, _lnum, _endLnum, _width, _truncate)
  return require('pretty-fold').foldtext.global()
end

return {
  {
    'kevinhwang91/nvim-ufo',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter',
      'neovim/nvim-lspconfig',
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require 'statuscol.builtin'
          require('statuscol').setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          }
        end,
      },
    },
    config = function()
      -- setup folding source: first treesitter, then indent as fallback
      ---@diagnostic disable-next-line: missing-fields
      require('ufo').setup {
        provider_selector = function()
          -- return selector
          return { 'treesitter', 'indent' }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
}
