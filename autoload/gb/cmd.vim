if !exists("g:go_dispatch_enabled")
    let g:go_dispatch_enabled = 0
endif

" Build builds the source code without producting any output binary. We live in
" an editor so the best is to build it to catch errors and fix them. By
" default it tries to call simply 'go build', but it first tries to get all
" dependent files for the current folder and passes it to go build.
function! gb#cmd#Build(bang, ...)
    let default_makeprg = &makeprg

    let old_gopath = $GOPATH
    let $GOPATH = go#path#Detect()

    let &makeprg = "gb build"

    echon "vim-go: " | echohl Identifier | echon "building ..."| echohl None
    if g:go_dispatch_enabled && exists(':Make') == 2
        silent! exe 'Make'
    else
        silent! exe 'make!'
    endif
    redraw!

    cwindow
    let errors = getqflist()
    if !empty(errors) 
        if !a:bang
            cc 1 "jump to first error if there is any
        endif
    else
        redraws! | echon "vim-go: " | echohl Function | echon "[build] SUCCESS"| echohl None
    endif

    let &makeprg = default_makeprg
    let $GOPATH = old_gopath
endfunction

" vim:ts=4:sw=4:et
"
