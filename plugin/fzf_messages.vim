
" FZF messages wrapper
function! s:fzf_messages(...)
    let l:lines = split(execute('messages'), '\n')
    call fzf#run(fzf#wrap({
        \ 'source': l:lines,
        \ 'sink*': function('s:copy_lines'),
        \ 'options': '--multi --ansi --tac --no-sort',
        \ }))
endfunction

" messages handler
function! s:copy_lines(lines)
  if !len(a:lines) | return | endif

  eval map(['*','"','+','0'], 'setreg(v:val, join(a:lines, "\\n"))')
endfunction

" Command to call the wrapper
command! Messages call s:fzf_messages()
