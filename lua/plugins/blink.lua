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
  Snippet = '󰕢 ',
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
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'xzbdmw/colorful-menu.nvim' },
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      completion = {
        list = {
          selection = {
            auto_insert = false,
          },
        },

        keyword = {
          range = 'full',
        },

        documentation = {
          auto_show = true,
          window = {
            border = 'rounded',
            scrollbar = false,
          },
        },

        ghost_text = {
          enabled = false,
        },

        menu = {
          winhighlight = 'Normal:Normal,FloatBorder:@keyword,CursorLine:Bold',
          border = 'rounded',
          scrollbar = false,
          auto_show = function(ctx)
            return not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos
              return { pos[1], pos[2] - 4 }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          draw = {
            align_to = 'none',
            columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'source_name' } },
            components = {
              label = {
                width = { fill = true, min = 18, max = 60 },
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                highlight = function(ctx)
                  local cap = ctx.kind:gsub('^%l', string.upper)
                  return string.format('BlinkCmpKind%s', cap)
                end,
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name:lower()
                end,
                highlight = 'BlinkCmpSource',
              },
              cmdline_label = {
                width = { fixed = 60 },
                text = function(ctx)
                  return ctx.label
                end,
                highlight = function(ctx)
                  local highlights = { { 0, #ctx.label, group = 'BlinkCmpLabel' } }
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = '@keyword' })
                  end
                  return highlights
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },

      keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      },

      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
            draw = {
              columns = {
                { 'cmdline_label' },
              },
            },
          },
        },
        sources = { 'cmdline' },
      },
    },

    --@module 'blink.cmp'
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend('force', { name = source, module = 'blink.compat.source' }, opts.sources.providers[source] or {})
        if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend('force', opts.appearance.kind_icons or {}, kinds)
      require('blink-cmp').setup(opts)
    end,
  },
}
