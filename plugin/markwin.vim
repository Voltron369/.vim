

function! MarkWin(reg)
   let l:reg = a:reg
   if l:reg ==# '"'
      let l:reg = input('Enter mark for tab [a-z]: ')
   endif
   exe 'let @' . l:reg '=":silent! call win_gotoid(' . win_getid() . ')\n"'
endfunction
command! MarkWin :call MarkWin("\"")
nnoremap <leader>t :call MarkWin(v:register)<CR>
tnoremap <C-w><leader>t <C-w>:call MarkWin(v:register)<CR>
tnoremap <C-w><C-@> <C-w>:@
tnoremap <C-w>@ <C-w>:@
