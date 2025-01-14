return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {
      check_ts = true,
      enable_check_bracket_line = true,
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      local cmp = require 'cmp'
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local ts_utils = require 'nvim-treesitter.ts_utils'

      local ts_node_func_parens_disabled = {
        -- ecma
        named_imports = true,
        -- rust
        use_declaration = true,
      }

      local default_handler = cmp_autopairs.filetypes['*']['('].handler
      cmp_autopairs.filetypes['*']['('].handler = function(char, item, bufnr, rules, commit_character)
        local node_type = ts_utils.get_node_at_cursor():type()
        if ts_node_func_parens_disabled[node_type] then
          if item.data then
            item.data.funcParensDisabled = true
          else
            char = ''
          end
        end
        default_handler(char, item, bufnr, rules, commit_character)
      end

      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done {
          sh = false,
        }
      )
    end,
  },
}
