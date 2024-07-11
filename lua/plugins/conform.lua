return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<A-f>',
        function(event)
          local fmt = require('conform').list_formatters_for_buffer(event.buffer)[1]
          local msg = ('Running LSP %s on %s'):format(fmt, vim.api.nvim_buf_get_name(event.buffer))
          vim.notify(msg, 'info')
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = {
          --[[  c = true, cpp = true  ]]
        }
        return {
          timeout_ms = 3000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },
}
