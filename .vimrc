" Make vim sane.
set nocompatible           " Why would I use vim if I wanted it to act like vi?
set noincsearch            " incsearch is annoying
set nohlsearch             " hlsearch is annoying
set foldclose=             " Automatic foldclosing is irritating too
set noshowmode             " I know what mode I'm in
set modeline

" Beeping causes an increase in the urge to kill.
set noerrorbells           " I hate bells
set visualbell             " But saying noerrorbells doesn't do it all
autocmd VimEnter * set vb t_vb= " Make the visual bell zero time, so it doesn't blink.

" Sometimes the terminal isn't setup sanely
imap <C-?> <C-h>

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
set nosmartindent
set cindent                     " Use c-style indentation
set cinkeys=!^F                 " Only indent when requested
set cinoptions=(0t0c1           " :help cinoptions-values

" Keep state about my editing, thanks.
set viminfo='50,\"1000,:100,n~/.viminfo

" Make backups, just in case?
"set backup

" Interface goodness
set ruler                  " Give me a ruler, tell me where I am in the file.
set showcmd                " Show me the vi command in the ruler
set showmatch              " Show me matching close braces
set ignorecase             " Case insensitive searching
set smartcase              " Unless I really mean case sensitive
set list                   " Show me whitespace where I care
"set number                " Sometimes I like line numbers? Meh. Rarely.

" Set title string and push it to xterm/screen window title
set titlestring=vim\ %<%F%(\ %)%m%h%w%=%l/%L-%P 
set titlelen=70
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
  set title
endif

" Some useful miscellaneous options
set listchars=tab:>-        " In case I want to use the 'list' option
set matchpairs+=<:>                 " match < > with the % command, too
set complete=.,w,b,i,t,u          " For great completion justice...
set backspace=indent,eol            " allow rational backspacing in insert mode
set formatoptions=tcrqn
set comments=b:#                    " Most of my files use # for comments

" Some plugins like to contain documentation, hurray!
if isdirectory("~/.vim/doc")
  helptags ~/.vim/doc
endif
" Allow filetype plugins (ft_plugin stuff)
filetype plugin on

" Text folding
set foldmethod=marker

" I have a dark background...
set background=dark

" Auto-detect file type
filetype on

" Mappings to jump me to the beginning of functions
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

" Miscellaneous auto commands
autocmd BufEnter * silent! lcd %:p:h
autocmd BufNewFile,BufRead */Mail/drafts/* setf mail
autocmd Filetype mail set tw=72 noa
autocmd FileType perl set comments=f:#
autocmd FileType c,cpp set comments=s1:/*,mb:*,ex:*/,f://
autocmd FileType java set comments=s1:/*,mb:*,ex:*/,f://
autocmd FileType cvs set tw=72

" gVim specific settings
set guioptions-=T     " Remove the toolbar and menubar
set guioptions-=m
set guioptions-=r     " Remove right- and left-hand scrollbars
set guioptions-=L
set guioptions+=c     " Console-based dialogs for simple queries
set guifont=suxus     " Yay fonts!

" Let us toggle the menu
let g:menubar=0
map <silent> <Del> :if g:menubar == 1<CR>:set guioptions-=m<CR>:let g:menubar = 0<CR>:else<CR>:set guioptions+=m<CR>:let g:menubar = 1<CR>:endif<CR>

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

" Let me read files in perforce.
autocmd BufReadCmd //depot/* exe "0r !p4 print -q <afile>"
autocmd BufReadCmd //depot/* 1
autocmd BufReadCmd //depot/* set readonly

" Indent helpers
"inoremap <C-f> <ESC>:call ReIndent(1)<CR>
function! ReIndent(in_insert_mode)
  let l:col = col(".")
  let l:lnum = line(".")

  " set append = 1, if we're at the end of the line.
  let l:linelen = strlen(getline(l:lnum))
  let l:append = (l:col >= l:linelen)

  let l:indent_ok = 0
  if IndentToParen(l:lnum, 1)
    let l:indent_ok = 1
  elseif IndentToParen(l:lnum, 0)
    let l:indent_ok = 1
  endif

  " Move back to our original position
  let l:linedelta = strlen(getline(l:lnum)) - l:linelen
  call setpos('.', [0, l:lnum, l:col + l:linedelta, 0])

  if l:indent_ok == 0
    "Both indent attempts failed, try using == instead
    normal ==
  endif

  if a:in_insert_mode
    if l:append == 1
      startinsert!
    else
      normal l
      startinsert
    endif
  endif
endfunction

function! IndentToParen(lnum, assume_unclosed)
  " Search for '(' on the previous line
  let l:ret = 1
  let l:lnum = a:lnum
  let l:prevlnum = prevnonblank(l:lnum - 1)
  let l:oldline = getline(l:lnum)

  if a:assume_unclosed
    " insert a ), find what it matches, indent to that open paren?
    call setline(l:lnum, ")")
  else
    call setpos('.', [0, l:prevlnum, 0, 0])
    execute "normal $F)"
  endif

  let [l:slnum, l:scol] = searchpairpos('(', '', ')', 'nbW')

  if a:assume_unclosed
    call setline(l:lnum, l:oldline)
  endif

  if l:slnum[0] != 0
    " Trim leading space/tabs
    call setpos('.', [0, l:lnum, 0, 0])
    s/^[ 	]*//
    
    " Set the line with new indentation
    if a:assume_unclosed == 0
      let l:scol = indent(l:slnum)
    endif
    call setline(l:lnum, repeat(" ", l:scol) . getline(l:lnum))

    " Turn spaces into tabs on this line, if necessary.
    .retab!
  else
    "echo "No match found on IndentToParen " . a:assume_unclosed
    let l:ret = 0
  endif
  return l:ret
endfunction

" Programming stuff
ab XXX: TODO(sissel):

let g:lastfile = ""
nmap <space>s :call SwitchHeaderAndCode()<CR>

noremap <C-k>n :tabnext<CR>
noremap <C-k><C-n> :tabnext<CR>
noremap <C-k>p :tabprev<CR>
noremap <C-k><C-p> :tabprev<CR>

function! SwitchHeaderAndCode()
  let l:basefile = expand("%:t:r")
  let l:ext = expand("%:e")
  let l:oldfile = expand("%")

  if g:lastfile
    exec "find " . g:lastfile 
  elseif l:ext == "cpp" 
    let g:lastfile = expand("%")
    exec "find " . l:basefile . ".h"
  elseif l:ext == "h"
    let g:lastfile = expand("%")
    exec "find " . l:basefile . ".cpp"
  endif
endfunction

function! GPPErrorFilter()
  silent! %s/->/ARROW/g
  silent! %s/>>/RIGHTSHIFT/g
  silent! %s/<</LEFTSHIFT/g
  while search("<", "wc")
    let l:line = getline(".")
    let l:col = col(".")
    let l:char = l:line[l:col - 1]
    if l:char == "<"
      normal d%
    else
      break
    endif
  endwhile
  silent! %s/ARROW/->/g
  silent! %s/RIGHTSHIFT/>>/g
  silent! %s/LEFTSHIFT/<</g
  silent %!awk '/: In/ { print "---------------"; print }; \!/: In/ {print }'
endfunction
filetype plugin indent on

map \s :silent !screener.sh<CR>
map \t :TlistToggle<CR>

