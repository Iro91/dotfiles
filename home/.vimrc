set shell=bash\ -i
" Vim Colorscheme Settings
"#############################################################################
"                        Color scheme setup for vim                          #
"#############################################################################
set t_Co=256 " Allows for vim to support colorschemes in putty
set t_BE=

syntax enable " Indents to format for corresponding filetype uses scheme color

" Format on file type detection
filetype on "
filetype plugin on "
filetype indent on " Indents to format for corresponding filetype
" colorscheme badwolf
colorscheme torte

"#############################################################################
"                                Third Party Setup                           #
"#############################################################################

"#############################################################################
"                              User Functions                                #
"#############################################################################
" Moves the cursor to the center of the line
function! LineCenter()
  call cursor(0,len(getline('.'))/2)
endfun

"#############################################################################
"                                Environemnt Setup                           #
"#############################################################################

set showcmd " Shows the command that was typed in
set belloff=all " I hate the bell with a passion
set tabstop=4 " Set tabs to to spaces.
set softtabstop=4
set shiftwidth=4
set expandtab

set showmatch "Matches the corresponding open or closing bracket
set wildmenu " Provides options for autocompletion
set incsearch " Automatically starts searching for characters
set hlsearch " Lets you see the items you've searched
set ignorecase " Vim Automatically searches case insensitive
set smartcase " Becomes case sensitive if you search an upper case letter
set splitright " Moves new vim windows to the right
"set splitbelow " Moves new horizantal windows to the bottom
set cindent " Allows cindentation
set nostartofline " Doesn't move to the beginning on big jumps
set cinoptions=
set cinoptions+=g0 " prevents private and public from being autotabbed
set ruler
" This sets formatting so that function arguements align when on next line
set cinoptions+=(0
" No namespace indenting
set cinoptions+=N-s
" This sets class inheritence to be after the ":"
"set cinoptions+=i0
" Sets the case to be aligned with the switch i
"set cinoptions+=:0
"set cinoptions+={-1s
set number relativenumber " Makes it so you can see the line numbers Turn off with :set run!
"set norelativenumber" Makes it so you can see the line numbers Turn off with :set run!
set autochdir " Automatically make the open buffer the curr directory
set autoread
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set fileformats=unix,dos
set tabpagemax=100
set noswapfile

" set undofile " Maintain undo history between sessions
" set undodir=$HOME/.vim/undodir

set title " Show the current file being edited as the title

" Sets the background to match gnome transperency
hi Normal ctermbg=none

"#############################################################################
"                                Basic nonfunctonal remaps                   #
"#############################################################################
" Vim Shortcuts
" Set local leader to space
let mapleader="\\"
map <space> \

" Escapes instead of using escape key
inoremap jk <Esc>

vnoremap u <NOP>
vnoremap U <NOP>

" Jump to beginning of line
nnoremap H ^
vnoremap H ^

" Jump to end of line
nnoremap L $
vnoremap L $

" Prevent upper case K from doing lookups
nnoremap K <nop>
vnoremap K <nop>

" Automagically format my paste.
"noremap p ]p
"noremap P ]P

vnoremap <C-c> "+y
vnoremap <C-x> "+d

"inoremap <C-v> <ESC>"+pa
inoremap <C-v> <ESC>"+pa
"nnoremap <C-a> "+]P

" Change word to upper case
inoremap <C-u> <ESC>bveUea

""" Format inside of a block of curlies
nnoremap <leader>f mzvi{='zzz
""" Format the entire document and clear out trailing white space.
nnoremap <leader>F mzggvG='zzz

""" Search for visually selected text. Useful when not a Word
vnoremap // y/<C-R>"<CR>

""" Selects an entire line if the search item is inside of it
vnoremap <leader>/ y/.*<C-R>".*\n<CR>

""" Remap auto complete to Ctrl-Space
inoremap <c-space> <c-p>

" format spacing for function calls
nnoremap <leader>( f(a <ESC>h%i <ESC>l%l

"#############################################################################
"                            Basic functional reamps                         #
"#############################################################################
" Save application with good old <C-S>
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O> <ESC>:update<CR>

" Clear searches
nnoremap <leader><space> :nohlsearch <CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

""" Movement commands. Move to in parenthsis
onoremap np :<c-u>normal! f(vi(<cr>
onoremap lp :<c-u>normal! F(vi(<cr>

""" Clear the white space from a file
nnoremap <leader>cw mz:%s/\s\+$//g<cr>'zzz

""" Opens up a new terimnal vertically
nnoremap <leader>t :vert terminal<CR>

""" C language only. Change function arguements
""" Normall upper case indicates going to last, however it is unlinkely that
""" you will be searching forward. Usually you will be in the function of
""" interest
onoremap Fa :<c-u>execute "normal! /^\\(\\(::\\)\\=\\w\\+\\(\\s\\+\\)\\=\\)\\{2,}([^!@#$+%^]*)\r:nohlsearch\rf(vi("<cr>
onoremap fa :<c-u>execute "normal! ?^\\(\\(::\\)\\=\\w\\+\\(\\s\\+\\)\\=\\)\\{2,}([^!@#$+%^]*)\r:nohlsearch\rf(vi("<cr>

" Jump to line center
nnoremap gm :call LineCenter() <CR>

""" Open file explorer in new window
nnoremap  <silent> <leader>o :call P4Open()<CR>

""" Chmod +w to a file
nnoremap <leader>u :call MarkForWrite()<CR>

"#############################################################################
"                             Autocommand Section                            #
"#############################################################################
" Saves the current file position for reopening later
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Every so often checks if the file has changed. If it has, it reloads the
" page
au CursorHold * checktime

" By default keep all files unfolded and focuses on the last line selected
autocmd BufRead * normal zRzz
autocmd BufRead .workrc set syntax=sh
autocmd BufRead *.ex set syntax=expect
" This is super cool, removes relative number on entry
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
