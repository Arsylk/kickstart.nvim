return {
  {
    enabled = not vim.g.neovide,
    'tribela/transparent.nvim',
    event = 'VimEnter',
    opts = {
      auto = true,
      extra_groups = {
        'NormalNC',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        callback = function()
          local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID 'SpecialKey'), 'fg#')
          vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE', fg = color })
        end,
      })
    end,
  },
}
