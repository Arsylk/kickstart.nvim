return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'onsails/lspkind.nvim',
      {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = {
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-cmdline',
          'hrsh7th/cmp-buffer',
          'ray-x/cmp-treesitter',
          'saadparwaiz1/cmp_luasnip',
        },
      },
    },
    config = function()
      -- see `:help cmp`
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- for an understanding of why these mappings were
        -- chosen, you will need to reaźd `:help ins-completion`
        --
        -- no, but seriously. please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<c-n>'] = cmp.mapping.select_next_item(),
          ['<c-p>'] = cmp.mapping.select_prev_item(),
          ['<c-pgdown'] = cmp.mapping.scroll_docs(-4),
          ['<c-pgup>'] = cmp.mapping.scroll_docs(4),
          ['<cr>'] = cmp.mapping.confirm { select = true },
          ['<c-space>'] = cmp.mapping.complete {},
          ['<tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<s-tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }), -- for more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/l3mon4d3/luasnip?tab=readme-ov-file#keymaps
        },
        window = {
          completion = cmp.config.window.bordered {
            scrollbar = false,
            col_offset = -3,
            side_padding = 0,
            winhighlight = 'normal:normal,floatborder:floatborder,cursorline:visual,search:none',
          },
          documentation = cmp.config.window.bordered {
            winhighlight = 'normal:normal,floatborder:floatborder,cursorline:visual,search:none',
          },
        },
        formatting = {
          expandable_indicator = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
            }(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. strings[1] .. ' '
            kind.menu = '    (' .. strings[2] .. ')'

            return kind
          end,
        },
        view = {
          entries = { name = 'custom', selection_order = 'near_cursor' },
        },
        experimental = {
          ghost_text = true,
        },
        sources = cmp.config.sources({
          name = 'lazydev',
          group_index = 0,
        }, {
          name = 'luasnip',
          group_index = 1,
          option = { use_show_condition = true },
          entry_filter = function()
            local context = require 'cmp.config.context'
            return not context.in_treesitter_capture 'string' and not context.in_syntax_group 'string'
          end,
        }, {
          name = 'nvim_lsp',
          group_index = 2,
        }, {
          name = 'nvim_lua',
          group_index = 3,
        }, {
          name = 'treesitter',
          group_index = 4,
          keyword_length = 4,
        }, {
          name = 'path',
          group_index = 5,
        }, {
          name = 'buffer',
          group_index = 5,
        }),
      }

      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline {},
        sources = cmp.config.sources {
          { name = 'cmdline' },
          { name = 'nvim_lua' },
          { name = 'path' },
        },
      })
    end,
  },
}
