" PATCH: set scratch file properly (wipe, noswapfile)

function! gitgutter#difforig()
  let bufnr = bufnr('')
  let filetype = &filetype

  vertical new
  set buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  let &filetype = filetype

  if g:gitgutter_diff_relative_to ==# 'index'
    let index_name = gitgutter#utility#get_diff_base(bufnr).':'.gitgutter#utility#base_path(bufnr)
    let cmd = gitgutter#git(bufnr).' --no-pager show '.index_name
    " NOTE: this uses &shell to execute cmd.  Perhaps we should use instead
    " gitgutter#utility's use_known_shell() / restore_shell() functions.
    silent! execute "read ++edit !" cmd
  else
    silent! execute "read ++edit" gitgutter#utility#repo_path(bufnr, 1)
  endif

  0d_
  diffthis
  setlocal nomodifiable
  wincmd p
  diffthis
endfunction
