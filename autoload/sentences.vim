scriptencoding utf-8

function! sentences#chop(...) abort
  normal! m`

  if a:0 == 2
    " visual mode
    let open  = a:1
    let close = a:2
  else
    " normal mode
    let open  = "'["
    let close = "']"
  endif

  call s:chop(open, close)

  normal! g``
endfunction

function! s:chop(o,c) abort

  exe a:o . ',' . a:c . 'join'

  let gdefault = &gdefault
  set gdefault&

  " - skip dots after ordinal numbers,
  " - remove blanks after punctuation, but
  " - recognize phrases inside parentheses, braces, brackets or quotation marks
  let subst =
        \ '\C\v(%(%([^[:digit:]IVX]|[\])''"])[.]|[' . g:punctuation_marks . ']))%(\s+|([\])''"]))' 
        \ . '/'
        \ .'\1\2\r'
  exe 'silent keeppatterns substitute/' . subst . '/geI'

  let &gdefault = gdefault

  let equalprg = &l:equalprg
  let equalprg = ''
  exe 'silent keepjumps normal! ''[='']'
  let &l:equalprg = equalprg
endfunction
