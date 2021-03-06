"============================================================================
"File:        rst.vim
"Description: Syntax checking plugin for docutil's reStructuredText files
"Maintainer:  James Rowe <jnrowe at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

" We use rst2pseudoxml.py, as it is ever so marginally faster than the other
" rst2${x} tools in docutils.

if exists("g:loaded_syntastic_rst_rst2pseudoxml_checker")
    finish
endif
let g:loaded_syntastic_rst_rst2pseudoxml_checker = 1

let s:rst2pseudoxml = executable('rst2pseudoxml.py') ? 'rst2pseudoxml.py' : 'rst2pseudoxml'

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rst_rst2pseudoxml_GetLocList() dict
    let makeprg = self.makeprgBuild({
        \ 'args_after': '--report=2 --exit-status=1',
        \ 'tail': syntastic#util#DevNull() })

    let errorformat =
        \ '%f:%l: (%tNFO/1) %m,'.
        \ '%f:%l: (%tARNING/2) %m,'.
        \ '%f:%l: (%tRROR/3) %m,'.
        \ '%f:%l: (%tEVERE/4) %m,'.
        \ '%-G%.%#'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

    for e in loclist
        if e['type'] ==? 'S'
            let e['type'] = 'E'
        elseif e['type'] ==? 'I'
            let e['type'] = 'W'
            let e['subtype'] = 'Style'
        endif
    endfor

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rst',
    \ 'name': 'rst2pseudoxml',
    \ 'exec': s:rst2pseudoxml })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
