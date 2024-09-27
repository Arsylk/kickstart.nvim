local function get_oil_extension()
  local oil_ext = vim.deepcopy(require 'lualine.extensions.oil')
  oil_ext.sections.lualine_a = {
    {
      function()
        return vim.uv.cwd()
      end,
      separator = { left = '', right = '' },
    },
  }
  -- oil_ext.sections.lualine_b = { { '<Cmd>vim.uv.cmd()<CR>' } }
  oil_ext.sections.lualine_z = {
    {
      'mode',
      separator = { left = '', right = '' },
      fmt = function(mode, context)
        local winnr = vim.fn.tabpagewinnr(context.tabnr)
        local val = require('fancyutil').get_oil_nnn(winnr)
        if val then
          return 'nnn'
        end
        return mode
      end,
      color = function()
        local val = require('fancyutil').get_oil_nnn()
        if val then
          return 'lualine_z_mode_visual'
        end
      end,
    },
  }
  return oil_ext
end

--- @return vim.Diagnostic | nil
local function get_line_diagnostic()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  local filtered = vim.tbl_filter(function(value)
    return vim.tbl_get(value, '_tags', 'unnecessary') ~= true
  end, diags)
  if #filtered > 0 then
    return filtered[1]
  end
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'folke/noice.nvim' },
      { 'arkav/lualine-lsp-progress' },
    },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin',
          component_separators = '',
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        tabline = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            -- '%=',
            {
              'filename',
              file_status = true,
              path = 3,
              symbols = {
                modified = '󰷫', -- Text to show when the file is modified.
                readonly = '󰌾', -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]', -- Text to show for newly created file before first write
              },
              separator = { left = '' },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'filetype',
              color = function()
                return 'lualine_c_normal'
              end,
            },
            {
              'fileformat',
              separator = { right = '' },
              color = function()
                return 'lualine_c_normal'
              end,
            },
          },
        },
        sections = {
          lualine_a = {
            {
              'mode',
              separator = { left = '', right = '' },
            },
          },
          lualine_c = {
            {
              'filename',
              symbols = {
                modified = '󰷫', -- Text to show when the file is modified.
                readonly = '󰌾', -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[no name]', -- Text to show for unnamed buffers.
                newfile = '[New]', -- Text to show for newly created file before first write
              },
            },
          },
          lualine_x = {
            {
              function()
                local line = get_line_diagnostic()
                return line and ('%s: %s'):format(line.source, line.message) or ''
              end,
              color = function()
                local line = get_line_diagnostic()
                if line then
                  local severity = line.severity
                  local hl = 'lualine_b_diagnostics_info_inactive'
                  if severity == vim.log.levels.DEBUG then
                    hl = 'lualine_b_diagnostics_hint_inactive'
                  elseif severity == vim.log.levels.WARN then
                    hl = 'lualine_b_diagnostics_warn_inactive'
                  elseif severity == vim.log.levels.ERROR then
                    hl = 'lualine_b_diagnostics_error_inactive'
                  end
                  return hl
                end
              end,
            },
            -- {
            --   'lsp_progress',
            --   display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' } },
            --   colors = {
            --     percentage = colors.gray,
            --     title = colors.gray,
            --     message = colors.gray,
            --     spinner = colors.gray,
            --     lsp_client_name = colors.purple,
            --     use = true,
            --   },
            --   spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
            --   timer = {
            --     progress_enddelay = 1500,
            --     spinner = 1500,
            --     lsp_client_enddelay = 2500,
            --   },
            -- },
          },
          lualine_z = {
            {
              'location',
              separator = { left = '', right = '' },
            },
          },
        },
        extensions = {
          get_oil_extension(),
          'lazy',
        },
      }
    end,
  },
}
