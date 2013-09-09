
" General VIM settings - not plugin related.
set nocompatible          " No compatibility with Vi.
syntax enable             " Turn on color syntax highlighting.
set incsearch             " Enable incremental search.
set rnu                   " Set relative line numbers. Can easily navigate with #j/k.
set nu                    " Show absolute line number on current line (works in vim 7.4).
set hidden                " Allow switching from unsaved buffers.
let mapleader="s"         " Set mapleader to 's'. I do not use the substitute 
                          " command all that often (c-<motion>). BUT: this does
                          " mess up nerdtree's vertical split 's' key.
set noswapfile            " No more *.swp files.
set nobackup              " No backup files (we have a large undo history).
set nowb                  " No backup when writing the file to disk.
set autoread              " Autoread file when changed externally.
set scrolloff=2           " Lines of vertical padding around cursor (lines of context).
set tabstop=2             " Number of spaces that a <Tab> counts for.
set softtabstop=2         " Num spaces that a <Tab> is converted into.
set shiftwidth=2          " # of spaces to use for each step of autoindent.
set shiftround            " Round indent to multiple of 'shiftwidth'
set expandtab             " Tell vim to insert spaces instead of tabs.
set laststatus=2          " Always put a status line in.
set encoding=utf-8        " Show unicode glyphs.
set tags=./tags;/         " Set ctags to recurse upwards.
set completeopt=longest   " Do not automatically suggest the first element
set completeopt+=menuone  " Use popup menu also when there is only one match.
set virtualedit=onemore   " Add one extra 'virtual' space at end of each line.
                          " Also could use: set virtualedit=all
set wildmenu              " Better command line completion
set wildmode=longest:full,full
set showcmd               " Show partial commands in last line of screen.
set hlsearch              " Highlight all of the search patterns.
set ignorecase            " Case of normal letters is ignored (in a search pattern)
set smartcase             " Used to ignore case if no capitals are used (in a search pattern).
set backspace=indent,eol,start " Allow backspacing over autoindent, line breaks,
                          " and start of insert action.
set autoindent            " Keep same indent as line you are currently on
                          " (while minding file-type based autoindent).
set nostartofline         " Cursor on same column and first non-blank on line.
set ruler                 " Display cursor position in the status line.
set confirm               " Confirm dialog for save instead of auto-fail.
set visualbell            " Visual bell instead of audible beep.
set t_vb=                 " Disable the visual bell (reset terminal code).
set cmdheight=2           " Set command winow height to 2 (avoiding cases of 
                          " 'press return to continue').
                          " The following  two lines were causing problems 
                          " exiting insert mode when using the terminal.
set linebreak             " Wraps at 'breakat' instead of in the middle.
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set sessionoptions-=options  " Don't save options in sessions. 
set noshowmatch           " Don't show matching brackets (%).

" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard.
" This allows you to simply yank text and it will end up on the system
" clipboard. This also works if you delete text.
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a DCS
" sequence. This turns the insert mode cursor into a nice single bar!
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Setup persistent undo/redo. Quite nice.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
set undolevels=1250

"-------------------------------------------------------------------------------
" VUNDLE
"-------------------------------------------------------------------------------
" Filetype needs to be off with vundle,
" See: https://github.com/gmarik/vundle/issues/16
" And: https://bugs.launchpad.net/ultisnips/+bug/1067416
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" New motion objects. This introduces the comma ','.
" Use it to perform an action on a word in camel case. Like ci,w
Bundle 'bkad/CamelCaseMotion.git'

" Tabularize command. Useful too often.
Bundle 'godlygeek/tabular.git'

" Easy motion (moved to Bundle from VAM). Using alternative which uses two chars.
Bundle 'iauns/vim-easymotion.git'
Bundle 'iauns/vim-subbed'
"Bundle 'svermeulen/vim-easymotion'

Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-surround.git'

" Parameter / Argument text objects.
Bundle 'vim-scripts/Parameter-Text-Objects.git'

" Think about adding the following:
" 1) YouCompleteMe  - Big maybe. I don't foresee myself doing dev in vim-slim.
"                     But, if I do, then this needs to be added.
" 2) Unite          - Don't forsee need for fuzzy file searching yet.

