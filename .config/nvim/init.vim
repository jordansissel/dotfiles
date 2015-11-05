" Get pathogen going. Have to do 'set nocompatible' before calling pathogen.
call pathogen#infect()

" Make vim sane.
set noincsearch            " incsearch is annoying
set nohlsearch             " hlsearch is annoying
set foldclose=             " Automatic foldclosing is irritating too
set noshowmode             " I know what mode I'm in
set modeline
set scrolloff=8 
set backupdir=~/.nvim/tmp

" Set backup directory. End with two // to tell vim to use the full path name
" of the file for the swapname. Without it, we could be editing 'foo.rb' in
" two directories, simultaneously, and they would compete for swap file.
set directory=~/.nvim/tmp//

" Terminal beeps! ARGH. (╯°□°）╯︵ ┻━┻
set noerrorbells           " I hate bells
set visualbell             " But saying noerrorbells doesn't do it all
autocmd VimEnter * set vb t_vb= " Make the visual bell zero time, so it doesn't blink.

" Make <Leader> be the spacebar.
let mapleader = "\ "

" neovim
tnoremap <NUL> <C-\><C-n>
nnoremap <Leader>c :terminal zsh -li<CR>

" vim-airline
function ThisOrThat(var, default)
  if exists(a:var) 
    return eval(a:var)
  else
    return a:default
  endif
endfunction

function BufferTitle()
  " If we're in a terminal buffer, set the buffer title to be the terminal
  " title.
  return ThisOrThat('b:term_title', expand(airline#section#create(['file'])))
endfunction

let g:airline_section_c = airline#section#create(['%{BufferTitle()}', ' ', 'readonly'])

" nerdtree
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=30

set hidden

" looks like vim's go support highlights whitespace.
" it's fucking annoying, so let's turn it off
let go_highlight_trailing_whitespace_error=0

" Sometimes I don't have a keyboard with escape.
imap jj <Esc>

" Syntax and Color
if has("syntax")
  syn on
end
set t_Co=256
color desert256-jls

" Indentation. Do it my way.
set shiftwidth=2                " 2 spaces for shifting
set tabstop=2                   " Tabs are 2 spaces wide.
set expandtab                   " When I hit tab, use spaces.
set autoindent
set nosmartindent               " smart indent isn't very smart.
set cindent                     " Use c-style indentation
set cinkeys=!^F                 " Only indent when requested
set cinoptions=(0t0c1           " :help cinoptions-values

" Text folding
set foldmethod=marker

" I have a dark background...
set background=dark

" Keep state about my editing, thanks.
set viminfo='50,\"1000,:100,n~/.nviminfo

" Make backups, just in case?
"set backup

" Interface goodness
set noruler
set laststatus=2           " Enable status bar
set showcmd                " Show me the vi command in the ruler
set showmatch              " Show me matching close braces
set ignorecase             " Case insensitive searching
set smartcase              " Unless I really mean case sensitive
set list                   " Show me whitespace where I care
"set number                 " Sometimes I like line numbers

" Some useful miscellaneous options
set listchars=tab:⬪⬞
set matchpairs+=<:>                 " match < > with the % command, too
set complete=.,w,b,i,t,u          " For great completion justice...
set backspace=indent,eol            " allow rational backspacing in insert mode
set formatoptions=tocrqn
set comments=b:#,s1:/*,mb:\ *,ex:*/,f://                   " Most of my files use # for comments

" html style closetag (not xml)
let g:closetag_html_style=1 

" Set title string and push it to xterm/screen window title
set titlestring=vim\ %<%F%(\ %)%m%h%w%=%l/%L-%P 
set titlelen=70
if &term == "screen-256color"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen-256color" || &term == "screen" || &term == "xterm"
  set title
endif

" Allow filetype plugins (ft_plugin stuff)
filetype on
filetype plugin on
filetype plugin indent on

" Mappings to jump me to the beginning of functions
nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

" Buffer movement
nnoremap H :prev<CR>
nnoremap L :next<CR>


" Miscellaneous auto commands
autocmd Filetype mail setlocal tw=72 noa
autocmd FileType perl setlocal comments=f:#
autocmd FileType c,cpp setlocal comments=s1:/*,mb:*,ex:*/,f://
autocmd FileType java setlocal comments=s1:/*,mb:*,ex:*/,f://
autocmd FileType cvs setlocal tw=72

" For navigating fugitive's :Glog views.
autocmd FileType git nnoremap J :cnext<CR>
autocmd FileType git nnoremap K :cprev<CR>

" Fix go commenting
autocmd FileType go setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:// 

" Toggle relative/actual line numbers.
nnoremap <Leader>N :NumbersToggle<CR>:set number!<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>o :NERDTree<CR>
nnoremap <Leader>' :Unite buffer<CR>
tnoremap <C-Space> <C-\><C-n>

" Programming stuff
ab XXX: TODO(sissel):

" Tab and Window navigation
noremap <C-n> :bnext<CR>
noremap <C-p> :bprev<CR>
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" gVim specific settings, not that I really use this.
set guioptions-=T     " Remove the toolbar and menubar
set guioptions-=m
set guioptions-=r     " Remove right- and left-hand scrollbars
set guioptions-=L
set guioptions+=c     " Console-based dialogs for simple queries
set guifont=suxus     " Yay fonts!

" Let us toggle the menu
let g:menubar=0
map <silent> <Del> :if g:menubar == 1<CR>:set guioptions-=m<CR>:let g:menubar = 0<CR>:else<CR>:set guioptions+=m<CR>:let g:menubar = 1<CR>:endif<CR>

" Turn blinking off
set guicursor=a:block-blinkoff1

au BufRead,BufNewFile *.go setlocal filetype=go