
function! UpdateBLines()
   if &modified
      nnoremap <buffer> <C-_> :BLines<CR> | " actually Ctrl-/
      nnoremap <buffer> <leader>/ :BLines<CR>
   else
      execute 'nnoremap <buffer> <C-_> :Ag<CR>''' . expand("%") . ": "
      execute 'nnoremap <buffer> <leader>/ :Ag<CR>''' . expand("%") . ": "
   endif
endfunction
augroup BLines
   autocmd!
   autocmd VimEnter,BufEnter,BufWritePost,TextChanged,TextChangedI,DirChanged * call UpdateBLines()
augroup END

