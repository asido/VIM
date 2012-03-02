" Name: FixCSS.vim
" Maintainer: Daniel Bolton <https://github.com/dbb>
" Version: 0.1
" Last Change: 18 Aug 2011
function! FixCSS()
    let pos = line( "." )
    silent :%s/{/{\r/g
    silent :%s/}/}\r\r/g
    silent :%s/;/;\r/g
    exe pos
endfunction
command! Fixcss call FixCSS()

