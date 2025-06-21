return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        json = { 'biome' },
        sh = { 'fmtsh' },
        fish = { 'fish_indent' },
        bash = { 'fmtsh' },
        html = { 'prettier' },
        python = { 'ruff_format' },
        caddyfile = { 'caddyfile' },
        c = { 'clang-format' },
        java = {},
      },
      formatters = {
        caddyfile = {
          command = 'caddy',
          args = { 'fmt', '-' },
          stdin = true,
        },
      },
      format_on_save = function(bufnr)
        local success, noformat = pcall(vim.api.nvim_buf_get_var, bufnr, 'noautoformat')
        if success and noformat then
          return nil
        end

        local disable_filetypes = {
          --[[  c = true, cpp = true  ]]
        }
        return {
          timeout_ms = 2000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },
}
