-- Use the old vim stype of vim mapping for easier reads
local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
--local tnoremap = require("user.keymap_utils").tnoremap
--local xnoremap = require("user.keymap_utils").xnoremap

-- Disable the space key as it's reserved by the leader key
inoremap("<space>", "<nop>")
nnoremap("<space>", "<nop>")
vnoremap("<space>", "<nop>")

-- Escape insert mode using jk
inoremap('jk', '<escape>')

-- Paste using C-v
inoremap('<C-v>', '<ESC>"+pa')
nnoremap('<C-v>', '"+pa')

-- Visual Mode Mappings
-- Maybe we don't even need this
nnoremap('<leader>y', '"+Y')
vnoremap('<C-c>', '"+Y')
vnoremap('<leader>y', '"+y')

-- Save application with good old <C-S>
nnoremap('<C-S>', ':update<CR>', {silent = true})
vnoremap('<C-S>', '<ESC>:update<CR>', {silent = true})
inoremap('<C-S>', '<ESC>:update<CR>', {silent = true})

-- Jump to beginning of line
nnoremap('H', '^')
vnoremap('H', '^')

-- Jump to end of line
nnoremap('L', '$')
vnoremap('L', '$')

-- Press 'U' for redo
nnoremap("U", "<C-r>")

nnoremap('<leader>c', "<cmd>nohlsearch<CR>")

-- Buffer maangement
nnoremap('<leader>bh', ':bprev<CR>')
nnoremap('<leader>bo', '<C-^>')
nnoremap('<leader>bl', ':bnext<CR>')

