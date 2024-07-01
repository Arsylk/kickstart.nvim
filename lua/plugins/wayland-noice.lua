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
        view_error = 'mini',
        view_warn = 'mini',
        view_history = 'messages',
        view_search = 'virtualtext',
        opts = {},
      },

      lsp = {
        signature = {
          enabled = false,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        lsp_doc_border = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      views = {
        split = {
          enter = true,
        },
        cmdline_popup = {
          border = {
            style = 'none',
            padding = { 2, 1 },
          },
          filter_options = {},
          win_options = {
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
          },
        },
        popupmenu = {
          border = {
            style = 'none',
            padding = { 1, 2 },
          },
          filter_options = {},
          win_options = {
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
          },
          virtualtext = {
            hl_group = 'Search',
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
      messages = {
        enabled = true,
        view = 'mini',
        view_error = 'messages',
        view_warn = 'messages',
        view_history = 'mini',
        view_search = 'virtualtext',
        opts = {},
      },
      notify = {
        enabled = true,
        view = 'mini',
<<<<<<< HEAD
      },
      commands = {
        search = {
          view = 'popup',
          filter = { kind = 'search' },
        },
=======
>>>>>>> 114a1d8d134319567eed1ba649f27e24f83e377b
      },
    },
  },
}
