return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
    },
    keys = {
      { '<leader>c', desc = '[C]ode' },
      { '<leader>d', desc = '[D]ocument' },
      { '<leader>r', desc = '[R]ename' },
      { '<leader>f', desc = '[F]ind' },
      { '<leader>t', desc = '[T]oggle' },
      { '<leader>w', desc = '[W]orkspace' },
    },
    config = function(_, opts)
      require('which-key').setup(opts)

      -- [T]oggle group
      vim.keymap.set('n', '<leader>tn', function()
        vim.opt.number = not vim.opt.number._value
      end, { desc = '[T]oggle [N]umbers' })

      vim.keymap.set('n', '<leader>tw', function()
        vim.opt.wrap = not vim.opt.wrap._value
      end, { desc = '[T]oggle [W]rap Lines' })
    end,
  },
}
