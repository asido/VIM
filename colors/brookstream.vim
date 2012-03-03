"--------------------------------------------------------------------
" Name Of File: brookstream.vim.
" Description: Gvim colorscheme, works best with version 6.1 GUI .
" Maintainer: Peter Bäckström.
" Creator: Peter Bäckström.
" URL: http://www.brookstream.org (Swedish).
" Credits: Inspiration from the darkdot scheme.
" Last Change: Friday, April 13, 2003.
" Installation: Drop this file in your $VIMRUNTIME/colors/ directory.
"--------------------------------------------------------------------

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="brookstream"

"--------------------------------------------------------------------

hi Normal		ctermbg=16	ctermfg=145	cterm=none	guibg=#000000	guifg=#afafaf	gui=none
hi Cursor		ctermbg=10	ctermfg=16	cterm=none	guibg=#44ff44	guifg=#000000	gui=none
hi Directory				ctermfg=6	cterm=none					guifg=#44ffff	gui=none
hi DiffAdd		ctermbg=232	ctermfg=226	cterm=none	guibg=#080808	guifg=#ffff00	gui=none
hi DiffDelete	ctermbg=232	ctermfg=238	cterm=none	guibg=#080808	guifg=#444444	gui=none
hi DiffChange	ctermbg=232	ctermfg=231	cterm=none	guibg=#080808	guifg=#ffffff	gui=none
hi DiffText		ctermbg=232	ctermfg=1	cterm=none	guibg=#080808	guifg=#bb0000	gui=none
hi ErrorMsg		ctermbg=88	ctermfg=231	cterm=none	guibg=#880000	guifg=#ffffff	gui=none
hi Folded		ctermbg=242	ctermfg=16	cterm=none	guibg=#6d6d6d	guifg=#000088	gui=none
hi IncSearch	ctermbg=16	ctermfg=153	cterm=none	guibg=#000000	guifg=#bbcccc	gui=none
hi LineNr		ctermbg=232	ctermfg=31	cterm=none	guibg=#050505	guifg=#4682b4	gui=none
hi ModeMsg					ctermfg=231	cterm=none					guifg=#ffffff	gui=none
hi MoreMsg					ctermfg=10	cterm=none		 			guifg=#44ff44	gui=none
hi NonText					ctermfg=7	cterm=none					guifg=#4444ff	gui=none
hi Question					ctermfg=226	cterm=none					guifg=#ffff00	gui=none
hi SpecialKey				ctermfg=7	cterm=none					guifg=#4444ff	gui=none
hi StatusLine	ctermbg=234	ctermfg=231	cterm=none	guibg=#1d1d1d	guifg=#ffffff	gui=none
hi StatusLineNC	ctermbg=236	ctermfg=231	cterm=none	guibg=#2d2d2d	guifg=#ffffff	gui=none
hi Title					ctermfg=231	cterm=none					guifg=#ffffff	gui=none
hi Visual		ctermbg=250	ctermfg=16	cterm=none	guibg=#bbbbbb	guifg=#000000	gui=none
hi WarningMsg				ctermfg=226	cterm=none					guifg=#ffff00	gui=none
hi CursorLine	ctermbg=234				cterm=none	guibg=#1a1a1a					gui=none
hi Pmenu		ctermbg=236	ctermfg=248	cterm=none	guibg=#222222	guifg=#aaaaaa	gui=none
hi PmenuSel		ctermbg=248	ctermfg=236	cterm=none	guibg=#aaaaaa	guifg=#222222	gui=none

" syntax highlighting groups ----------------------------------------

hi Comment					ctermfg=240	cterm=none					guifg=#696969	gui=none
hi Constant					ctermfg=32	cterm=none					guifg=#00aaaa	gui=none
hi Identifier				ctermfg=45	cterm=none					guifg=#00e5ee	gui=none
hi Statement				ctermfg=51	cterm=none					guifg=#00ffff	gui=none
hi PreProc					ctermfg=69	cterm=none					guifg=#8470ff	gui=none
hi Type						ctermfg=231	cterm=none					guifg=#ffffff	gui=none
hi Special					ctermfg=7	cterm=none					guifg=#87cefa	gui=none
hi Underlined		 		ctermfg=7	cterm=none					guifg=#4444ff	gui=none
hi Ignore	 				ctermfg=238	cterm=none					guifg=#444444	gui=none
hi Error		ctermbg=16	ctermfg=1	cterm=none	guibg=#000000	guifg=#bb0000	gui=none
hi Todo			ctermbg=124	ctermfg=226	cterm=none	guibg=#aa0006	guifg=#fff300	gui=none
hi Operator  				ctermfg=39	cterm=none					guifg=#00bfff	gui=none
hi Function 				ctermfg=12	cterm=none					guifg=#1e90ff	gui=none
hi String 	 				ctermfg=31	cterm=none					guifg=#4682b4	gui=none
hi Boolean					ctermfg=72	cterm=none					guifg=#9bcd9b	gui=none

"hi link Character Constant
"hi link Number    Constant
"hi link Boolean   Constant
"hi link Float   Number
"hi link Conditional Statement
"hi link Label   Statement
"hi link Keyword   Statement
"hi link Exception Statement
"hi link Repeat    Statement
"hi link Include   PreProc
"hi link Define    PreProc
"hi link Macro   PreProc
"hi link PreCondit PreProc
"hi link StorageClass  Type
"hi link Structure Type
"hi link Typedef   Type
"hi link Tag   Special
"hi link Delimiter Special
"hi link SpecialComment  Special
"hi link Debug   Special
hi FoldColumn	ctermbg=232							guibg=#080808 

"- end of colorscheme -----------------------------------------------	
