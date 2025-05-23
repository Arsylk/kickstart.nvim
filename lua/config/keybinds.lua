---@param mode string|string[]
---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
local map = function(mode, lhs, rhs, opts)
  ---@cast lhs string[]
  lhs = type(lhs) == 'string' and { lhs } or lhs
  for i, key in pairs(lhs) do
    if i > 1 and opts ~= nil and opts.desc then
      opts.desc = 'which-key.ignore'
    end
    vim.keymap.set(mode, key, rhs, opts)
  end
end
--- @param index number
--- @param desc string
local first_desc = function(index, desc)
  return index == 1 and desc or 'which-key.ignore'
end
--- @param value number
--- @param min number
--- @param max number
local clamp = function(value, min, max)
  return math.min(max, math.max(min, value))
end

-- The good 'ol keybinds
map('n', { '<C-c>', '<D-c>' }, '<cmd>%y+<CR>', { desc = 'File copy whole' })
map('n', { '<C-a>', '<D-a>' }, 'gg^vG$', { desc = 'Select all', noremap = true, silent = true })
map({ 'i', 'n' }, { '<C-s>', '<D-s>' }, '<cmd>w<CR>', { noremap = true, desc = 'File save' })
map('n', { '<C-z>', '<D-z>' }, 'u', { desc = 'which-key.ignore' }) -- Undo
map('i', { '<C-z>', '<D-z>' }, '<C-o>u', { desc = 'which-key.ignore' }) -- Undo
map('n', { '<C-Z>', '<D-Z>' }, '<C-r>', { desc = 'which-key.ignore' }) -- Undo
map('i', { '<C-Z>', '<D-Z>' }, '<C-o><C-r>', { desc = 'which-key.ignore' }) -- Undo

-- Activate Ctrl+V as paste
map('c', '<C-v>', function()
  local pos = vim.fn.getcmdpos()
  local text = vim.fn.getcmdline()
  local lt = text:sub(1, pos - 1)
  local rt = text:sub(pos)
  local clip = vim.fn.getreg '+'
  vim.fn.setcmdline(lt .. clip .. rt, pos + clip:len())
  vim.cmd [[echo '' | redraw]]
end, { noremap = true, desc = 'Command paste' })
map('n', '<C-v>', '"+p', { desc = 'Command paste' })
map('i', '<C-v>', '<cmd>normal "+p<CR>', { noremap = true, desc = 'Command paste' })

-- Force close all windowns
map('n', '<S-Esc><S-Esc><Del>', '<Cmd>qa!<CR>', { nowait = true, noremap = true, desc = 'Instant Quit' })

-- Display diagnostics under cursor
map('n', { '<C-d>', '<D-d>' }, vim.diagnostic.open_float, { desc = 'Show diagnostics under the cursor' })

-- Edit path under cursor
map('n', 'ge', function()
  local path = vim.fn.expand '<cfile>'
  if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) then
    local cmd = ('edit %s'):format(path)
    vim.cmd(cmd)
  else
    vim.notify(('Missing file:\n%s'):format(path), vim.log.levels.WARN)
  end
end, { desc = 'Edit file under cursor' })

-- Kill current buffer
map('n', '<C-w>Q', function()
  vim.api.nvim_buf_delete(0, { force = true })
end, { desc = 'Kill current buffer' })

-- Open ripgrep replace Ctrl+R
map('n', '<C-rp>', function()
  require('rip-substitute').sub()
end, { desc = ' rip substitute' })

