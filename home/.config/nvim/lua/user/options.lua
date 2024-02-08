local opt = vim.opt

opt.showcmd = true
opt.belloff = all

-- tabs & indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true -- turn tabs to spaces
opt.autoindent = true -- copy expected indent
opt.smartindent = true

-- line lengths
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1"
opt.wrap = false
opt.colorcolumn = "80"
opt.ruler = true

-- searching & file reads
opt.showmatch = true
opt.wildmenu = true
opt.ignorecase = true
opt.smartcase = true -- To take effect ignore case MUST be true
opt.startofline = nostartofline
opt.autoread = true
opt.hlsearch = true
opt.incsearch = true

-- vim history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- terminal behavior
opt.termguicolors = true
opt.background = "dark" -- force colorschemes to be dark if possible
opt.termguicolors = true
opt.scrolloff = 8
opt.updatetime = 50

opt.clipboard:append("unnamedplus") -- use system clipboard
