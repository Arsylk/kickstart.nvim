local kinds = {
  Array = ' ',
  Boolean = '󰨙 ',
  Class = ' ',
  Codeium = '󰘦 ',
  Color = ' ',
  Control = ' ',
  Collapsed = ' ',
  Constant = '󰏿 ',
  Constructor = ' ',
  Copilot = ' ',
  Enum = ' ',
  EnumMember = ' ',
  Event = ' ',
  Field = ' ',
  File = ' ',
  Folder = ' ',
  Function = '󰊕 ',
  Interface = ' ',
  Key = ' ',
  Keyword = ' ',
  Method = '󰊕 ',
  Module = ' ',
  Namespace = '󰦮 ',
  Null = ' ',
  Number = '󰎠 ',
  Object = ' ',
  Operator = ' ',
  Package = ' ',
  Property = ' ',
  Reference = ' ',
  Snippet = ' ',
  String = ' ',
  Struct = '󰆼 ',
  TabNine = '󰏚 ',
  Text = ' ',
  TypeParameter = ' ',
  Unit = ' ',
  Value = ' ',
  Variable = '󰀫 ',
}

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
      'saadparwaiz1/cmp_luasnip',
      'windwp/nvim-autopairs',
      'onsails/lspkind.nvim',
      {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = {
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
        },
      },
    },
    event = 'InsertEnter',
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require 'cmp'
      local lsp_kind = require 'lspkind'
      lsp_kind.init()

      local defaults = require 'cmp.config.default'()

      local function confirm_fn(opts)
        return function(fallback)
          opts = vim.tbl_extend('force', {
            select = true,
            behavior = cmp.ConfirmBehavior.Insert,
          }, opts or {})
          if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
            if cmp.confirm(opts) then
              return
            end
          end
          return fallback()
        end
      end

      return {
        preselect = cmp.PreselectMode.Item,
        window = {
          completion = cmp.config.window.bordered {
            winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
          },
          documentation = cmp.config.window.bordered {
            winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
          },
        },
        view = {
          entries = 'bordered',
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert,noselect',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = confirm_fn { behavior = cmp.ConfirmBehavior.Replace },
          ['<S-CR>'] = confirm_fn(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              local luasnip, err = pcall(require, 'luasnip')
              if not err and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              local luasnip, err = pcall(require, 'luasnip')
              if not err and luasnip.expand_or_jumpable() then
                luasnip.jump(-1)
              else
                fallback()
              end
            end
          end, { 'i', 's' }), -- for more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'luasnip', max_item_count = 5, group_index = 1 },
          { name = 'nvim_lsp', max_item_count = 20, group_index = 1 },
          { name = 'nvim_lua', group_index = 1 },
          { name = 'path', group_index = 2 },
          { name = 'buffer', keyword_length = 2, max_item_count = 5, group_index = 2 },
          { name = 'treesitter', group_index = 3 },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          --- @param ctx cmp.Entry
          format = function(ctx, item)
            local icons = kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            item.menu = ctx.source.name
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      local cmp = require 'cmp'
      cmp.setup(opts)
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline {
      --     ['<C-p>'] = cmp.mapping.open_docs,
      --   },
      --   sources = {
      --     { name = 'lazydev', group_index = 0 },
      --     { name = 'cmdline', group_index = 1, max_item_count = 10 },
      --     { name = 'path', group_index = 2 },
      --   },
      -- })
      -- cmp.setup.cmdline('/', {
      --   mapping = cmp.mapping.preset.cmdline {},
      --   sources = cmp.config.sources {
      --     { name = 'buffer' },
      --   },
      -- })
      -- cmp.setup.cmdline(':lua', {
      --   mapping = cmp.mapping.preset.cmdline {},
      --   sources = cmp.config.sources {
      --     { name = 'nvim_lsp' },
      --     { name = 'nvim_lua' },
      --     { name = 'path' },
      --   },
      -- })

      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      cmp.event:on('menu_opened', function(event)
        local entries = event.window:get_entries()
        for _, entry in ipairs(entries) do
          if entry:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
            local item = entry:get_completion_item()
            if not item.documentation and item.insertText then
              item.documentation = {
                kind = cmp.lsp.MarkupKind.Markdown,
                value = string.format('```%s\n%s\n```', vim.bo.filetype, tostring(item.insertText)),
              }
            end
          end
        end
      end)
    end,
  },
}
