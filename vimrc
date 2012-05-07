" ---------------------------------------------------------------------------
" first the disabled features due to security concerns
set modelines=0					" no modelines [http://www.guninski.com/vim1.html]
let g:secure_modelines_verbose=0 " securemodelines vimscript
let g:secure_modelines_modelines=15 " 15 available modelines

" ---------------------------------------------------------------------------
" operational settings
syntax on
set nocompatible				" vim, not vi
set ruler						" show the line number on the bar
set more						" use more prompt
set autoread					" watch for file changes
set number						" line numbers
set nohidden					" close the buffer when I close a tab (I use tabs more than buffers)
set noautowrite					" don't automagically write on :next
set lazyredraw					" don't redraw when don't have to
set mousehide					" hide the mouse when typing
set showmode					" show the mode all the time
set showcmd						" Show us the command we're typing
set noautoindent			 		" auto indent
set nocindent						" auto C indent
set nosmartindent					" more inteligent auto-indenting
"set t_Co=256					" tell terminal to use 256 color scheme
set smarttab					" tab and backspace are smart
set tabstop=4					" 4 spaces
set shiftwidth=4				" shift width
set scrolloff=3					" keep at least 3 lines above/below
set sidescrolloff=5				" keep at least 5 lines left/right
set backspace=indent,eol,start	" backspace over all kinds of things
set showfulltag					" show full completion tags
set noerrorbells				" no error bells please
set linebreak					" wrap at 'breakat' instead of last char
set tw=500						" default textwidth is a max of 500
set cmdheight=1					" command line two lines high
set updatecount=100				" flush file to disk every 100 chars
set complete=.,w,b,u,U,t,i,d	" do lots of scanning on tab completion
set ttyfast						" we have a fast terminal
set backupdir=~/.vim/backup		" save backup dir
set laststatus=2				" always show statusbar
set wildignore+=*.0,*.obj,*.pyc,*.DS_STORE,*.db,*.swc " don't match object files
set wildmode=full				" *wild* mode
set wildignore+=*.o,*~,.lo		" ignore object files
set wildmenu					" menu has tab completion
set foldcolumn=2				" 3 lines of column for fold showing, always
set magic						" Enable the "magic"
set novisualbell				" Disable ALL bells
set cursorline					" show the cursor line
set matchpairs+=<:>				" add < and > to match pairs
set whichwrap+=~,[,],<,>		" these wrap to

filetype on						" Enable filetype detection
filetype indent on				" Enable filetype-specific indenting
filetype plugin on				" Enable filetype-specific plugins

let maplocalleader=','			" all my shortcuts start with ,
let mapleader=','				" this leader is used by EasyTags, which is mapped to '\' by default

" to keep fold history
au BufWinLeave * silent! mkview	" save buffer view on exit
au BufWinEnter * silent! loadview " restore buffer view on enter

" ---------------------------------------------------------------------------
" searching
set incsearch					" incremental search
set ignorecase					" search ignoring case
set smartcase					" Ignore case when searching lowercase
set hlsearch					" highlight the search
set showmatch					" show matching bracket
set diffopt=filler,iwhite		" ignore all whitespace and sync

" ---------------------------------------------------------------------------
" setup NERDTree
let NERDTreeWinSize=35
" autocmd VimEnter * NERDTree		" start NERD on launch
" autocmd VimEnter * wincmd p		" start with cursor in main window

" Quit VIM when NERDTree is the only window left
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" ---------------------------------------------------------------------------
" setup Tlist
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0
let Tlist_Enable_Fold_Column=0
let Tlist_Show_One_File = 1		" Only show tags for current buffer
let Tlist_Compact_Format=0
let Tlist_WinWidth=35
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1

" ---------------------------------------------------------------------------
" Settings for :TOhtml (generates HTML)
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

" ---------------------------------------------------------------------------
" setup Showmarks
let g:showmarks_ignore_type="hmprq"
let g:showmarks_enable=0

" ---------------------------------------------------------------------------
" setup Eclim
" ,i imports whatever is needed for current line
nnoremap <silent> <LocalLeader>i :JavaImport<cr>
" ,d opens javadoc for statement in browser
nnoremap <silent> <LocalLeader>d :JavaDocSearch -x declarations<cr>
" ,<enter> searches context for statement
nnoremap <silent> <LocalLeader><cr> :JavaSearchContext<cr>
" ,jv validates current java file
nnoremap <silent> <LocalLeader>jv :Validate<cr>
" ,jc shows corrections for the current line of java
nnoremap <silent> <LocalLeader>jc :JavaCorrect<cr>"
let g:EclimHtmlValidate = 0	" don't validate HTML

" ---------------------------------------------------------------------------
" setup FuzzyFinder
" find in buffer == ,b
nmap <LocalLeader>b :FuzzyFinderBuffer<CR>
" find file == ,F
nmap <LocalLeader>F :FuzzyFinderFile<CR>
" find in tag == ,T
nmap <LocalLeader>T :FuzzyFinderTag<CR>

