-- Set the leader key to space
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Normal Mode Mappings
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- Insert Mode Mappings
vim.keymap.set('i', 'jk', '<escape>')
vim.keymap.set('i', '<C-v>', '<ESC>"+pa')

-- Visual Mode Mappings
vim.keymap.set('n', '<leader>y', '"+Y')
vim.keymap.set('v', '<C-c>', '"+Y')
vim.keymap.set('v', '<leader>y', '"+y')

-- Save application with good old <C-S>
vim.keymap.set('n', '<C-S>', ':update<CR>', {silent = true})
vim.keymap.set('v', '<C-S>', '<C-C>:update<CR>', {silent = true})
vim.keymap.set('i', '<C-S>', '<C-O> <ESC>:update<CR>', {silent = true})

-- Jump to beginning of line
vim.keymap.set('n', 'H', '^')
vim.keymap.set('v', 'H', '^')

-- Jump to end of line
vim.keymap.set('n', 'L', '$')
vim.keymap.set('v', 'L', '$')

vim.keymap.set('n', '<leader><leader>', "<cmd>so<CR>")
vim.keymap.set('n', '<leader>c', "<cmd>nohlsearch<CR>")

-- Buffer maangement
vim.keymap.set('n', '<leader>h', ':bprev<CR>')
vim.keymap.set('n', '<leader>o', '<C-^>')
vim.keymap.set('n', '<leader>l', ':bnext<CR>')

