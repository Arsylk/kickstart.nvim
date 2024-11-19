return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ibhagwan/fzf-lua' },
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'trouble: Diagnostics',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'trouble: Buffer Diagnostics',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'trouble: Symbols',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'trouble: LSP Definitions / references / ...',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'trouble: Location List',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'trouble: Quickfix List',
      },
    },
    opts = {
      auto_preview = false,
      use_diagnostic_signs = true,
      signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
      modes = {
        lsp_document_symbols = {
          title = '{hl:Title}Document Symbols{hl} {count}',
          desc = 'document symbols',
          events = {
            'BufEnter',
            -- symbols are cached on changedtick,
            -- so it's ok to refresh often
            { event = 'TextChanged', main = true },
            { event = 'CursorMoved', main = true },
            { event = 'LspAttach', main = true },
          },
          source = 'lsp.document_symbols',
          groups = {
            { 'filename', format = '{file_icon} {filename} {count}' },
          },
          sort = { 'filename', 'pos', 'text' },
          -- sort = { { buf = 0 }, { kind = "Function" }, "filename", "pos", "text" },
          format = '{kind_icon} {symbol.name} {kind:Comment} {pos}',
        },
      },
    },
    config = function(_, opts)
      require('trouble').setup(opts)
      local config = require 'fzf-lua.config'
      local actions = require('trouble.sources.fzf').actions
      config.defaults.actions.files['ctrl-t'] = actions.open
    end,
  },
}
