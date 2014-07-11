set nocompatible           " Why would I use vim if I wanted it to act like vi?
" Get pathogen going. Have to do 'set nocompatible' before calling pathogen.
call pathogen#infect()

" Make vim sane.
set noincsearch            " incsearch is annoying
set nohlsearch             " hlsearch is annoying
set foldclose=             " Automatic foldclosing is irritating too
set noshowmode             " I know what mode I'm in
set modeline
set scrolloff=8 
set backupdir=~/.vim/tmp

" Set backup directory. End with two // to tell vim to use the full path name
" of the file for the swapname. Without it, we could be editing 'foo.rb' in
" two directories, simultaneously, and they would compete for swap file.
set directory=~/.vim/tmp//

" Terminal beeps! ARGH. (╯°□°）╯︵ ┻━┻
set noerrorbells           " I hate bells
set visualbell             " But saying noerrorbells doesn't do it all
autocmd VimEnter * set vb t_vb= " Make the visual bell zero time, so it doesn't blink.

set hidden

" looks like vim's go support highlights leading and trailing whitespace.
" it's fucking annoying, so let's turn it off
let go_highlight_trailing_whitespace_error=0

" Sometimes the terminal isn't setup sanely, fix backspace.
imap <C-?> <C-h>

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
set viminfo='50,\"1000,:100,n~/.viminfo

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
set number                 " Sometimes I like line numbers

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

" Some plugins like to contain documentation, hurray!
if isdirectory("~/.vim/doc")
  helptags ~/.vim/doc
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
nnoremap <Leader>n :NumbersToggle<CR>:set number!<CR>

" Tagbar plugin
nnoremap <silent> <Leader>f :TagbarToggle<CR>

" For Unite
nnoremap <silent> <Leader>a :execute "Unite grep:" . b:git_dir . "/../"<CR>
"  grep the word under the cursor
nnoremap <silent> <Leader>A :execute "Unite grep:" . b:git_dir . "/../::" . expand("<cword>")<CR>
nnoremap <silent> <Leader>b :Unite buffer<CR>
nnoremap <silent> <Leader>w :echom system("git line-tags " . expand("%") . " " . line(".") . ' \| tr "\n" " "')<CR>

" Programming stuff
ab XXX: TODO(sissel):

" Tab and Window navigation
noremap <C-n> :tabnext<CR>
noremap <C-p> :tabprev<CR>
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

" PyBloxsom stuff
augroup pybloxsom
  autocmd BufReadPost */s/entries/*/*.txt call Pybloxsom_checkdate()
  autocmd BufNewFile */s/entries/*/*.txt call Pybloxsom_putdate()
  autocmd BufWritePost */s/entries/*/*.txt call Pybloxsom_fudgedate()
augroup end

function! Pybloxsom_checkdate() 
  " Look in the file for '#mdate foo' metadata
  normal 1G
  let dateline = search("^#mdate")

  " If not found, append the mdate of the file to line 2
  if dateline < 1
    " hack for using date+stat to generate the right date format.
    let date = system("date -d \"January 1 1970 00:00:00 $(stat -c %Z " . expand("%") . ") seconds 8 hours ago\" \"+#mdate %b %d %H:%M:%S %Y\"")
    " Add the date to the file on line 1
    1put=date
  endif
endfunction

function! Pybloxsom_putdate()
  let date=strftime("#mdate %b %e %H:%M:%S %Y")
  1put=date
  goto 1
endfunction

function! Pybloxsom_fudgedate() 
  " Mark our position
  normal mZ

  " Find mdate
  let l=search("^#mdate")
  let l=strpart(getline(l), 7)
  " for freebsd?
  "let cmd="date -j -f '%b %e %H:%M:%S %Y' '" . l . "' +%y%m%d%H%M"
  "let touchtime=system(cmd)
  "let touchcmd="touch -t '" . strpart(touchtime,0,strlen(touchtime)-1) . "' '" . expand("%") . "'"
  
  let touchcmd="touch -d '" . l . "' " . expand("%")
  call system(touchcmd)
  
  " Reload the file (make vim notice the date change)
  e

  " Jump back to our old position
  normal `Z
endfunction

" Things I don't want you to see! Neener neener neener.
if filereadable(glob("~/.vimrc-private"))
  source ~/.vimrc-private
endif

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  let output = system(command)
  if v:shell_error != 0
    execute winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number

    normal 1GdG
    call append(".", split(output, "\n"))
    "execute 'resize ' . line('$')
    resize 5
    redraw
    autocmd BufEnter <buffer> resize 15
    autocmd BufLeave <buffer> resize 5
    execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
    execute 'nnoremap <silent> <buffer> q :q<CR>'
  else
    " Success, if the previous output buffer exists, delete and close it.
    if winnr >= 0
      execute "bdelete" winnr
    end
  endif
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
command! SelfTest Shell dk test %
nnoremap <Leader>t :SelfTest<CR>

au BufRead,BufNewFile *.go setlocal filetype=go

" Use ack for Unite's grep feature when possible.
" Because ack is awesome.
if executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -H'
  let g:unite_source_grep_recursive_opt = ''
endif

if exists("$TMUX")
  let g:slime_target = "tmux"
  let g:slime_default_config = {"socket_name": "default", "target_pane": ":.1"}
endif

