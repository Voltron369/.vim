
" FZF messages wrapper
function! s:fzf_netrw_bookmarklist(...)
    call fzf#run(fzf#wrap({
        \ 'source': copy(g:netrw_bookmarklist),
        \ 'sink': 'e',
        \ 'options': '--ansi --tac --no-sort',
        \ }))
endfunction

" Command to call the wrapper
command! Historyb call s:fzf_netrw_bookmarklist()
