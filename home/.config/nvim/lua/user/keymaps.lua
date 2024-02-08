-- Set the leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Normal Mode Mappings
keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- Insert Mode Mappings
keymap.set('i', 'jk', '<escape>')
keymap.set('i', '<C-v>', '<ESC>"+pa')

-- Visual Mode Mappings
keymap.set('n', '<leader>y', '"+Y')
keymap.set('v', '<C-c>', '"+Y')
keymap.set('v', '<leader>y', '"+y')

-- Save application with good old <C-S>
keymap.set('n', '<C-S>', ':update<CR>', {silent = true})
keymap.set('v', '<C-S>', '<C-C>:update<CR>', {silent = true})
keymap.set('i', '<C-S>', '<C-O> <ESC>:update<CR>', {silent = true})

-- Jump to beginning of line
keymap.set('n', 'H', '^')
keymap.set('v', 'H', '^')

-- Jump to end of line
keymap.set('n', 'L', '$')
keymap.set('v', 'L', '$')

keymap.set('n', '<leader><leader>', "<cmd>so<CR>")
keymap.set('n', '<leader>c', "<cmd>nohlsearch<CR>")

-- Buffer maangement
keymap.set('n', '<leader>h', ':bprev<CR>')
keymap.set('n', '<leader>o', '<C-^>')
keymap.set('n', '<leader>l', ':bnext<CR>')

