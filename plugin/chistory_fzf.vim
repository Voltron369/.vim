
" FZF chistory wrapper
function! s:fzf_chistory(...)
    let l:lines = split(execute('chistory'), '\n')
    call fzf#run(fzf#wrap({
        \ 'source': l:lines,
        \ 'sink*': function('s:chistory_handler'),
        \ 'options': '--ansi',
        \ }))
endfunction

" chistory handler
function! s:chistory_handler(line)
    if !empty(a:line)
        let l:id = trim(split(substitute(a:line[0], '^> ', ' ', ''), ' ')[2])
        execute l:id 'chistory' | copen
    endif
endfunction

" Command to call the wrapper
command! Chistory call s:fzf_chistory()
command! CHistory call s:fzf_chistory()
