return {
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    event = 'VeryLazy',
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        opts = {},
        format = {
          lua = {
            pattern = {
              '^:%s*lua%s+',
              '^:%s*lua%s*=%s*',
              '^:%s*I%s+',
            },
            icon = '',
            lang = 'lua',
          },
          calculator = { pattern = '^:=', icon = '', lang = 'vimnormal' },
        },
      },
      messages = {
        enabled = true,
        -- view = 'mini',
        -- view_warn = 'mini',
        -- view_error = 'mini',
        -- view_history = 'messages',
        view_search = 'virtualtext',
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      redirect = {
        view = 'split',
        filter = { event = 'msg_show' },
      },
      notify = {
        enabled = false,
        view = 'mini',
      },
      lsp = {
        progress = {
          enabled = false,
          format = 'lsp_progress',
          format_done = 'lsp_progress_done',
          throttle = 1000 / 60,
          view = 'mini',
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = {
          enabled = true,
          silent = true,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 100,
          },
          view = nil,
          opts = {},
        },
        messages = {
          enabled = true,
          view = 'notify',
          opts = {},
        },
        documentation = {
          view = 'hover',
          opts = {
            lang = 'markdown',
            replace = true,
            render = 'plain',
            format = { '{message}' },
            win_options = {
              concealcursor = 'n',
              conceallevel = 3,
            },
          },
        },
      },
      presets = {
        bottom_search = true,
        -- command_palette = true,
        lsp_doc_border = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
          win_options = {
            wrap = true,
          },
        },
        popupmenu = {
          relative = 'editor',
          position = {
            row = 8,
            col = '50%',
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
          },
        },
      },
      format = {
        details = {
          '{date} ',
          '{level} ',
          '{event}',
          { '{kind}', before = { '.', hl_group = 'NoiceFormatKind' } },
          ' ',
          '{title} ',
          '{cmdline} ',
          '{message}',
        },
        fzf = {
          '{date} ',
          '{event} ',
          '{title} ',
          '{message}',
        },
        fzf_preview = {
          'Title: ',
          '{title}',
          '\n',
          'Level: ',
          '{level}',
          '\n',
          'Event: ',
          '{event}',
          '\n',
          'Kind: ',
          { '{kind}', before = { '', hl_group = 'NoiceFormatKind' } },
          '\n',
          'Cmdline: ',
          '{cmdline}',
          '\n',
          'Date: ',
          '{date} ',
          '\n',
          '\n',
          '{message}',
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '^%d+ changes?; after #%d+' },
              { find = '^%d+ changes?; before #%d+' },
              { find = '^Hunk %d+ of %d+$' },
              { find = '^%d+ fewer lines;?' },
              { find = '^%d+ more lines?;?' },
              { find = '^%d+ line less;?' },
              { find = '^Already at newest change' },
              { kind = 'wmsg' },
              { kind = 'emsg', find = 'E486:' },
              { kind = 'emsg', find = 'E21:' },
              { kind = 'emsg', find = 'E382:' },
              { kind = 'quickfix' },
            },
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '^%d+ lines .ed %d+ times?$' },
              { find = '^%d+ lines yanked$' },
              { kind = 'emsg', find = 'E490' },
              -- { kind = 'search_count' },
            },
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'notify',
            any = {
              { find = '^No code actions available$' },
              { find = '^No information available$' },
            },
          },
          view = 'mini',
        },
      },
    },
  },
}
