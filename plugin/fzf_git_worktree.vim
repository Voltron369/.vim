
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
        \ 'options': '--print-query --multi --prompt="Select a Git worktree> " --ansi --expect "ctrl-d,ctrl-r,ctrl-y,:,;,ctrl-n" --header "<CR> go to worktree, ctrl-n: new worktree, ctrl-d/r: remove, ctrl-y: yank, "":"" populate :"',
        \ }))

endfunction

function! s:SwitchToWorktree(worktree_path, worktree)
  let l:target_file = a:worktree_path . '/' . substitute(expand('%:p'), '^' . getcwd() . '/', '', '')
  if filereadable(l:target_file)
     execute 'e' fnameescape(l:target_file)
     echo "Switched to" a:worktree
  else
     execute 'cd' a:worktree_path
     execute 'e .'
     echo "Could not find" l:target_file "in" a:worktree
  endif
endfunction

function! s:OpenWorktreeFolder(lines)
  if len(a:lines) < 2 | return | endif

  let l:input = trim(shellescape(a:lines[0]), " \r\t\n\"'")
  let l:key = a:lines[1]
  let l:selected_lines = a:lines[2:]

  let l:GetPath = {line -> substitute(line, ".*\\['\\(.*\\)'].*$", '\1', '')}

  if l:key == 'ctrl-d'
     for l:worktree in l:selected_lines
       let out = system('git worktree remove ' .. fnameescape(l:GetPath(l:worktree)))
       if v:shell_error
          echo out
          call input('Error.  Press <CR> to dismiss.')
          return
       endif
     endfor
     call OpenGitWorktree()
     return
  endif

  if l:key == 'ctrl-y'
     let l:worktrees = map(copy(l:selected_lines), 'nameescape(l:GetPath(v:val))')
     eval map(['*','"','+','0'], "setreg(v:val, join(l:worktrees))")
     return
  endif

  if l:key == ':'
     cal feedkeys(": " .. join(map(copy(l:selected_lines), 'fnameescape(l:GetPath(v:val))')) .. "\<C-b>", 'n')
     return
  endif

  if l:key == ';'
     let l:old_worktree_path = fugitive#repo().tree()
     let l:worktree  = strftime('master_%Y_%m_%d_%H_%M_%S')
     let l:worktree_path = l:old_worktree_path . '/../' . l:worktree
     if len(l:input)
        call feedkeys(":!git worktree add -b " .. l:input .. ' ' .. l:worktree_path .. " origin/master\<C-b>", 'n')
     else
        call feedkeys(":!git worktree add " .. l:worktree_path .. " origin/master\<C-b>", 'n')
     endif
     return
  endif

  if l:key == 'ctrl-n'
     let l:old_worktree_path = fugitive#repo().tree()
     let l:worktree  = strftime('%Y_%m_%d_%H_%M_%S')
     let l:worktree_path = l:old_worktree_path . '/../' . l:worktree
     let out = system('git fetch origin master')
     if v:shell_error
        echo out
        call input('Error.  Press <CR> to dismiss.')
        return
     endif
     if len(l:input)
        let out = system('git worktree add -b ' .. l:input .. ' ' .. l:worktree_path .. ' origin/master')
     else
        let out = system('git worktree add ' .. l:worktree_path .. ' origin/master')
     endif
     if v:shell_error
        echo out
        call input('Error.  Press <CR> to dismiss.')
        return
     endif
     call <sid>SwitchToWorktree(l:worktree_path, l:worktree)
  endif

  if len(l:selected_lines)
     let l:worktree = l:selected_lines[0]
     let l:worktree_path = l:GetPath(l:worktree)

     call <sid>SwitchToWorktree(l:worktree_path, l:worktree)
  endif
endfunction

command! Gworktree call OpenGitWorktree()
command! GWorktree call OpenGitWorktree()
