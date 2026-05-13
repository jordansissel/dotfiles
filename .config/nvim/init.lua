
require("config.lazy")

vim.cmd([[
	set ts=2 sw=2
	set noincsearch            " incsearch is annoying
	set nohlsearch             " hlsearch is annoying
	set expandtab                   " When I hit tab, use spaces.
	set comments=b:#,s1:/*,mb:\ *,ex:*/,f://                   " Most of my files use # for comments
	set backspace=indent,eol            " allow rational backspacing in insert mode
	set complete=.,w,b,i,t,u          " For great completion justice...
	set formatoptions=tocrqn

	set foldclose=             " Automatic foldclosing is irritating too
	set noshowmode
	set modeline
	set scrolloff=8
	set noerrorbells           " I hate bells
	set visualbell             " But saying noerrorbells doesn't do it all
	autocmd VimEnter * set vb t_vb= " Make the visual bell zero time, so it doesn't blink.

]])
