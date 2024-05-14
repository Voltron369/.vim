
" FZF messages wrapper
function! s:fzf_messages(...)
    let l:lines = split(execute('messages'), '\n')
    call fzf#run(fzf#wrap({
        \ 'source': l:lines,
        \ 'sink*': function('s:copy_line'),
        \ 'options': '--ansi --tac --no-sort',
        \ }))
endfunction

" messages handler
function! s:copy_line(line)
    if !empty(a:line)
      let @+ = a:line[0]
      let @0 = a:line[0]
      let @* = a:line[0]
    endif
endfunction

" Command to call the wrapper
command! Messages call s:fzf_messages()
