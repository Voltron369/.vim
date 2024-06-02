
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
  let l:cwd = "'" . fugitive#repo().tree() . "'"
  let l:header = ""
  for l:line in l:worktrees
    if l:line =~# '^worktree '
      if !empty(l:current_worktree[0])
         if l:current_worktree[0] ==# l:cwd
           let l:header = l:current_worktree[1] . " [" . l:current_worktree[0] . "]\n"
         else
           call add(l:formatted_worktrees, l:current_worktree[1] . ' [' . l:current_worktree[0] . ']')
         endif
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
    if l:current_worktree[0] ==# l:cwd
      let l:header = l:current_worktree[1] . " [" . l:current_worktree[0] . "]\n"
    else
       call add(l:formatted_worktrees, l:current_worktree[1] . ' [' . l:current_worktree[0] . ']')
     endif
  endif
  let l:header .= ":: <CR> go to worktree, ctrl-n: new worktree, ctrl-d: delete selected, ctrl-r: remove current, ctrl-y: yank, \":\" populate :"
  let l:prompt = "Select a Git worktree> "
  let l:valid_keys = "ctrl-d,ctrl-r,ctrl-y,:,;,ctrl-n"
  let l:fzf_options = [
        \ '--print-query',
        \ '--multi',
        \ '--prompt', l:prompt,
        \ '--ansi',
        \ '--expect', l:valid_keys,
        \ '--header', l:header,
        \ '--preview', 'git -C $(echo {} | sed -e "s/^.*\[''\(.*\)''\]/\1/") reflog',
        \]
  " "s/^.*\['\(.*\)'\]$/\1/"
        " \ '--preview', 'echo "{}" | sed -e "s/^.*\[''\(.*\)''\]/\1/") | xargs -I {} git -C {} reflog',
        " \ '--preview', 'echo "s/^.*\[''\(.*\)''\]$/\1/"',
  call fzf#run(fzf#wrap({
        \ 'source': l:formatted_worktrees,
        \ 'sink*': function('s:OpenWorktreeFolder'),
        \ 'options': l:fzf_options
        \ }))

endfunction

function! s:GetWorktreePath()
  let l:out = system('git rev-parse --git-common-dir')
  if v:shell_error
     echo out
     call input('Error.  Press <CR> to dismiss.')
     echoerr out
     return ""
  endif
  return substitute(out,'\n$','','') .. '/../../worktrees/'
endfunction

function! s:SwitchToWorktree(worktree_path, worktree)
  let l:cwd = fugitive#repo().tree()
  let l:git_filename = substitute(expand('%:p'), '^' . l:cwd . '/', '', '')
  let l:target_file = a:worktree_path .. '/' .. l:git_filename
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
     let l:worktree_common_dir = <sid>GetWorktreePath()
     if !len(l:worktree_common_dir) | return | endif
     if len(l:input)
        let l:worktree = l:input
        let l:worktree_path = l:worktree_common_dir .. l:worktree
        call feedkeys(":!git worktree add -b " .. l:input .. ' ' .. l:worktree_path .. " origin/master\<C-b>", 'n')
     else
        let l:worktree = strftime('%Y_%m_%d_%H_%M_%S')
        let l:worktree_path = l:worktree_common_dir .. l:worktree
        call feedkeys(":!git worktree add " .. l:worktree_path .. " origin/master\<C-b>", 'n')
     endif
     return
  endif

  if l:key == 'ctrl-n'
     let l:worktree_common_dir = <sid>GetWorktreePath()
     if !len(l:worktree_common_dir) | return | endif
     let out = system('git fetch origin master')
     if v:shell_error
        echo out
        call input('Error.  Press <CR> to dismiss.')
        return
     endif
     if len(l:input)
        let l:worktree = l:input
        let l:worktree_path = l:worktree_common_dir .. l:worktree
        let out = system('git worktree add -b ' .. l:input .. ' ' .. l:worktree_path .. ' origin/master')
     else
        let l:worktree = strftime('%Y_%m_%d_%H_%M_%S')
        let l:worktree_path = l:worktree_common_dir .. l:worktree
        let out = system('git worktree add ' .. l:worktree_path .. ' origin/master')
     endif
     if v:shell_error
        echo out
        call input('Error.  Press <CR> to dismiss.')
        return
     endif
     call <sid>SwitchToWorktree(l:worktree_path, l:worktree)
     return
  endif

  if l:key == 'ctrl-r'
     let l:cwd = fugitive#repo().tree()
     let out = system('git worktree remove ' .. l:cwd)
     if v:shell_error
        echo out
        call input('Error.  Press <CR> to dismiss.')
        return
     endif
  endif

  if len(l:selected_lines)
     let l:worktree = l:selected_lines[0]
     let l:worktree_path = l:GetPath(l:worktree)

     call <sid>SwitchToWorktree(l:worktree_path, l:worktree)
  endif
endfunction

command! Gworktree call OpenGitWorktree()
command! GWorktree call OpenGitWorktree()
