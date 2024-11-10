local M = {}

M.uninstall = function(serial, package)
  vim.fn.system { 'adb', '-s', serial, 'uninstall', package }
  return vim.v.shell_error == 0
end

M.refresh_packages = function(serial)
  local NuiTree = require 'nui.tree'
  local nodes = {}

  local output = vim.fn.system { 'adb', '-s', serial, 'shell', 'pm', 'list', 'packages', '-3' }
  local lines = vim.split(output, '\n', { plain = true })
  for i = 1, #lines do
    local line = lines[i]
    local package = line:match 'package:(%S+)'
    if package then
      table.insert(
        nodes,
        NuiTree.Node {
          type = 'package',
          package = package,
        }
      )
    end
  end

  return nodes
end

M.refresh_devices = function()
  local NuiTree = require 'nui.tree'
  local nodes = {}

  local output = vim.fn.system { 'adb', 'devices', '-l' }
  local lines = vim.split(output, '\n', { plain = true })

  for i = 2, #lines - 2 do
    local line = lines[i]
    local serial, name = line:match '^(%S+).*device:(%S+)'
    if serial and name then
      table.insert(
        nodes,
        NuiTree.Node {
          type = 'device',
          serial = serial,
          name = name,
        }
      )
    end
  end

  return nodes
end

M.open_split = function()
  local split = require 'nui.split' {
    relative = 'win',
    position = 'right',
    size = 30,
    win_options = {
      wrap = false,
      number = false,
      relativenumber = false,
      foldcolumn = '0',
      signcolumn = 'no',
    },
  }
  split:mount()

  split:map('n', 'q', function()
    split:unmount()
  end, { noremap = true })

  local tree = require 'nui.tree' {
    bufnr = split.bufnr,
    winid = split.winid,
    prepare_node = function(node, parent_node)
      local line = require 'nui.line'()
      line:append(string.rep('  ', node:get_depth() - 1))

      if node.type == 'device' then
        line:append(node:is_expanded() and ' ' or ' ', 'SpecialChar')
        line:append(node.serial, 'Bold')
      end
      if node.type == 'package' then
        line:append ' '
        line:append(node.package, node.pending and 'NonText' or 'Text')
      end

      return line
    end,
  }

  split:map('n', '<S-CR>', function()
    local node = tree:get_node()
    if node == nil or node.type ~= 'device' then
      return
    end

    vim.schedule(function()
      tree:set_nodes(M.refresh_packages(node.serial), node:get_id())
      tree:render()
    end)
  end, { noremap = true, nowait = true })

  split:map('n', { '<CR>', '<Tab>' }, function()
    local node = tree:get_node()
    if node == nil or node.type ~= 'device' then
      return
    end

    if node:is_expanded() then
      if node:collapse() then
        tree:render()
      end
      return
    end

    local load = function(expand)
      if not node.loaded and node.serial then
        node.loaded = true

        vim.schedule(function()
          tree:set_nodes(M.refresh_packages(node.serial), node:get_id())
          if expand then
            node:expand()
          end
          tree:render()
        end)
      end
    end

    if node:expand() then
      load(false)
      tree:render()
    else
      load(true)
    end
  end, { noremap = true, nowait = true })

  split:map('n', 'dd', function()
    local node = tree:get_node()
    if not node or node.type ~= 'package' then
      return
    end
    local parent = tree:get_node(node:get_parent_id())
    if not parent or parent.type ~= 'device' then
      return
    end

    if not node.pending then
      node.pending = true
      vim.schedule(function()
        local success = M.uninstall(parent.serial, node.package)
        if success then
          tree:remove_node(node:get_id())
        else
          node.pending = false
        end
        tree:render()
      end)
      tree:render()
    end
  end, { noremap = true, nowait = true })

  split:on({ 'CursorMoved' }, function()
    local node = tree:get_node()
    if not node then
      return
    end
    local cursor = vim.api.nvim_win_get_cursor(split.winid)
    local row = cursor[1]

    if node.type == 'package' then
      vim.api.nvim_win_set_cursor(split.winid, { row, 6 })
    elseif node.type == 'device' then
      vim.api.nvim_win_set_cursor(split.winid, { row, 4 })
    end
  end, {})

  vim.schedule(function()
    tree:set_nodes(M.refresh_devices())
    tree:render()
  end)
end

vim.api.nvim_create_user_command('AdbApps', function()
  M.open_split()
end, { nargs = 0 })
