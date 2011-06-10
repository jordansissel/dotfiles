" Vim color file
" Original Maintainer: Anders Korte <anderskorte@eml.cc>

"    Modified: by entheon <jazzworksweb@yahoo.com>
" Last Change: 13 Sept 2005

" Gardener v1.1
" A modification of the Guardian colorscheme v1.2

"   'For code surgeons and web gardeners everywhere'

" A nice earthy  color scheme which is easy on  the eyes. It
" has  as it's  base a  dark background  monocrhomatic khaki
" scheme with dabs of color thrown  in here and there on the
" keywords. Plus  lots of  extra config  options so  you can
" tweak  it to  your liking  and or  make it  more like  the
" original Guardian scheme. All the defaults are what I like
" but if you want to change stuff just set the right var and
" it will change pretty much  immediately, you might have to
" move out of and back into your buffer for it to refresh.


" Features:
"   256 Color XTerm Compatibility
"   Richer Syntax
"   Black Background
"   Functions
"   No Italics
"   Purple Booleans
"   Swapped Status Line Colors
"   Other minor tweaks

" Change Log:
"   changed the  ghastly puke  salmon red  to green  like it
"   should have been in the  first place esp considering the
"   name  Gardener, now  all  vimsters can  truly frolic  in
"   their Vim Gardens

" Options:
"   g:gardener_light_comments
"       if  this var  exists then  comments are  white on  a
"       gray-blue  background  if it  is  not  set then  the
"       comments default  to medium grey with  no background
"       color, I can't stand bg colors but some people might
"       like it, so I left it as an option.
"
"   g:gardener_soil
"       This  is a  GUI  only option  because  there are  no
"       colors that work  even in the 256  color XTerm. This
"       option gives you a  brownish background instead of a
"       black background. I think the black background gives
"       better contrast and thus is  easier to read from. if
"       you disagree then you've got this option
"
"   g:gardener_setnum
"       turns the background of the line numbers black

" Using The Options:
"       To enable a feature add the line
"           let g:gardenter_some_feature=1
"       to your ~/.vimrc 
"       To disable the feature temporarily run the command
"           :unlet g:gardener_some_feature
"       To  disable the  feature permanently,  simply remove
"       the line from your .vimrc file.

set background=dark
hi clear
syntax reset

" Colors for the User Interface.
if exists("g:gardener_setnum")
    exec "hi linenr     cterm=BOLD   ctermfg=235   ctermbg=244"
else
    exec "hi linenr     cterm=BOLD   ctermfg=244   ctermbg=235"
endif


exec "hi Cursor         cterm=BOLD   ctermfg=255   ctermbg=167"
exec "hi CursorIM       cterm=BOLD   ctermfg=255   ctermbg=167"

exec "hi Normal         cterm=NONE   ctermfg=255   ctermbg=233"
exec "hi NonText        cterm=NONE   ctermfg=230   ctermbg=60"
exec "hi Visual         cterm=NONE   ctermfg=255   ctermbg=68"

exec "hi Linear         cterm=NONE   ctermfg=248   ctermbg=NONE"

exec "hi Directory      cterm=NONE   ctermfg=64    ctermbg=NONE"

exec "hi IncSearch      cterm=NONE   ctermfg=255   ctermbg=25"

exec "hi ErrorMsg       cterm=BOLD   ctermfg=196   ctermbg=NONE"
exec "hi WarningMsg     cterm=BOLD   ctermfg=196   ctermbg=NONE"
exec "hi ModeMsg        cterm=NONE   ctermfg=230   ctermbg=NONE"
exec "hi MoreMsg        cterm=NONE   ctermfg=230   ctermbg=NONE"
exec "hi Question       cterm=NONE   ctermfg=194   ctermbg=NONE"

exec "hi StatusLineNC   cterm=NONE   ctermfg=16    ctermbg=229"
exec "hi StatusLine     cterm=BOLD   ctermfg=255   ctermbg=167"
exec "hi VertSplit      cterm=NONE   ctermfg=16    ctermbg=229"

exec "hi DiffAdd        cterm=NONE   ctermfg=255   ctermbg=60"
exec "hi DiffAdd        cterm=NONE   ctermfg=255   ctermbg=65"
exec "hi DiffAdd        cterm=NONE   ctermfg=255   ctermbg=95"
exec "hi DiffAdd        cterm=BOLD   ctermfg=255   ctermbg=95"

