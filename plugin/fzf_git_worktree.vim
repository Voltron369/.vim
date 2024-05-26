
function! OpenGitWorktree()
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
        call add(l:formatted_worktrees, l:current_worktree[1] . ' [' . l:current_worktree[0] . ']')
      endif
      let l:worktree_path = shellescape(substitute(l:line, '^worktree \+', '', ''))
      let l:current_worktree = [l:worktree_path, '']
    elseif l:line =~# '^branch '
      let l:current_worktree[1] = substitute(split(l:line, ' ')[1], 'refs/heads/', '', '')
    elseif l:line =~# '^detached'
      let l:current_worktree[1] = 'detached'
    endif
  endfor
  if !empty(l:current_worktree[0])
    call add(l:formatted_worktrees, l:current_worktree[1] . ' [' . l:current_worktree[0] . ']')
  endif

  call fzf#run(fzf#wrap({
        \ 'source': l:formatted_worktrees,
        \ 'sink*': function('s:OpenWorktreeFolder'),
        \ 'options': '--prompt="Select a Git worktree> " --ansi --expect "ctrl-d,ctrl-r" --header "<CR> go to worktree, ctrl-d/r: remove"',
        \ }))

endfunction

function! s:OpenWorktreeFolder(lines)
  if len(a:lines) < 2 | return | endif

  let key = a:lines[0]
  let l:selected_lines = a:lines[1:]
  let l:worktree = l:selected_lines[0]

  if key == 'ctrl-d'
     for l:worktree in l:selected_lines
       let l:worktree_path = substitute(l:worktree, ".*\\['\\(.*\\)'].*$", '\1', '')
       execute 'G worktree remove' l:worktree_path
     endfor
     call OpenGitWorktree()
     return
  endif

  let l:worktree_path = substitute(l:worktree, ".*\\['\\(.*\\)'].*$", '\1', '')
  let target_file = l:worktree_path . '/' . substitute(expand('%:p'), '^' . getcwd() . '/', '', '')
  if filereadable(target_file)
     execute 'e' fnameescape(target_file)
     echo "Switched to" l:worktree
  else
     execute 'e' l:worktree_path
     echo "Could not find" target_file "in" l:worktree
  endif
endfunction

command! Gworktree call OpenGitWorktree()
command! GWorktree call OpenGitWorktree()