filetype plugin indent on


" ---------------- General VIM usability enhancements ------------------
" Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>fp :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" Remap paste mode to <leader>1
nnoremap <silent> <Leader>1 :set paste!<cr>

" U: Redos since 'u' undos
nnoremap U <c-r>

" H: Go to beginning of line. Repeated invocation goes to previous line
noremap <expr> H getpos('.')[2] == 1 ? 'k' : '^'

" L: Go to end of line. Repeated invocation goes to next line
noremap <expr> L <SID>end_of_line()
function! s:end_of_line()
  let l = len(getline('.'))
  if (l == 0 || l == getpos('.')[2]-1)
    return 'jg_'
  else
    return 'g_'
endfunction

" Y: Remap Y act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nnoremap Y y$

" +/_: Increment number. Underscore makes sense: shift is used for both
"      + and _. Also, I'm using '-' as the leader key for unite.
nnoremap + <c-a>
nnoremap _ <c-x>

" Remap semicolon to colon and colon to semicolon. I don't use repeat last
" 'f' command very often.
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" We use the <C-h,j,k,l> keys for tmux. Instead, in vim, I switch windows with
" <space>h, <space>j, etc... These overwrite the bindings supplied by Also use
" <space>s and <space>- for splitting the windows.
nnoremap <silent> <space>- :vsplit<CR>
nnoremap <silent> <space>s :split<CR>

" Exits visual mode and initiates a search within the last visual selection.
vnoremap \ <Esc>/\%V

" Remap <C-W><C-W> to move to previously active buffer.
nnoremap <C-W><C-W> :wincmd p<CR>

" Remap apostrophe to backtick
nnoremap ' `
nnoremap ` '

" Save file through sudo
cnoremap w!! %!sudo tee > /dev/null %

" Blackhole delete
nnoremap <silent><leader>d "_d

" Remap ! as mark (will replace m eventually -- when a worthy command is found)
nnoremap ! m

" Convert inner word to upper case.
nnoremap <leader>tu g~iw

" Swap two characters
nnoremap <leader>tw "zylx"zp

" ---------------- Open/close semantic ------------------
noremap <silent> <leader>h :noh<CR>
noremap <silent> <leader>cb :Kwbd<CR>

function! JH_OpenVimRC()
  exe 'e '.$HOME.'/.vimrc'
  exe 'let b:ctrlp_working_path_mode="wr"'
endfunc

noremap <silent> <leader>oq :copen<CR>
noremap <silent> <leader>oQ :cclose<CR>
noremap <silent> <leader>ol :lopen<cr>
noremap <silent> <leader>oL :lclose<cr>
noremap <silent> <leader>ov :call JH_OpenVimRC()<CR>

" ---------------- Previous / Next ------------------

" Location list.
nnoremap <leader>nL :lprevious<CR>
nnoremap <leader>NL :lprevious<CR>
nnoremap <leader>nl :lnext<CR>

" ---------------- Maximal ------------------

" Location list
nnoremap <leader>ml :llast<CR>
nnoremap <leader>mL :lfirst<CR>
nnoremap <leader>ML :lfirst<CR>

" ---------------- Spell checking ------------------
noremap <leader>ss :setlocal spell!<CR>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>sh z=

" ---------------- Tabularize ------------------
" Align on commas, leaving the commas in-place
noremap <leader>a= :Tabularize /=<CR>
noremap <leader>a, :Tabularize /,\zs/l1<CR>
noremap <leader>a: :Tabularize /:\zs<CR>

" ---------------- EasyMotion ------------------
let g:EasyMotion_leader_key      = '<space><space>'
let g:EasyMotion_keys            = 'htnsbcfgijklpzqrvmwaoeu'
let g:EasyMotion_do_shade        = 1
let g:EasyMotion_do_mapping      = 1
let g:EasyMotion_grouping        = 1
let g:EasyMotion_hl_group_target = 'Question'
let g:EasyMotion_hl_group_shade  = 'EasyMotionShade'


