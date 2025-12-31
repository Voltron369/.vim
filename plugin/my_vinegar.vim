
let NAList = {list -> {type(""): [], type([]): list}[type(list)]}
let NAString = {list -> list ==# 'n/a' ? '' : list}

augroup my_vinegar
  autocmd!
  autocmd FileType netrw nmap <buffer> <Tab> mfj
  autocmd FileType netrw nmap <buffer> <S-Tab> mfk
  autocmd FileType netrw nnoremap <buffer> ; :<C-U> <C-R>=join(map(copy(NAList(netrw#Expose("netrwmarkfilelist"))), 'fnameescape(v:val)'), " ")<CR><HOME>
  autocmd FileType netrw nnoremap <buffer> g: :<C-U> <C-R>=fnameescape(NAString(netrw#Expose("netrwmftgt")))<CR><HOME>
  autocmd FileType netrw nnoremap <buffer> : :<C-U> <C-R>=join([join(map(copy(NAList(netrw#Expose("netrwmarkfilelist"))), 'fnameescape(v:val)'), " "),fnameescape(NAString(netrw#Expose("netrwmftgt")))]," ")<CR><HOME>
  autocmd FileType netrw nmap <buffer> qb <Cmd>Historyb<CR>
augroup END