" ---------------------------------------------------------------------------
" configuration for localvimrc.vim
" don't ask, just source
let g:localvimrc_ask=0
" only source a max of 2 files
let g:localvimrc_count=2

" ---------------------------------------------------------------------------
" config for easytags
let g:easytags_file = '~/.vtags'
" tag-related keybinds:
" open tag in new tab
map <c-\> :tab split<cr>:exec("tag ".expand("<cword>"))<cr>
" open tag in split with ,\
map <localleader>\ :split <cr>:exec("tag ".expand("<cword>"))<cr>
" open tag in vsplit with ,]
map <localleader>] :vsplit <cr>:exec("tag ".expand("<cword>"))<cr>

" ---------------------------------------------------------------------------
"  Grep configuration
let Grep_Skip_Files='.* *.o'	" exclude hidden and object files

" ---------------------------------------------------------------------------
"  Gundo configuration
map <LocalLeader>g :GundoToggle<CR>
let g:pyflakes_use_quickfix=0

let g:SuperTabDefaultCompletionType = "context"

" ---------------------------------------------------------------------------
"  MiniBufExpl configuration
let g:miniBufExplCheckDupeBufs = 0	" to fix performance issues with multi-tab

" ---------------------------------------------------------------------------
"  EasyGrep setup
" set recursive search
let g:EasyGrepRecursive=1
" show the results in a proper window at the bottom
let g:EasyGrepWindow=1
" smart file choose - don't search binary and config files
let g:EasyGrepMode=2
" match the case
let g:EasyGrepIgnoreCase=0
" when doing search & replace, do it in split window mode (defautl - new tabs)
let g:EasyGrepReplaceWindowMode=1
" ---------------------------------------------------------------------------
" Mouse stuff
" this makes the mouse paste a block of text without formatting it
" (good for code)
map <MouseMiddle> <esc>"*p

" ---------------------------------------------------------------------------
" spelling...
if v:version >= 700
setlocal spell spelllang=en
" ,ss == toggle spelling
nmap <LocalLeader>ss :set spell!<CR>
endif
" default to no spelling
set nospell

" ---------------------------------------------------------------------------
" turn on omni-completion for the appropriate file types.
" these enabled gliches vim
" autocmd filetype python set omnifunc=pythoncomplete#complete
" autocmd filetype javascript set omnifunc=javascriptcomplete#completejs
" autocmd filetype html set omnifunc=htmlcomplete#completetags
" autocmd filetype css set omnifunc=csscomplete#completecss
" autocmd filetype xml set omnifunc=xmlcomplete#completetags
" autocmd filetype php set omnifunc=phpcomplete#completephp
" autocmd filetype c set omnifunc=ccomplete#complete
" autocmd filetype ruby,eruby set omnifunc=rubycomplete#complete
set omnifunc=syntaxcomplete#Complete

" auto-close popup when exiting insert mode
" autocmd insertleave * if pumvisible() == 0|pclose|endif
" " set the form of popup
set completeopt=longest,menuone
" " -- configs --
let OmniCpp_MayCompleteDot = 1		" autocomplete with .
let OmniCpp_MayCompleteArrow = 1	" autocomplete with ->
let OmniCpp_MayCompleteScope = 1	" autocomplete with ::
let OmniCpp_SelectFirstItem = 2		" select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2		" search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1	" show function prototype (i.e. parameters) in popup window

" when omnicompletion is visible, map 'enter' as selector key
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" those to basically keeps the nearest completion match highligted
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" -- ctags --
" map <ctrl>+f12 to generate ctags for current folder:
map <F12> :!ctags -f .tags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>
" map the :EasyPeasy command to CTRL-F11
nmap <F11> :EasyPeasy<CR>
" add current directory's generated tags file to available tags
set tags+=.tags
" And also source local vimrc files, which I use for adding extra tag files from ~/.vim/tags folder
if (filereadable(getcwd() . "/.lvimrc"))
	exec "source .lvimrc"
endif

