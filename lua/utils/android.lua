local CLOCKWORK_PATH = '/opt/github/frida-clockwork/'
vim.g.lastpackage = nil
vim.g.lastdevice = nil
vim.g.lastscript = nil

--- @param device_id string?
--- @param cmd string?
--- @return string
local adb = function(device_id, cmd)
  cmd = cmd or ''
  if device_id then
    return ('adb -s %s %s'):format(device_id, cmd)
  end
  return ('adb %s'):format(cmd)
end

--- @param cb fun(device_id: string|nil)
--- @param opts { skip: boolean? }
local pick_device = function(cb, opts)
  local fzf = require 'fzf-lua'
  if opts.skip then
    local device_id = vim.fn.system 'adb get-serialno'
    if vim.v.shell_error == 0 then
      device_id = device_id:gsub('%s*$', '')
      vim.schedule(function()
        cb(device_id)
      end)
      return
    end
  end

  local cmd = [[adb devices | sed '$ d']]
  local contents = function(fzf_cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      vim.schedule(function()
        local processline = function(line)
          local tline = vim.trim(line)
          local item = tline:match '(%S+)'
          return tline, item
        end

        local output = vim.fn.system(cmd)
        local lines = vim.split(output, '\n', { plain = true })
        table.remove(lines)
        local header = table.remove(lines, 1)

        local items = {}
        for _, line in pairs(lines) do
          local item, device_id = processline(line)
          if device_id == vim.g.lastdevice then
            table.insert(items, 1, item)
          else
            table.insert(items, item)
          end
        end
        table.insert(items, 0, header)

        for _, item in pairs(items) do
          fzf_cb(item, function()
            coroutine.resume(co)
          end)
        end
      end)

      coroutine.yield(co)
      fzf_cb()
    end)()
  end
  fzf.fzf_exec(contents, {
    winopts = {
      height = 0.65,
      width = 0.50,
    },
    fzf_opts = {
      ['--prompt'] = 'Device> ',
      ['--header-lines'] = '1',
      ['-i'] = true,
      ['-e'] = true,
      ['--cycle'] = true,
      ['--track'] = true,
    },
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local item = selected[1]:match '(%S+)'
          if item ~= nil then
            vim.g.lastdevice = item
          end
          cb(item)
        end
      end,
    },
  })
end

--- @param device_id string|nil
--- @param cb fun(package_id)
local pick_package = function(device_id, cb)
  local fzf = require 'fzf-lua'
  local utils = require 'fzf-lua.utils'

  local cmd = adb(device_id, [[shell pm list packages -3 -f -U | sort -r -g -t ':' -k3]])
  local pkgId = function(line)
    return (tostring(line)):match '^([^|]+)|'
  end

  local contents = function(fzf_cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      vim.schedule(function()
        local processline = function(line)
          local path, pkg, uid = line:match '^package:(.-)=([%w%.%-_]+)%s+uid:(%d+)$'
          local entry = string.format('%s|%s %s\n%s', pkg, pkg, utils.ansi_from_hl('Comment', ('uid:%s'):format(uid)), utils.ansi_from_hl('Conceal', path))
          return entry, pkg
        end

        local output = vim.fn.system(cmd)
        local lines = vim.split(output, '\n', { plain = true })
        table.remove(lines)

        local items = {}
        for _, line in pairs(lines) do
          local entry, pkg = processline(line)
          if pkg == vim.g.lastpackage then
            table.insert(items, 0, entry)
          else
            table.insert(items, entry)
          end
        end

        for _, item in pairs(items) do
          fzf_cb(item, function()
            coroutine.resume(co)
          end)
        end
      end)

      coroutine.yield(co)
      fzf_cb()
    end)()
  end

  fzf.fzf_exec(contents, {
    multiline = 2,
    winopts = {
      height = 0.85,
      width = 0.5,
      col = 0.5,
    },
    fzf_opts = {
      ['--border'] = 'top',
      ['--border-label'] = device_id,
      ['--border-label-pos'] = 'top',
      ['--preview-window'] = 'bottom,,border-top',
      ['--prompt'] = 'Package> ',
      ['--delimiter'] = '\\|',
      ['--with-nth'] = '2..',
      ['-i'] = true,
      ['-e'] = true,
      ['--cycle'] = true,
      ['--track'] = true,
      ['--tiebreak'] = 'index',
    },
    preview = adb(device_id, [[ shell pm dump {1} | grep -A20 '^Packages:' ]]),
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local pkg = pkgId(selected[1])
          if pkg ~= nil then
            vim.g.lastpackage = pkg
          end
          cb(pkg)
        end
      end,
    },
  })
end

