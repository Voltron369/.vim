function! s:NewWorktree(istrack, git_bin, branch, input)
   let l:worktree_common_dir = <sid>GetWorktreePath()
   if !len(l:worktree_common_dir) | return | endif
   let l:worktree_path = <sid>GetWorktreePath() . a:branch
   let l:cwd = fugitive#repo().tree()
   let l:branch =  a:istrack ==# 'track' ? substitute(a:branch, 'origin/', '', '') : a:branch
   let l:out = system(a:git_bin . ' -C ' . l:cwd . ' worktree add '  . l:worktree_path . ' ' . l:branch )
   if v:shell_error
      if (-1 != match(l:out, "is already checked out at") || -1 != match(l:out, "already exists"))
         let l:in = tolower(input(l:out . "\n(S)witch to existing worktree or create (N)ew worktree with detached head: "))
         if (l:in ==# 's')
            if (-1 != match(l:out, "is already checked out at"))
               let l:worktree_path = split(l:out,"'")[3]
            elseif (-1 != match(l:out, "already exists"))
               let l:worktree_path = split(l:out,"'")[1]
            endif
         elseif (l:in ==# 'n')
            let l:old_worktree_path = fugitive#repo().tree()
            let l:worktree_path = <sid>GetWorktreePath() . strftime('%Y_%m_%d_%H_%M_%S')
            let out = system(a:git_bin . ' -C ' . l:cwd . ' worktree add --detach ' . l:worktree_path . ' ' . a:branch)
            if v:shell_error
               echo out
               call input('Error.  Press <CR> to dismiss.')
               return
            endif
         endif
      else
         echo out
         call input('Error.  Press <CR> to dismiss.')
         return
      endif
   else
      if <sid>IsDetached(l:worktree_path)
         let l:old_worktree_path = l:worktree_path
         let l:worktree = strftime('%Y_%m_%d_%H_%M_%S')
         let l:worktree_path = <sid>GetWorktreePath() .. l:worktree
         let out = system(a:git_bin . ' -C ' . l:cwd . ' worktree move ' .. l:old_worktree_path .. ' ' .. l:worktree_path)
         if v:shell_error
            echo out
            call input('Error.  Press <CR> to dismiss.')
            return
         endif
      endif
   endif
   call <sid>SwitchToWorktree(l:worktree_path)
endfunction

function! s:SwitchToWorktree(worktree_path)
  let l:cwd = fugitive#repo().tree()
  let l:git_filename = substitute(expand('%:p'), '^' . l:cwd . '/', '', '')
  let l:target_file = a:worktree_path .. '/' .. l:git_filename
  if filereadable(l:target_file)
     execute 'e' fnameescape(l:target_file)
     echo "Switched to" target_file
  else
     execute 'cd' a:worktree_path
     execute 'e .'
     echo "Could not find" l:target_file
  endif
endfunction

function! s:IsDetached(worktree_path) abort
  let l:output = system('git -C ' . shellescape(a:worktree_path) . ' status --porcelain=v2 --branch | grep "^# branch.head"')
  return l:output =~# '\(detached\)'
endfunction

function! s:GetWorktreePath()
  let l:out = system('git rev-parse --git-common-dir')
  if v:shell_error
     echo out
     call input('Error.  Press <CR> to dismiss.')
     echoerr out
     return ""
  endif
  return substitute(out,'\n$','','') . '/../../worktrees/'
endfunction

function! PopulateWorktree(git_bin, branch, input)
   let l:cwd = fugitive#repo().tree()
   call feedkeys(':!' . a:git_bin . ' -C ' . l:cwd . ' worktree add ' . <sid>GetWorktreePath() . a:branch . ' ' . a:branch, "n")
endfunction

autocmd VimEnter * let g:fzf_branch_actions['create_new_worktree'] = {
         \ 'prompt': 'create new worktree> ',
         \ 'keymap': 'ctrl-w',
         \ 'execute': function('<sid>NewWorktree', ['notrack']),
         \ 'multiple': v:false,
         \ 'required': ['branch'],
         \ 'confirm': v:false
         \ }

autocmd VimEnter * let g:fzf_branch_actions['create_new_worktree_tracking'] = {
         \ 'prompt': 'create new worktree tracking> ',
         \ 'keymap': 'ctrl-t',
         \ 'execute': function('<sid>NewWorktree', ['track']),
         \ 'multiple': v:false,
         \ 'required': ['branch'],
         \ 'confirm': v:false
         \ }

autocmd VimEnter * let g:fzf_branch_actions['yank'] = {
         \ 'prompt': 'yank> ',
         \ 'keymap': 'ctrl-y',
         \ 'execute': 'eval map(["*",''"''], {key, val -> setreg(val, fnameescape("{branch}"))})',
         \ 'multiple': v:false,
         \ 'required': ['branch'],
         \ 'confirm': v:false
         \ }

autocmd VimEnter * let g:fzf_branch_actions['populate_:'] = {
         \ 'prompt': 'command> ',
         \ 'keymap': ':',
         \ 'execute': 'call feedkeys(": {branch}\<C-b>", "n")',
         \ 'multiple': v:false,
         \ 'required': ['branch'],
         \ 'confirm': v:false
         \ }

autocmd VimEnter * let g:fzf_branch_actions['populate_;'] = {
         \ 'prompt': 'command> ',
         \ 'keymap': ';',
         \ 'execute': function('PopulateWorktree'),
         \ 'multiple': v:false,
         \ 'required': ['branch'],
         \ 'confirm': v:false
         \ }

autocmd VimEnter * let g:fzf_branch_actions['reName'] = {
         \ 'prompt': 'rename> ',
         \ 'keymap': 'ctrl-n',
         \ 'execute': function('fzf_checkout#run', ['{git} -C {cwd} branch -m {input}']),
         \ 'multiple': v:false,
         \ 'required': ['input'],
         \ 'confirm': v:false
         \ }
