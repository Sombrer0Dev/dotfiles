local utils = require 'utils.functions'
local map = vim.keymap.set

-- Remap for dealing with visual line wraps
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- paste over currently selected text without yanking it
map('v', 'p', '"_dp')
map('v', 'P', '"_dP')

-- buffers
map('n', '<leader>Bd', '<cmd>%bd|e#|bd#<cr>', { desc = '[C]lose all but the current [B]uffer' })
map('n', '<leader>Bc', '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', { desc = '[D]elete current [B]uffer' })

-- Cancel search highlighting with ESC
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch and ESC' })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Floating diagnostic' })
map('n', '<leader>ql', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Quickfix
map('n', '<leader>qj', '<cmd>cnext<cr>', { desc = 'Next entry' })
map('n', '<leader>qk', '<cmd>cprevious<cr>', { desc = 'Previous entry' })
map('n', '<leader>qq', "<cmd>lua require('utils.functions').toggle_qf()<cr>", { desc = 'Toggle Quickfix' })
-- Search for 'FIXME', 'HACK', 'TODO', 'NOTE'
map('n', '<leader>qt', function()
  utils.search_todos()
end, { desc = 'List TODOs' })

-- Tab Navigation
map('n', '<leader>Tn', 'gt', { desc = '[N]ext [T]ab' })
map('n', '<leader>Tc', '<cmd>tabclose<cr>', { desc = '[C]lose [T]ab' })

-- Buffer Navigation
-- resizing splits
map('n', '<a-c-h>', require('smart-splits').resize_left)
map('n', '<a-c-j>', require('smart-splits').resize_down)
map('n', '<a-c-k>', require('smart-splits').resize_up)
map('n', '<a-c-l>', require('smart-splits').resize_right)
-- moving between splits
map('n', '<c-h>', require('smart-splits').move_cursor_left)
map('n', '<c-j>', require('smart-splits').move_cursor_down)
map('n', '<c-k>', require('smart-splits').move_cursor_up)
map('n', '<c-l>', require('smart-splits').move_cursor_right)

-- Python fixtures
map('n', 'gF', '<cmd>PytrizeJumpFixture<cr>', { desc = 'Go to Fixture defenition' })

-- DataBase connect UI
map('n', '<leader>cd', '<cmd>DBUIToggle<cr>', { desc = 'DataBase' })

-- Inlay Hint
if vim.lsp.inlay_hint then
  map('n', '<leader>ch', function()
    if vim.lsp.inlay_hint.is_enabled(0) then
      vim.lsp.inlay_hint.enable(0, false)
    else
      vim.lsp.inlay_hint.enable(0, true)
    end
  end, { desc = 'Inlay Hint' })
end

-- Terminal Management
map('t', '<esc>', '<c-\\><c-n>', { noremap = true })

-- LSP hover and fold preview
map('n', 'K', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = 'Hover doc or preview fold' })

map('n', '<leader>chh', "<cmd> lua require('rest-nvim').run()<cr>", { desc = 'Run http request' })
