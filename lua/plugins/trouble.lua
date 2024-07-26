return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- icons = true,
      use_diagnostic_signs = true,
      signs = {
        -- icons / text used for a diagnostic
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '',
      },
      modes = {
        symbols = {
          desc = 'document symbols',
          mode = 'lsp_document_symbols',
          focus = false,
          win = { position = 'right' },
          filter = {
            -- remove Package since luals uses it for control flow structures
            ['not'] = { ft = 'lua', kind = 'Package' },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { 'help', 'markdown' },
              -- default set of symbol kinds
              kind = {
                'Class',
                'Constructor',
                'Enum',
                'Field',
                'Function',
                'Interface',
                'Method',
                'Module',
                'Namespace',
                'Package',
                'Property',
                'Struct',
                'Trait',
              },
            },
          },
        },
        test = {
          mode = 'diagnostics',
          preview = {
            relative = 'win',
            type = 'split',
            position = 'right',
            size = 0.35,
          },
        },
      },
    },
  },
}
