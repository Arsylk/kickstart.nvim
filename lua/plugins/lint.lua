return {
  {
    'mfussenegger/nvim-lint',
    init = function()
      require('lint').linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        json = { 'jsonlint' },
        lua = { 'luacheck' },
        go = { 'revive' },
      }
    end,
    config = function()
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}