-- Move between windows with arrows
-- map('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- map('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- map('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- map('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<C-w>n', '<Cmd>new<CR>', { desc = 'Open new window split' })
map('n', '<C-w>N', '<Cmd>vnew<CR>', { desc = 'Open new window split vertical' })

-- Don't yank on delete char
map('n', 'x', '"_x', {})
map('n', 'X', '"_X', {})
map('v', 'x', '"_x', {})
map('v', 'X', '"_X', {})

-- Don't yank on visual paste
map('v', 'p', '"_dP', {})

-- Double Q to close current window
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help' },
  callback = function(params)
    vim.keymap.set('n', 'qq', '<cmd>q<CR>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vim' },
  callback = function(params)
    vim.keymap.set('n', 'qq', '<C-c>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'TelescopePrompt', 'fzf' },
  callback = function(params)
    vim.keymap.set('', 'qq', '<Esc>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

-- Toggle term specific mappings
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'toggleterm' },
  callback = function(params)
    map('n', { '<leader><C-c>', '<leader><D-c>' }, function()
      local terminal = require 'toggleterm.terminal'
      local id = terminal.get_focused_id()
      if id then
        local term = terminal.get(id, true)
        if term then
          term:shutdown()
        end
      end
    end, { desc = 'Shutdown terminal', buffer = params.buf })
  end,
})

-- Break inserted text into smaller undo units
local undo_ch = { ',', '.', '!', '?', ';', ':' }
for _, ch in ipairs(undo_ch) do
  map('i', ch, ch .. '<C-g>u')
end

map('x', '$', 'g_')

-- Open autocomplete from normal mode
map('n', { '<C-Space>', '<D-Space>' }, function()
  local ok, cmp = pcall(require, 'blink-cmp')
  if not ok then
    return
  end
  vim.cmd [[startinsert]]
  cmp.show()
end, { silent = true, desc = 'Open autocomplete' })

-- Keep cursor centered when PgUp & PgDown
map('n', '<PageDown>', '<C-d><C-d>zz', { desc = 'Page down' })
map('n', '<PageUp>', '<C-u><C-u>zz', { desc = 'Page up' })
map('n', '<C-PageDown>', '<C-d>zz', { desc = 'Half page down' })
map('n', '<C-PageUp>', '<C-u>zz', { desc = 'Half page up' })
map('n', 'n', 'nzz', { desc = 'Next', noremap = true })
map('n', 'N', 'Nzz', { desc = 'Previous', noremap = true })

-- Additional buffer navigation
map('', '[b', '<Cmd>bprevious<CR>', { desc = 'previous [b]uffer', silent = true })
map('', ']b', '<Cmd>bnext<CR>', { desc = 'next [b]uffer', silent = true })

-- Overseer toggle window
map('n', '<F12>', '<Cmd>OverseerToggle<CR>', { noremap = true, desc = 'Toggle Overseer window' })
map('n', { '<C-F12>', '<F36>' }, '<Cmd>OverseerRun<CR>', { noremap = true, desc = 'Overseer Run' })
map('n', '<S-F12>', '<Cmd>OverseerRunCmd<CR>', { noremap = true, desc = 'Overseer Run Cmd' })

-- Redirect command output and allow edit
map('c', '<S-CR>', function()
  local route = require('noice.config').options.redirect
  require('noice').redirect(vim.fn.getcmdline(), { route })
end, { desc = 'Redirect Cmdline' })

-- remap keys for "fold all" and "unfold all"
vim.keymap.set('n', 'zR', function()
  require('ufo').openAllFolds()
end, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', function()
  require('ufo').closeAllFolds()
end, { desc = 'Close all folds' })

-- LSP mappings
map('n', '<leader><leader>', '<Cmd>FzfLua buffers<CR>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>fh', '<Cmd>FzfLua help<CR>', { desc = '[F]ind [H]elp' })
map('n', '<leader>fh', '<Cmd>FzfLua highlights<CR>', { desc = '[F]ind [H]ighlights' })
map('n', '<leader>fk', '<Cmd>FzfLua keymaps<CR>', { desc = '[F]ind [K]eymaps' })
map('n', '<leader>ff', '<Cmd>FzfLua files<CR>', { desc = '[F]ind [F]iles' })
map('n', '<leader>fs', '<Cmd>FzfLua builtin<CR>', { desc = '[F]ind [S]elect FzfLua' })
map('n', '<leader>fw', '<Cmd>FzfLua grep_cword<CR>', { desc = '[F]ind current [W]ord' })
map('n', '<leader>fg', '<Cmd>FzfLua live_grep<CR>', { desc = '[F]ind by [G]rep' })
map('n', '<leader>fd', '<Cmd>FzfLua diagnostics_document<CR>', { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fr', '<Cmd>FzfLua resume<CR>', { desc = '[F]ind [R]esume' })
map('n', '<leader>f.', '<Cmd>FzfLua oldfiles<CR>', { desc = '[F]ind Recent Files [.]' })
map('n', '<leader>fn', '<Cmd>FzfLua files cwd=$HOME/.config/nvim<CR>', { desc = '[F]ind [N]eovim files' })
map('n', '<leader>fy', function()
  require 'neoclip.fzf'()
end, { desc = '[F]ind [Y]ank History' })

-- LSP buffer specific mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
  callback = function(event)
    local lspmap = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local fzf = require 'fzf-lua'
    lspmap('<leader>cl', vim.lsp.codelens.run, '[C]ode [L]ens')
    lspmap('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ctions')
    lspmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    lspmap('gf', fzf.lsp_finder, '[G]oto Lsp [F]inder')
    lspmap('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    lspmap('gr', fzf.lsp_references, '[G]oto [R]eferences')
    lspmap('gi', fzf.lsp_implementations, '[G]oto [I]mplementation')
    lspmap('gt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    lspmap('gD', fzf.lsp_declarations, '[G]oto [D]eclarations')
    lspmap('gic', fzf.lsp_incoming_calls, '[G]oto [I]ncoming [C]alls')
    lspmap('goc', fzf.lsp_outgoing_calls, '[G]oto [O]utgoing [C]alls')

    map({ 'n', 'i' }, '<A-k>', vim.lsp.buf.hover, { noremap = true })
  end,
})

-- mappings for Gitsigns, a bit ghetto but zzz
vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufRead', 'BufNewFile', 'BufWritePost' }, {
  callback = function(event)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = event.bufnr, desc = 'git: ' .. desc })
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, 'next [c]hange')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, 'previous [c]hange')

    -- normal mo
    map('n', '<leader>hs', gitsigns.stage_hunk, '[s]tage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, '[r]eset hunk')
    map('n', '<leader>hS', gitsigns.stage_buffer, '[S]tage buffer')
    map('n', '<leader>hu', gitsigns.undo_stage_hunk, '[u]ndo stage hunk')
    map('n', '<leader>hR', gitsigns.reset_buffer, '[R]eset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, '[p]review hunk')
    map('n', '<leader>hb', gitsigns.blame_line, '[b]lame line')
    map('n', '<leader>hd', gitsigns.diffthis, '[d]iff against index')
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, '[D]iff against last commit')
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle show [b]lame line')
    map('n', '<leader>tD', gitsigns.toggle_deleted, '[T]oggle show [D]eleted')

    Snacks.toggle
      .new({
        name = 'Git blame line',
        get = function()
          return require('gitsigns.config').lame_line
        end,
        set = function(state)
          require('gitsigns.config').lame_line = state
        end,
      })
      :map '<leader>tb'
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    -- Autopair toggle
    local ok, blink = pcall(require, 'blink.cmp.config')
    if ok then
      Snacks.toggle
        .new({
          name = 'Autocomplete',
          get = function()
            return vim.b.completaion
          end,
          set = function(state)
            vim.b.completion = not state
          end,
        })
        :map '<leader>tb'
      Snacks.toggle
        .new({
          name = 'Autopair',
          get = function()
            return blink.completion.accept.auto_brackets.enabled
          end,
          set = function(state)
            blink.completion.accept.auto_brackets.enabled = not state
          end,
        })
        :map '<leader>tb'
    end
    -- UndoTree toggle
    Snacks.toggle
      .new({
        name = 'Autosave',
        get = function()
          return vim.g.autosave
        end,
        set = function(state)
          if state then
            require('auto-save').on()
          else
            require('auto-save').off()
          end
        end,
      })
      :map '<leader>ta'
    -- Autosave toggle
    Snacks.toggle
      .new({
        name = 'Autoformat',
        get = function()
          return vim.g.autoformat
        end,
        set = function(state)
          if state then
            require('auto-save').on()
          else
            require('auto-save').off()
          end
        end,
      })
      :map '<leader>tf'
  end,
})

