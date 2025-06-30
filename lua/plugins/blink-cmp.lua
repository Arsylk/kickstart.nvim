local kinds = require('config.icons').get 'kind'

return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'xzbdmw/colorful-menu.nvim', 'L3MON4D3/LuaSnip' },
    build = 'cargo build --release',

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
            winhighlight = 'Normal:Normal,FloatBorder:@keyword,CursorLine:Bold',
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
            if vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
              return { vim.o.lines - 1, 0 }
            end
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos
              return { pos[1], pos[2] - 4 }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          draw = {
            align_to = 'none',
            columns = function(ctx)
              if ctx.get_mode() == 'cmdline' then
                return { { 'cmdline_label' } }
              end
              return { { 'kind_icon' }, { 'label', gap = 1 }, { 'source_name' } }
            end,
            components = {
              label = {
                width = { fill = true, min = 18, max = 60 },
                text = function(ctx)
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                  end
                  return highlights
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
          buffer = {
            max_items = 5,
            min_keyword_length = 2,
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
          list = {
            selection = {
              preselect = false,
            },
          },
        },
        sources = { 'cmdline' },
      },
      snippets = {
        preset = 'luasnip',
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction)
          require('luasnip').jump(direction)
        end,
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
  {
    enabled = false,
    'saghen/blink.nvim',
    opts = {
      indent = {
        enabled = true,
        -- start with indent guides visible
        visible = true,
        blocked = {
          buftypes = {
            'prompt',
          },
          filetypes = {
            'dashboard',
            'noice',
            'snacks_notif',
            'whichkey',
            'oil',
            'oil_preview',
            'blink-cmp-menu',
          },
        },
        static = {
          enabled = false,
          char = '▏',
          priority = 1,
          highlights = {
            'BlinkIndent',
          },
        },
        scope = {
          enabled = true,
          char = '▏',
          priority = 16,
          highlights = {
            'rainbow1',
            'rainbow2',
            'rainbow3',
            'rainbow4',
            'rainbow5',
            'rainbow6',
          },
          underline = {
            enabled = false,
            highlights = {
              'rainbow1',
              'rainbow2',
              'rainbow3',
              'rainbow4',
              'rainbow5',
              'rainbow6',
            },
          },
        },
      },
    },
  },
}
