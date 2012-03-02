" File:		vrackets.vim
" Author:	Gerardo Marset (gammer1994@gmail.com)
" Version:	0.2
" Last Change:  2011-07-22
" Description:	Automatically close/delete different kinds of brackets.

" You can modify this dictionary as you wish.
let s:match = {'(': ')',
              \'{': '}',
              \'[': ']',
              \'¡': '!',
              \'¿': '?'}
" This list is for pairs in which the closing symbol is the same as the
" opening one.
let s:smatch = ["'", "\""]

let s:alpha = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
              \"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
              \"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
              \"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
for [s:o, s:c] in items(s:match)
    execute 'ino <silent> ' . s:o . " <C-R>=VracketOpen('" . s:o . "')<CR>"
    execute 'ino <silent> ' . s:c . " <C-R>=VracketClose('" . s:o . "')<CR>"
endfor
for s:b in s:smatch
    execute 'ino <silent> ' . s:b . ' <C-R>=VracketBoth("\' . s:b . '")<CR>'
endfor
inoremap <silent> <BS> <C-R>=VracketBackspace()<CR>

function! VracketOpen(bracket)
    let l:o = a:bracket
    let l:c = s:match[l:o]

    return l:o . l:c . "\<Left>"
endfunction

function! VracketClose(bracket)
    let l:c = s:match[a:bracket]

    if s:GetCharAt(0) == l:c
        return "\<Right>"
    endif
    return l:c
endfunction

function! VracketBoth(bracket)
    if s:GetCharAt(0) == a:bracket
        return "\<Right>"
    endif
    if col('.') == 1
        return a:bracket . a:bracket . "\<Left>"
    endif
    if s:GetCharAt(-1) == a:bracket || count(s:alpha, s:GetCharAt(-1)) == 1
        return a:bracket
    endif
    return a:bracket . a:bracket . "\<Left>"
endfunction

function! VracketBackspace()
    if col('.') == 1
        return "\<BS>"
    endif

    if get(s:match, s:GetCharAt(-1), '  ') == s:GetCharAt(0)
        return "\<Esc>2s"
    endif

    if count(s:smatch, s:GetCharAt(0)) == 1 && s:GetCharAt(-1) == s:GetCharAt(0)
        return "\<Esc>2s"
    endif
    return "\<BS>"
endfunction

function! s:GetCharAt(...)
    " Super Dirty Function(tm).
    let l:n = a:0 ? a:1 : 0
    let l:vi = &virtualedit
    let l:im = @@
    set virtualedit=onemore

    if l:n == 0
        normal yl
    elseif l:n < 0
        execute 'normal ' . -l:n . 'h'
        normal yl
        execute 'normal ' . -l:n . 'l'
    else
        execute 'normal ' . l:n . 'l'
        normal yl
        execute 'normal ' . l:n . 'h'
    endif

    let l:char = @@
    let &virtualedit=l:vi
    let @@ = l:im
    return l:char
endfunction
