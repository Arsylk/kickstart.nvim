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
              '^:%s*=%s*',
              '^:%s*I%s+',
            },
            icon = '',
            lang = 'lua',
          },
        },
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_warn = 'mini',
        view_error = 'mini',
        view_history = 'messages',
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
        enabled = true,
        view = 'notify',
      },
      lsp = {
        progress = {
          enabled = true,
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
        command_palette = false,
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
      routes = {
        --        {
        --          filter = {
        --            event = 'msg_show',
        --            kind = 'search_count',
        --          },
        --          opts = {
        --            skip = true,
        --          },
        --        },
        {
          view = 'split',
          filter = {
            event = { 'msg_show' },
            min_height = 20,
          },
        },
      },
    },
  },
}
