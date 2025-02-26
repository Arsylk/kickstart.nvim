local function roots()
  return coroutine.wrap(function()
    local cwd = vim.fn.getcwd()
    coroutine.yield(cwd)

    local wincwd = vim.fn.getcwd(0)
    if wincwd ~= cwd then
      coroutine.yield(wincwd)
    end

    ---@diagnostic disable-next-line: deprecated
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    for _, client in ipairs(get_clients()) do
      if client.config.root_dir then
        coroutine.yield(client.config.root_dir)
      end
    end
  end)
end

local is_windows = function()
  return vim.fn.has 'win32' == 1
end

local function python_exe(venv)
  if is_windows() then
    return venv .. '\\Scripts\\python.exe'
  end
  return venv .. '/bin/python'
end

local get_python_path = function()
  local uv = vim.uv or vim.loop

  local venv_path = os.getenv 'VIRTUAL_ENV'
  if venv_path then
    return python_exe(venv_path)
  end

  venv_path = os.getenv 'CONDA_PREFIX'
  if venv_path then
    if is_windows() then
      return venv_path .. '\\python.exe'
    end
    return venv_path .. '/bin/python'
  end

  for root in roots() do
    for _, folder in ipairs { 'venv', '.venv', 'env', '.env' } do
      local path = root .. '/' .. folder
      local stat = uv.fs_stat(path)
      if stat and stat.type == 'directory' then
        return python_exe(path)
      end
    end
  end

  return nil
end

local get_python_opts = function()
  return {
    include_configs = true,
  }
end

return {
  -- Mason auto install debuggers
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'delve',
        'debugpy',
        'java',
      },
    },
  },
  -- Proper dap config
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      { 'rcarriga/nvim-dap-ui', opts = {} },
      { 'igorlfs/nvim-dap-view', opts = {} },

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
    init = function()
      vim.api.nvim_create_autocmd('DirChanged', {
        desc = 'Detect pyton VirtualEnv path',
        callback = function()
          local dap = require 'dap'
          for i, conf in ipairs(dap.configurations) do
            if conf.type == 'python' then
              conf.dap.configurations[i] = conf
            end
          end

          local opts = vim.tbl_deep_extend('force', get_python_opts(), { include_configs = false })
          require('dap-python').setup(get_python_path(), opts)
        end,
      })
    end,
    opts = function()
      return {
        languages = {},
      }
    end,
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dap.adapters = dap.adapters or {}
      dap.adapters.java = {
        type = 'server',
        host = '127.0.0.1',
        port = 5005,
      }

      dap.configurations = dap.configurations or {}
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Attach to Ghidra',
          hostName = 'localhost',
          port = 5005,
        },
      }

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup for more information, see |:help nvim-dap-ui|
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }

      -- Install python specific config
      require('dap-python').setup(get_python_path(), get_python_opts())

      -- Install java specific config
      -- require('jdtls.dap').setup_dap {}
    end,
  },
}
