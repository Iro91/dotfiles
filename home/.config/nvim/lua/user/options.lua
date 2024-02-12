-- Set the leader key to space
vim.g.mapleader = " "

-- Lets not type vim.opt everywhere
local opt = vim.opt

-- Enable relative line numbers
opt.number = true
opt.relativenumber = true

-- Set tabs to spaces
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true -- turn tabs to spaces

-- Enable auto indenting and set it to spaces
opt.smartindent = true
opt.shiftwidth = 4
opt.breakindent = true

-- Enable incremental search
opt.incsearch = true
opt.hlsearch = true

-- Enable ignore case for better searching
opt.ignorecase = true
opt.smartcase = true -- To take effect ignore case MUST be true

-- Enable mouse mode
opt.mouse = "a"
--
-- Better splitting
opt.splitbelow = true
opt.splitright = true

-- Decrease how often vim checks for updates
opt.updatetime = 50

-- Disable word wrap
opt.wrap = false

opt.showcmd = true
opt.belloff = all

-- line lengths
opt.signcolumn = "yes:1"
opt.colorcolumn = "80"
opt.ruler = true
opt.cursorline = true

-- searching & file reads
opt.showmatch = true
opt.wildmenu = true
opt.startofline = nostartofline
opt.autoread = true

-- vim history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- terminal behavior
opt.termguicolors = true
opt.scrolloff = 8

opt.clipboard = "unnamed,unnamedplus" -- use system clipboard

-- Disable netrw to support nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
