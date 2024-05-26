
" Use fzf to select from argv
function! s:FzfFromArgv()
  let l:args = argv()
  if !empty(l:args)
    " Prepend line numbers to arguments
    let l:numbered_args = map(copy(l:args), 'printf("%3d: %s", v:key+1, v:val)')
    call fzf#run({
          \ 'source': l:numbered_args,
          \ 'sink*':   function('s:HandleFzfSelection'),
          \ 'options': '--multi --tac --expect "ctrl-d" --header "<CR>: go to file, <Tab>: quickfix, ctrl-d: remove from list"',
          \ 'window':  {'width': 0.9, 'height': 0.6}
          \ })
  else
    echo 'No arguments provided.'
  endif
endfunction

" Handle the selection from fzf
function! s:HandleFzfSelection(lines)
  if len(a:lines) < 2 | return | endif

  let key = a:lines[0]
  let l:selected_lines = a:lines[1:]

  if key == 'ctrl-d'
     for l:line in l:selected_lines
       let l:val = split(l:line, ': ')[1]
       execute 'argdel' l:val
     endfor
     call s:FzfFromArgv()
     return
  endif

  let l:selected_indices = []
  for l:line in l:selected_lines
    let l:index = str2nr(split(l:line, ':')[0])
    call add(l:selected_indices, l:index)
  endfor

  execute 'argument' l:selected_indices[0]
  if len(l:selected_indices) > 1
     let entries = []
     for l:index in l:selected_indices
       call add(entries, {'filename': argv()[l:index-1], 'lnum': 1, 'col': 1})
     endfor
     call setqflist([], ' ', {'items': entries})
  endif

endfunction

" Map a key sequence to call the function
command! FArgs call <sid>FzfFromArgv()
nnoremap <leader>ar :call <sid>FzfFromArgv()<CR>
nnoremap <leader>aa :$argadd<CR>
tnoremap <C-W><leader>ar <C-W>:call <sid>FzfFromArgv()<CR>
tnoremap <C-W><leader>aa <C-W>:$argadd<CR>