" Colors for Syntax Highlighting.
if exists("g:gardener_light_comments")
    exec "hi Comment        cterm=NONE   ctermfg=253   ctermbg=60"
else
    exec "hi Comment        cterm=NONE   ctermfg=244   ctermbg=NONE"
endif

exec "hi Constant       cterm=BOLD   ctermfg=255  ctermbg=NONE"
exec "hi String         cterm=NONE   ctermfg=230  ctermbg=NONE"
exec "hi Character      cterm=BOLD   ctermfg=230  ctermbg=NONE"
exec "hi Number         cterm=BOLD   ctermfg=153  ctermbg=NONE"
exec "hi Boolean        cterm=NONE   ctermfg=207  ctermbg=NONE"
exec "hi Float          cterm=BOLD   ctermfg=153  ctermbg=NONE"

exec "hi Identifier     cterm=NONE   ctermfg=223  ctermbg=NONE"
exec "hi Function       cterm=BOLD   ctermfg=229  ctermbg=NONE"
exec "hi Statement      cterm=BOLD   ctermfg=230  ctermbg=NONE"

exec "hi Define         cterm=BOLD   ctermfg=68  ctermbg=NONE"
exec "hi Conditional    cterm=BOLD   ctermfg=149  ctermbg=NONE"

exec "hi Repeat         cterm=BOLD   ctermfg=208  ctermbg=NONE"
exec "hi Label          cterm=BOLD   ctermfg=225  ctermbg=NONE"
exec "hi Operator       cterm=BOLD   ctermfg=173  ctermbg=NONE"
exec "hi Keyword        cterm=BOLD   ctermfg=86   ctermbg=NONE"
exec "hi Exception      cterm=BOLD   ctermfg=86   ctermbg=NONE"

exec "hi PreProc        cterm=BOLD   ctermfg=222   ctermbg=NONE"
exec "hi Include        cterm=BOLD   ctermfg=114   ctermbg=NONE"
exec "hi Macro          cterm=BOLD   ctermfg=114   ctermbg=NONE"
exec "hi PreCondit      cterm=BOLD   ctermfg=114   ctermbg=NONE"

exec "hi Type           cterm=BOLD   ctermfg=193   ctermbg=NONE"
exec "hi StorageClass   cterm=BOLD   ctermfg=78    ctermbg=NONE"
exec "hi Structure      cterm=BOLD   ctermfg=114   ctermbg=NONE"
exec "hi Typedef        cterm=BOLD   ctermfg=114   ctermbg=NONE"

exec "hi Special        cterm=BOLD   ctermfg=153   ctermbg=NONE"
exec "hi SpecialChar    cterm=BOLD   ctermfg=153   ctermbg=NONE"
exec "hi Tag            cterm=BOLD   ctermfg=153   ctermbg=NONE"
exec "hi Delimiter      cterm=BOLD   ctermfg=255   ctermbg=NONE"
exec "hi SpecialComment cterm=BOLD   ctermfg=253   ctermbg=24"
exec "hi Debug          cterm=NONE   ctermfg=210   ctermbg=NONE"

exec "hi Title          cterm=BOLD   ctermfg=255   ctermbg=60"
exec "hi Ignore         cterm=NONE   ctermfg=251   ctermbg=NONE"
exec "hi Error          cterm=NONE   ctermfg=255   ctermbg=196"
exec "hi Ignore         cterm=NONE   ctermfg=196   ctermbg=60"

exec "hi htmlH1         cterm=BOLD   ctermfg=255   ctermbg=NONE"
exec "hi htmlH2         cterm=BOLD   ctermfg=253   ctermbg=NONE"
exec "hi htmlH3         cterm=BOLD   ctermfg=251   ctermbg=NONE"
exec "hi htmlH4         cterm=BOLD   ctermfg=249   ctermbg=NONE"
exec "hi htmlH5         cterm=BOLD   ctermfg=247   ctermbg=NONE"
exec "hi htmlH6         cterm=BOLD   ctermfg=245   ctermbg=NONE"

let g:colors_name = "gardener"
let colors_name   = "gardener"