" ---------------------------------------------------------------------------
"  Set Lua support
let lua_complete_omni=1
" ---------------------------------------------------------------------------
" some useful mappings
" when navigating treat wrapped lines as separate
nnoremap j gj
nnoremap k gk
" Omnicomplete as Ctrl+Space
inoremap <Nul> <C-x><C-o>
" Also map user-defined omnicompletion as Ctrl+k
inoremap <C-k> <C-x><C-u>
" Y yanks from cursor to $
map Y y$
" map space in normal mode
noremap <space> :
" ,f == Grep search
nnoremap <silent><LocalLeader>f :Regrep <CR>
" ,T == show TODO (already mapped to <Leader>TT)
" map <LocalLeader>T :TaskList<CR>
" jj in insert mode == Esc
imap jj <Esc>
" toggle list mode
nmap <LocalLeader>tl :set list!<cr>
" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>
" toggle wrapping
nmap <LocalLeader>ww :set wrap!<cr>
" change directory to that of current file
nmap <LocalLeader>cd :cd%:p:h<cr>
" change local directory to that of current file
nmap <LocalLeader>lcd :lcd%:p:h<cr>
" correct type-o's on exit
nmap q: :q
" save and build
nmap <LocalLeader>wm :w<cr>:make<cr>
" open all folds
nmap <LocalLeader>o :%foldopen!<cr>
" close all folds
nmap <LocalLeader>c :%foldclose!<cr>
" ,tt will toggle taglist on and off
nmap <LocalLeader>tt :Tlist<cr>
" ,n will toggle NERDTree on and off
nmap <LocalLeader>n :NERDTreeToggle<cr>
" When I'm pretty sure that the first suggestion is correct
map <LocalLeader>st 1z=
" If I forgot to sudo vim a file, do that with :w!!
cmap w!! %!sudo tee > /dev/null %
" Fix the # at the start of the line
inoremap # X<BS>#
" Fold with paren begin/end matching
nmap <LocalLeader>z zf%
" Fold all functions (C type)
nmap <LocalLeader>Z :g/^{$/normal zf%<CR>
" When I use ,sf - return to syntax folding with a big foldcolumn
nmap <LocalLeader>sf :set foldcolumn=6 foldmethod=syntax<cr>
" GPG helpers
nmap <LocalLeader>E :1,$!gpg --armor --encrypt 2>/dev/null<CR>
nmap <LocalLeader>ES :1,$!gpg --armor --encrypt --sign 2>/dev/null<CR>
nmap <LocalLeader>S :1,$!gpg --clearsign 2>/dev/null<CR>
" Switch tabs with ctrl-tab and ctrl-shift-tab like most browsers
map <C><Tab> gt
map <C-S-Tab> gT 
" Switch to a specific tab
map <LocalLeader>1 1gt
map <LocalLeader>2 2gt
map <LocalLeader>3 3gt
map <LocalLeader>4 4gt
map <LocalLeader>5 5gt
map <LocalLeader>6 6gt
map <LocalLeader>7 7gt
map <LocalLeader>8 8gt
map <LocalLeader>9 9gt
map <LocalLeader>0 :tablast<CR>
" move between splits faster
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
" resize splits with + and -
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

" ---------------------------------------------------------------------------
" tabs
" (LocalLeader is ",")
" create a new tab
map <LocalLeader>tc :tabnew %<cr>
" close a tab
map <LocalLeader>td :tabclose<cr>
" next tab
map <LocalLeader>tn :tabnext<cr>
" next tab
map <silent><m-Right> :tabnext<cr>
" previous tab
map <LocalLeader>tp :tabprev<cr>
" previous tab
map <silent><m-Left> :tabprev<cr>
" move a tab to a new location
map <LocalLeader>tm :tabmove

" ---------------------------------------------------------------------------
" Diff with saved version of the file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ---------------------------------------------------------------------------
" auto load extensions for different file types
if has('autocmd')
      filetype plugin indent on
      syntax on

" jump to last line edited in a given file (based on .viminfo)
"autocmd BufReadPost *
" \ if !&diff && line("'\"") > 0 && line("'\"") <= line("$") |
" \ exe "normal g`\"" |
" \ endif
      autocmd BufReadPost *
                        \ if line("'\"") > 0|
                        \ if line("'\"") <= line("$")|
                        \ exe("norm '\"")|
                        \ else|
                        \ exe "norm $"|
                        \ endif|
                        \ endif

" improve legibility
      au BufRead quickfix setlocal nobuflisted wrap number

" configure various extensions
      let git_diff_spawn_mode=2

" improved formatting for markdown
" http://plasticboy.com/markdown-vim-mode/
      autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
endif

" ---------------------------------------------------------------------------
" setup for the visual environment
if $TERM =~ '^xterm'
      set t_Co=256
elseif $TERM =~ '^screen-bce'
      set t_Co=256 " just guessing
elseif $TERM =~ '^rxvt'
      set t_Co=88
elseif $TERM =~ '^linux'
      set t_Co=8
else
      set t_Co=16
endif

" ---------------------------------------------------------------------------
" Correct some spelling mistakes
ia teh		the
ia hte		the
ia htis		this
ia thsi		this
ia funciton	function
ia fucntion	function
ia funtion	function
ia retunr	return
ia reutrn	return
ia sefl		self
ia eslf		self

set t_Co=256
colorscheme brookstream

map! { {}ko
" -------------------------------------------------------------

" specify syntax to some files
autocmd BufRead,BufNewFile *.inc set syntax=asm
autocmd BufRead,BufNewFile *.sh call CheckIfShell()

" Sets auto-close 'do' with 'done'
function AutoCloseDo()
	map! do dodoneko
endfunction
" Sets auto-close 'if' with 'fi'
function AutoCloseIf()
	map! then thenfiko
endfunction

function CheckIfShell()
" Creates a 'map!' to auto-close 'if' with 'fi' and 'do' with 'done'
" for shell script files.
	if &filetype == "sh"
		call AutoCloseDo()
		call AutoCloseIf()
	endif
endfunction

augroup ft_php
    " applies to php files
    autocmd!
    autocmd FileType php syntax sync minlines=256
    autocmd FileType php setlocal nocursorline nocursorcolumn
augroup END
