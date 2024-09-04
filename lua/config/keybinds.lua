local map = vim.keymap.set

-- The good 'ol keybinds
map('n', '<C-a>', 'ggVG$', { noremap = true, silent = true })
map({ 'i', 'n' }, '<C-s>', '<cmd>w<CR>', { noremap = true, desc = 'File save' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'File copy whole' })

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

-- Move between windows with arrows
map('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

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

-- Open autocomplete from normal mode
map('n', '<C-Space>', function()
  local cmp = require 'cmp'
  vim.cmd [[startinsert]]
  vim.schedule(cmp.complete)
end, { silent = true, desc = 'Open autocomplete' })

-- Keep cursor centered when PgUp & PgDown
map('n', '<PageDown>', '<C-d><C-d>zz', { desc = 'Page down' })
map('n', '<PageUp>', '<C-u><C-u>zz', { desc = 'Page up' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })
map('n', 'n', 'nzz', { noremap = true })
map('n', 'N', 'Nzz', { noremap = true })

-- Redirect command output and allow edit
map('c', '<S-CR>', function()
  require('noice').redirect(vim.fn.getcmdline())
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
map('n', '<leader>fk', '<Cmd>FzfLua keymaps<CR>', { desc = '[F]ind [K]eymaps' })
map('n', '<leader>ff', '<Cmd>FzfLua files<CR>', { desc = '[F]ind [F]iles' })
map('n', '<leader>fs', '<Cmd>FzfLua builtin<CR>', { desc = '[F]ind [S]elect FzfLua' })
map('n', '<leader>fw', '<Cmd>FzfLua grep_cword<CR>', { desc = '[F]ind current [W]ord' })
map('n', '<leader>fg', '<Cmd>FzfLua live_grep<CR>', { desc = '[F]ind by [G]rep' })
map('n', '<leader>fd', '<Cmd>FzfLua diagnostics_document<CR>', { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fr', '<Cmd>FzfLua resume<CR>', { desc = '[F]ind [R]esume' })
map('n', '<leader>f.', '<Cmd>FzfLua oldfiles<CR>', { desc = '[F]ind Recent Files [.]' })
map('n', '<leader>fn', '<Cmd>FzfLua files cwd=$HOME/.config/nvim<CR>', { desc = '[F]ind [N]eovim files' })

-- map('n', '<leader>fy', extensions.yank_history.yank_history, { desc = '[F]ind [Y]ank History' })
map('n', '<F12>', '<Cmd>OverseerRun<CR>', { desc = 'Run Overseer task' })

-- LSP buffer specific mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local fzf = require 'fzf-lua'
    map('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ctions')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    map('gf', fzf.lsp_finder, '[G]oto Lsp [F]inder')
    map('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('gr', fzf.lsp_references, '[G]oto [R]eferences')
    map('gi', fzf.lsp_implementations, '[G]oto [I]mplementation')
    map('gt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    map('gD', fzf.lsp_declarations, '[G]oto [D]eclarations')
    map('gic', fzf.lsp_incoming_calls, '[G]oto [I]ncoming [C]alls')
    map('goc', fzf.lsp_outgoing_calls, '[G]oto [O]utgoing [C]alls')

    vim.keymap.set({ 'n', 'i' }, '<A-k>', vim.lsp.buf.hover, { noremap = true })
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
    end, 'Jump to next [C]hange')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, 'Jump to previous [C]hange')

    -- normal mode
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
  end,
})

-- Autopair toggle
map('n', '<leader>ta', function()
  require('nvim-autopairs').toggle()
end, { desc = '[T]oggle auto pairs' })
