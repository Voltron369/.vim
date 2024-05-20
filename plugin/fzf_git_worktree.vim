
function! OpenGitWorktree(sink)
  let l:worktrees = systemlist('git worktree list --porcelain')
  if v:shell_error
    echohl ErrorMsg
    echomsg 'Failed to list Git worktrees: ' . l:worktrees
    echohl None
    return
  endif

  if empty(l:worktrees)
    echohl WarningMsg
    echomsg 'No Git worktrees found.'
    echohl None
    return
  endif

  let l:formatted_worktrees = []
  let l:current_worktree = ['', '']
  for l:line in l:worktrees
    if l:line =~# '^worktree '
      if !empty(l:current_worktree[0])
        call add(l:formatted_worktrees, l:current_worktree[0] . ' [' . l:current_worktree[1] . ']')
      endif
      let l:worktree_path = shellescape(substitute(l:line, '^worktree \+', '', ''))
      let l:current_worktree = [l:worktree_path, '']
    elseif l:line =~# '^branch '
      let l:current_worktree[1] = split(l:line, ' ')[1]
    endif
  endfor
  if !empty(l:current_worktree[0])
    call add(l:formatted_worktrees, l:current_worktree[0] . ' [' . l:current_worktree[1] . ']')
  endif

  call fzf#run(fzf#wrap({
        \ 'source': l:formatted_worktrees,
        \ 'sink': a:sink,
        \ 'options': '--prompt="Select a Git worktree> " --ansi',
        \ }))

endfunction

function! s:OpenWorktreeFolder(worktree)
    let l:worktree_path = substitute(a:worktree, "^'\\(.*\\)'.*$", '\1', '')
    execute 'e' fnameescape(l:worktree_path)
endfunction

command! GWorktree call OpenGitWorktree(function('s:OpenWorktreeFolder'))