--- @param cb fun(script_file)
local pick_script = function(cb)
  local fzf = require 'fzf-lua.providers.files'
  local actions = require 'fzf-lua.actions'
  local path = require 'fzf-lua.path'

  fzf.files {
    fd_opts = [[.*.js$]],
    toggle_ignore_flag = '--no-ignore',
    winopts = {
      height = 0.65,
      width = 0.50,
    },
    fzf_opts = {
      ['--prompt'] = 'Files> ',
      ['-i'] = true,
      ['-e'] = true,
      ['--cycle'] = true,
      ['--track'] = true,
    },
    actions = {
      ['ctrl-g'] = false,
      ['ctrl-q'] = actions.toggle_ignore,
      ['default'] = function(selected, opts)
        if selected and #selected > 0 then
          local file = path.entry_to_file(selected[1], opts)
          if file ~= nil then
            vim.g.lastscript = file.path
          end
          cb(file)
        end
      end,
    },
    fzf = false,
    basic = false,
  }
end

--- @param callback fun(device_id: string|nil, package_id: string)
local function pick(callback)
  coroutine.wrap(function()
    local co = coroutine.running()
    pick_device(function(device_id)
      coroutine.resume(co, device_id)
    end, { skip = true })
    local device_id = coroutine.yield(co)

    pick_package(device_id, function(package_id)
      coroutine.resume(co, package_id)
    end)
    local package_id = coroutine.yield(co)

    if package_id ~= nil then
      callback(device_id, package_id)
    end
  end)()
end

--- @return Terminal
local function term()
  local Terminal = require('toggleterm.terminal').Terminal
  return Terminal:new {
    id = 5555,
    display_name = 'frida-clockwork',
    dir = CLOCKWORK_PATH,
    close_on_exit = false,
    auto_scroll = true,
    direction = 'horizontal',
    float_opts = {
      border = 'rounded',
    },
  }
end

--- @param device_id string|nil
--- @param package_id string
--- @param script string|nil
--- @return string
local frida_command = function(device_id, package_id, script)
  local cmd = 'frida'
  if device_id then
    cmd = cmd .. ' -D ' .. device_id
  end
  cmd = cmd .. ' -f ' .. package_id
  cmd = cmd .. ' -o session.txt'
  cmd = cmd .. ' -l ' .. (script or 'script.js')
  return cmd
end

--- @param device_id string|nil
--- @param package_id string
--- @return string
local clear_command = function(device_id, package_id)
  local cmd = 'adb'
  if device_id then
    cmd = cmd .. ' -s ' .. device_id
  end
  cmd = cmd .. ' shell pm clear '
  cmd = cmd .. package_id
  return cmd
end

vim.api.nvim_create_user_command('FridaSpawn', function()
  pick(function(device_id, package_id)
    local cmd = frida_command(device_id, package_id, vim.g.lastscript)
    local tty = term()
    tty:shutdown()
    tty:open(40, 'horizontal')
    tty:send(cmd)
  end)
end, { nargs = 0 })

vim.api.nvim_create_user_command('FridaConfig', function()
  coroutine.wrap(function()
    local co = coroutine.running()
    pick_device(function(device_id)
      coroutine.resume(co, device_id)
    end, { skip = false })
    local device_id = coroutine.yield(co)

    pick_package(device_id, function(package_id)
      coroutine.resume(co, package_id)
    end)
    local package_id = coroutine.yield(co)

    pick_script(function(script_file)
      coroutine.resume(co, script_file)
    end)
    local script_file = coroutine.yield(co)
  end)()
end, { nargs = 0 })

vim.api.nvim_create_user_command('AndroidClearData', function()
  pick(function(device_id, package_id)
    local cmd = clear_command(device_id, package_id)
    local output = vim.fn.system(cmd)
    local success = vim.v.shell_error == 0
    if success then
      vim.notify(output, vim.log.levels.INFO)
    else
      vim.notify(output, vim.log.levels.ERROR)
    end
  end)
end, { nargs = 0 })

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    local ok, overseer = pcall(require, 'overseer')
    if not ok then
      return
    end

    overseer.register_template {
      name = 'frida server',
      params = function()
        local items = { fzf_exec }
        local output = vim.fn.system [[adb devices | sed '1d;$d;s/\\t.*//']]
        if vim.v.shell_error == 0 then
          items = vim.split(output, '\n', { plain = true, trimempty = true })
        end
        return {
          device = {
            desc = 'Adb device',
            type = 'enum',
            default = vim.g.lastdevice or items[1],
            choices = items,
          },
          file = {
            desc = 'Frida Server file',
            type = 'string',
            default = 'nya-server-arm64',
          },
          cmd = {
            desc = 'Command ran in adb shell',
            type = 'string',
            default = 'su -c',
            optional = true,
          },
        }
      end,
      builder = function(params)
        local file = ('/data/local/tmp/%s'):format(params.file)
        return {
          cmd = { 'adb', '-s', params.device, 'shell', params.cmd, file },
        }
      end,
    }
  end,
})
