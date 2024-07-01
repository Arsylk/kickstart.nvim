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
<<<<<<< HEAD
          timeout_ms = 1500,
=======
          timeout_ms = 3000,
>>>>>>> 3071cb2f540f5be4e88cb86c4148e21a210bd62e
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },
}