-- toogle debugger gui
vim.keymap.set('n', '<F7>', function()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })

if vim.g.neovide then
  map('n', '<D-s>', ':w<CR>', { desc = 'which-key.ignore' }) -- Save
  map('n', '<D-z>', 'u', { desc = 'which-key.ignore' }) -- Undo
  map('i', '<D-z>', '<C-o>u', { desc = 'which-key.ignore' }) -- Undo
  map('n', '<D-Z>', '<C-r>', { desc = 'which-key.ignore' }) -- Undo
  map('i', '<D-Z>', '<C-o><C-r>', { desc = 'which-key.ignore' }) -- Undo
  map('v', '<D-c>', '"+y', { desc = 'which-key.ignore' }) -- Copy
  map('n', '<D-v>', '"+P', { desc = 'which-key.ignore' }) -- Paste normal mode
  map('t', '<D-v>', '<ESC>"+Pi', { desc = 'which-key.ignore' }) -- Paste terminal mode
  map('l', '<D-v>', '<ESC>"+Pi', { desc = 'which-key.ignore' }) -- Paste terminal mode
  map('v', '<D-v>', '"+P', { desc = 'which-key.ignore' }) -- Paste visual mode
  map('c', '<D-v>', '<C-R>+', { desc = 'which-key.ignore' }) -- Paste command mode
  map('i', '<D-v>', '<ESC>l"+Pli', { desc = 'which-key.ignore' }) -- Paste insert mode

  vim.g.neovide_window_blurred = true
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  local alpha = function()
    return string.format('%x', math.floor(255 * (vim.g.neovide_transparency_point or 0.8)))
  end
  -- Set transparency and background color (title bar color)
  vim.g.neovide_transparency = 0.0
  vim.g.neovide_transparency_point = 0.8
  vim.g.neovide_background_color = '#0f1117' .. alpha()
  -- Add keybinds to change transparency
  local change_transparency = function(delta)
    vim.g.neovide_transparency = clamp(vim.g.neovide_transparency + delta, 0.0, 1.0)
    vim.g.neovide_transparency_point = clamp(vim.g.neovide_transparency_point + delta, 0.0, 1.0)
    vim.g.neovide_background_color = '#0f1117' .. alpha()
  end
  for _, key in pairs { 'C', 'D' } do
    map('n', string.format('<%s-]>', key), function()
      change_transparency(0.05)
    end, { desc = first_desc 'Increase transparency' })
    map('n', string.format('<%s-[>', key), function()
      change_transparency(-0.05)
    end, { desc = first_desc 'Decrease transparency' })
    map('n', string.format('<%s-+>', key), function()
      change_scale_factor(1.1)
    end, { desc = first_desc 'Increase font size' })
    map('n', string.format('<%s-_>', key), function()
      change_scale_factor(1 / 1.1)
    end, { desc = first_desc 'Decrease font size' })
    map('n', string.format('<%s-)>', key), function()
      vim.g.neovide_scale_factor = 1.0
    end, { desc = first_desc 'Reset font size' })
  end
end
