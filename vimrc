filetype plugin indent on

let mapleader = "\ "

set spell
augroup markdownSpell
   au!
   autocmd FileType gitcommit setlocal spellcapcheck=
   autocmd FileType git setlocal nospell
   autocmd Filetype man setlocal nolist
augroup END

" Does not work as intended:
" augroup termLeave
"   au!
"   autocmd BufLeave * if &buftype ==# 'terminal' | call feedkeys("\<C-\>\<C-N>") | endif
" augroup END

" keep sorted
let $FZF_DEFAULT_OPTS='--bind ctrl-f:page-down,ctrl-b:page-up,ctrl-y:yank,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_spell=0
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 45,
      \ 'x': 45,
      \ 'y': 45,
      \ 'z': 45,
      \ 'warning': 1000,
      \ 'error': 1000,
      \ }
let g:airline_section_y = '[%{$BUILD}] [%{$VIMCOMPILER}] [%{$TEST_FILENAME}]'
function! AirlineWinnr(...)
    call a:1.add_section_spaced('airline_a', '%{winnr()}')
endfunction
autocmd VimEnter * call airline#add_inactive_statusline_func('AirlineWinnr')
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines ->  map(['*','"'], "setreg(v:val, join(map(copy(lines), 'fnameescape(v:val)')))")}}
  " \ ':': {lines -> feedkeys(": " . join(map(copy(lines), 'fnameescape(v:val)')) . "\<C-b>", 'n')},
let g:coc_default_semantic_highlight_groups=1
let g:gitgutter_highlight_lines=1
let g:gitgutter_sign_added=' ▌' | " has unicode space
let g:gitgutter_sign_modified=' ▌' | " has unicode space
let g:gitgutter_sign_modified_removed='▁▌'
let g:gitgutter_sign_removed='▁▁'
let g:gitgutter_sign_removed_first_line='▔▔'
let g:gitgutter_sign_removed_above_and_below='▁▔'
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'
" let g:netrw_list_hide='^\.'
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_winsize=25
let g:netrw_altfile=1
let g:rooter_patterns = ['.git']
let g:termdebug_wide=1
" let g:termdebugger=
set autoindent
set autoread
set backspace=2
set diffopt+=vertical
set fillchars+=vert:\ 
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:→\ ,trail:●,nbsp:⎵,extends:❯,precedes:❮
set matchpairs+=<:>
set noswapfile
set number
set omnifunc=syntaxcomplete#Complete
set path+=**
set relativenumber
set scrolloff=8
set sidescroll=0
set sidescrolloff=8
set signcolumn=yes
set smartcase
set showbreak=↪\ 
set undofile
set undodir=~/.vim-undo
set updatetime=250
set viminfo^=!
set wildignore+=*.obj,tags,*.a
set wildignore+=**/node_modules/*
set wildignore+=**/build/*
set wildignorecase
set wildmenu
syntax on

" Install Plugin Manager (vim-plug)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" undo vim-vinegar hide wildignore from netrw
let my_netrw_list_hide = get(g:,'netrw_list_hide','')
autocmd VimEnter * let g:netrw_list_hide = my_netrw_list_hide

" Load plugins
" sort -t / -k2,2 -f
call plug#begin()
    Plug 'tpope/vim-abolish'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'PeterRincker/vim-argumentative'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'antoinemadec/coc-fzf'
    " use FZF :Commits instead of GV
    " Plug 'junegunn/gv.vim'
    Plug 'tomtom/tcomment_vim'
    " Plug 'martong/vim-compiledb-path'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-eunuch'
    Plug 'milch/vim-fastlane'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'stsewd/fzf-checkout.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'machakann/vim-highlightedyank'
    Plug 'ojroques/vim-oscyank'
    " load full vim-plug to get help file
    Plug 'junegunn/vim-plug'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-rhubarb'
    Plug 'airblade/vim-rooter'
    Plug 'lifepillar/vim-solarized8'
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-surround'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-vinegar'
    Plug 'Voltron369/markdown-headers.vim'
    " Plug 'vim-scripts/argtextobj.vim'
call plug#end()

runtime! plugged/coc.nvim/doc/coc-example-config.vim
nnoremap <silent> [G gg<Plug>(coc-diagnostic-next)
nnoremap <silent> ]G G<Plug>(coc-diagnostic-prev)
nnoremap <silent> gh :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent> gH :CocCommand clangd.switchSourceHeader vsplit<CR>
function! GotoDefinition()
  if CocAction('hasProvider', 'definition')
    call CocActionAsync('jumpDefinition')
  else
    execute 'normal! gd'
  endif
endfunction
nnoremap <silent> gd :call GotoDefinition()<CR>
nunmap <leader>cl| " interferes with <leader>c

" au VimEnter * CompileDbPathIfExists compile_commands.json

tnoremap <C-PageDown> <C-w>gt
tnoremap <C-PageUp> <C-w>gT

" I think this can be replaced with autocmd TabClosed * tabprev
function! CloseTab()
  " Get the current tab number and the total number of tabs
  let current_tab = tabpagenr()
  let total_tabs = tabpagenr('$')

  if current_tab > 1
    tabprev
    +tabclose
  elseif total_tabs > 1
    tabclose
  else
    echo "last window, use :q!"
  endif
endfunction

function! CloseWindow()
  if tabpagewinnr(tabpagenr(), '$') > 1
    close
  else
    call CloseTab()
  endif
endfunction

function! SwitchToSecondDiffWindow()
    if &diff && winnr('#') > winnr()
        execute winnr('#') . 'wincmd w'
    endif
endfunction

" To zoom manually, use Ctrl-W s Ctrl-W T
function! Zoom()
    let l:cur_tab = tabpagenr()
    let l:num_wins = tabpagewinnr(l:cur_tab, '$')
    if l:num_wins == 1 || (&diff &&  l:num_wins == 2)
        call CloseTab()
    else
       if &diff
          call SwitchToSecondDiffWindow()
          let l:other_win = winnr('#')
          let l:other_buf = bufname(winbufnr(l:other_win))
          execute l:other_win . 'wincmd c'
          tab split
          execute 'vertical diffsplit' l:other_buf
          wincmd w
      else
          tab split
       endif
    endif
endfunction

nnoremap <leader>? :vert he gerard \| vertical resize 90<CR>
nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <leader><leader> :update \| call fugitive#ReloadStatus()<CR>
nnoremap <leader>c :call CloseTab()<CR>
nnoremap <leader>s :AbortDispatch<CR>
nnoremap <leader>S :AbortDispatchAll<CR>
tnoremap <C-W><leader>c <C-W>:call CloseTab()<CR>
nnoremap gq :call CloseWindow()<CR>
tnoremap <C-W>gq <C-W>:call CloseWindow()<CR>
nnoremap <leader>qq <Cmd>tabclose<CR>
" nnoremap dq :call SwitchToSecondDiffWindow() \| exe winnr('#') . 'wincmd c'<CR>
nnoremap <leader>z :call Zoom()<CR>
nnoremap <C-w><leader>z :call Zoom()<CR>
tnoremap <C-w><leader>z <C-w>:call Zoom()<CR>

cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>

augroup FugitiveToggle
  autocmd!
  autocmd Filetype fugitive nnoremap <buffer> + :close \| wincmd p<CR>
  autocmd Filetype fugitive nnoremap <buffer> \ :e #<CR>
augroup END

function! CloseDiff()
  if &buftype ==# 'nofile'
    call CloseWindow()
  else
    call fugitive#DiffClose()
  endif
endfunction

function! MyDVMap(cmd)
   " do a three way diff
   " for head or merge head, diff vs merge base
   let l:side = matchstr(expand("%"), '//\zs[23]\ze/')
   if l:side !=# ''
      execute a:cmd ':1'
      if l:side ==# '3'
         wincmd x
      else
         wincmd p
      endif
   else
      execute a:cmd
   endif
endfunction


augroup AutoCloseLocList
   autocmd!
   autocmd WinClosed * call s:AutoCloseLocList()
augroup END

function! s:AutoCloseLocList()
    let winid = str2nr(expand('<amatch>'))
    let wininfo = getwininfo(winid)

    " Close location list unless it was the quickfix window (not loclist)
    if empty(wininfo) || !get(wininfo[0], 'quickfix', 0) || get(wininfo[0], 'loclist', 0)
        lclose
    endif
endfunction

augroup FugitiveAutoCloseBlame
  autocmd!
  autocmd BufWinLeave * if &scrollbind && &filetype != 'fugitiveblame'
    \ | let s:left_win = winnr() - 1
    \ | if s:left_win > 0 && getwinvar(s:left_win, '&filetype') ==# 'fugitiveblame'
    \      && getwinvar(s:left_win, '&scrollbind')
    \ |   execute s:left_win . 'close'
    \ | endif
    \ | endif
augroup END

" Open fugitive summary in current window and jump to the current file in Unstaged (or staged), closing diff
function! s:jump_to_git_status() abort
   if empty(FugitiveGitDir())
      echo "Not a git repository"
      return
   endif

   if &diff
      call fugitive#DiffClose()
   endif

   Gedit! :

   normal gsgU

   call search('\s\+\V' . escape(fnamemodify(FugitiveReal(expand("#")), ":p:."), '\') . '\m$')

   normal! zz
endfunction

" git maps
nnoremap + <Cmd>vertical Git \| vertical resize 80<CR>
nnoremap dh :call MyDVMap('Ghdiffsplit!')<CR>
nnoremap dH :call MyDVMap('Ghdiffsplit')<CR>
nnoremap dq :call CloseDiff()<CR>
nnoremap dQ :call CloseDiff() \| if get(b:, 'fugitive_type', '') == 'blob' \| Gedit \| endif<CR>
nnoremap ds :call MyDVMap('Ghdiffsplit!')<CR>
nnoremap dS :call MyDVMap('Ghdiffsplit')<CR>
nnoremap dv :call MyDVMap('Gvdiffsplit!')<CR>
nnoremap dV :call MyDVMap('Gvdiffsplit')<CR>
" nnoremap dh :if &diff<bar>execute 'normal d2o'<bar>else<bar>execute 'normal xh'<bar>endif<CR>
" nnoremap dl :if &diff<bar>execute 'normal d3o'<bar>else<bar>execute 'normal x'<bar>endif<CR>
" open git blame, or close it if inside blame window
nnoremap gb :if &filetype==#'fugitiveblame'<bar>execute 'normal gq'<bar>else<bar>execute 'G blame'<bar>endif<CR>
nnoremap gQ :<C-U>Gedit<CR>
nnoremap \ :call <SID>jump_to_git_status()<CR>
nnoremap <leader>\ :GFiles?<CR>
nnoremap gw :Gwrite<CR>
nnoremap gW :Gwrite!<Bar>tabclose<CR>

" Range-aware Glog function for normal and visual mode.
function! s:RunGlogRelevantSide(forceFromStart) range
  let l:fname = expand('%')
  let l:side = matchstr(l:fname, '//\zs[23]\ze/')
  let l:target = l:side ==# '2' ? 'HEAD'
        \ : l:side ==# '3' ? 'MERGE_HEAD'
        \ : ''
  let l:range_prefix = a:forceFromStart ? ':0' : printf(":%d,%d", a:firstline, a:lastline)

  if l:target ==# ''
    execute l:range_prefix . 'Gllog! -500'
  else
    " for HEAD or MERGE_HEAD show commits to MERGE_BASE

    " Get merge base SHA
    let l:mb = trim(system('git merge-base MERGE_HEAD HEAD'))
    let l:winid = win_getid()

    " Get ancestry path location list
    execute l:range_prefix . 'Gllog! ' . l:mb . '..' . l:target '--ancestry-path'
    let l:loc_items_range = getloclist(l:winid)

    " MERGE_BASE entry
    execute l:range_prefix . 'Gllog! -1 ' . l:mb
    let l:loc_items_base = getloclist(l:winid)
    let l:loc_items_base[0]['text'] = '( MERGE_BASE )'

    " get top entry for HEAD or MERGE_HEAD
    let l:top = [{'lnum': a:forceFromStart ? '' : a:firstline, 'bufnr': bufnr('%'), 'end_lnum': 0, 'pattern': '', 'valid': 1, 'vcol': 0, 'nr': 0, 'module': '/' . l:side . ':' .  fnamemodify(FugitiveReal(expand("%")), ":p:."), 'type': '', 'end_col': 0, 'col': 0, 'text': '( ' . l:target . ' )'}]

    " Concat (ancestry commits first, then merge base)
    let l:new_loc = l:top + l:loc_items_range + l:loc_items_base

    " Update location list
    call setloclist(l:winid, l:new_loc, 'r')
  endif
endfunction

nnoremap gl :Gclog! -500<CR>
xnoremap gl :call <SID>RunGlogRelevantSide(0)<CR>
nnoremap gL :call <SID>RunGlogRelevantSide(1)<CR>
xnoremap gL :call <SID>RunGlogRelevantSide(0)<CR>
nnoremap <leader>gl :Gclog! -500<CR>
xnoremap <leader>gl :call <SID>RunGlogRelevantSide(0)<CR>
nnoremap <leader>gL :call <SID>RunGlogRelevantSide(1)<CR>
xnoremap <leader>gL :call <SID>RunGlogRelevantSide(0)<CR>

" git log
nnoremap <leader>gc :Commits<CR>
xnoremap <leader>gc :BCommits<CR>
nnoremap <leader>gC :BCommits<CR>
inoremap <leader>gC :BCommits<CR>
xnoremap <leader>gC :BCommits<CR>
nnoremap <leader>gb :GBranches<CR>
nnoremap <leader>gw :GWorktree<CR>
nnoremap <leader>gn :Gclog! -500 --name-only<CR>
nnoremap <leader>gp :Gclog! -500 --patch<CR>
nnoremap <leader>gB :GBrowse<CR>

function! LocListMap(cmd)
   let l:isdiff = &diff
   try
      " split then close so the other diff window will stay in diff mode (if there is only one)
      wincmd s
      wincmd p
      if v:count
         execute v:count . a:cmd
      else
         execute a:cmd
      endif
   catch /.*/
      echo v:exception
   endtry
   if l:isdiff
      diffthis
   endif
   wincmd p
   wincmd c
endfunction

nnoremap [L <Cmd>call LocListMap('lfirst')<CR>
nnoremap [l <Cmd>call LocListMap('lprev')<CR>
nnoremap ]l <Cmd>call LocListMap('lnext')<CR>
nnoremap ]L <Cmd>call LocListMap('llast')<CR>

" fzf
nnoremap <leader>ag :Ag<CR>
tnoremap <C-w><leader>ag <C-w>:Ag<CR>
nnoremap <leader>rg :Rg<CR>
tnoremap <C-w><leader>rg <C-w>:Rg<CR>
nnoremap <leader>b :Buffers<CR>
tnoremap <C-w><leader>b <C-w>:Buffers<CR>
nnoremap <leader>f :GFiles<CR>
tnoremap <C-w><leader>f <C-w>:GFiles<CR> | "requires fix to :GFiles command after let dir = : if &buftype ==# 'terminal' | let dir = getcwd() | endif
nnoremap <leader>F :Files<CR>
tnoremap <C-w><leader>F <C-w>:Files<CR> | "requires fix to :GFiles command after let dir = : if &buftype ==# 'terminal' | let dir = getcwd() | endif
nnoremap <leader>gg :GGrep<CR>
tnoremap <C-w><leader>gg <C-w>:GGrep<CR>
nnoremap <C-_> :BLines<CR> | "actually Ctrl-/
tnoremap <C-w><C-_> <C-w>:BLines<CR> | "actually Ctrl-/
nnoremap q: :History:<CR>
nnoremap q/ :History/<CR>
nnoremap q? :Helptags<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

function! s:CoutToQF(cout)
   call setqflist([], ' ', {'items': map(split(a:cout,'\n'), '{"filename": v:val, "lnum": 0, "col": 0}')})
endfunction

" log HEAD vs master merge-base
nnoremap <leader>ml :Gclog! -500 master..<CR>
nnoremap <leader>mn :Gclog! -500 --name-only master..<CR>
nnoremap <leader>ms :Gclog! -500 --name-status master..<CR>

" diff working vs HEAD
nnoremap <leader>gF :G<CR>
nnoremap <leader>gf :G difftool -y HEAD -- <cfile><CR>
nnoremap <leader>gd :G difftool -y HEAD -- %<CR>
nnoremap <leader>gD :!git difftool -y HEAD<CR>

" diff working vs master merge-base
nnoremap <leader>mF :call <sid>CoutToQF(system('git diff --name-only $(git merge-base master HEAD)')) \| copen<CR>
nnoremap <leader>mf :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- <cfile>'<CR>
nnoremap <leader>md :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- %'<CR>
nnoremap <leader>mD :!git difftool -y $(git merge-base master HEAD)<CR>

" diff HEAD vs master merge-base
nnoremap <leader>pF :call <sid>CoutToQF(system('git diff --name-only master...')) \| copen<CR>
nnoremap <leader>pf :G difftool -y master... -- <cfile><CR>
nnoremap <leader>pd :G difftool -y master... -- %<CR>
nnoremap <leader>pD :!git difftool -y $(git merge-base master HEAD)<CR>

" git staged vs HEAD
nnoremap <leader>sF :call <sid>CoutToQF(system('git diff --name-only --staged')) \| copen<CR>
nnoremap <leader>sf :G difftool -y --staged HEAD -- <cfile><CR>
nnoremap <leader>sd :G difftool -y --staged HEAD -- %<CR>
nnoremap <leader>sD :!git difftool -y --staged<CR>

augroup mergediffs
   au!
   autocmd VimEnter * if exists("$GIT_PREFIX") | let @/ = '====' | exec "normal /\<CR>" | endif
augroup END

" From vim-sensible:

" Use CTRL-L to clear the highlighting of 'hlsearch' (off by default) and call
" :diffupdate
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Delete comment character when joining commented lines.
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" From `:help :DiffOrig`.
if exists(":DiffOrig") != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
        \ | diffthis | wincmd p | diffthis
endif
nnoremap <leader>df :GitGutterFold<CR>

function! DiffObtainOrDiff(count)
  if &diff
    try
      let l:count_str = a:count ? a:count : ""
      execute "normal! " . l:count_str . "do"
    catch /E101/
      " E101: More than two buffers in diff mode, don't know which one to use
       call feedkeys(":diffget \<Tab>\<Tab>", 't')
    endtry
  else
    if empty(FugitiveGitDir())
       DiffOrig
    else
       call MyDVMap('Gdiffsplit!')
    endif
  endif
endfunction

function! DiffPutOrSplit(count)
  if &diff
    let l:count_str = a:count ? a:count : ""
    execute "normal! " . l:count_str . "dp"
  else
    diffsplit #
    wincmd x
    wincmd p
  endif
endfunction

nnoremap <silent> do :<C-U>call DiffObtainOrDiff(v:count)<CR>
nnoremap <silent> dp :<C-U>call DiffPutOrSplit(v:count)<CR>
nnoremap <silent> dP :<C-U>diffsplit #<bar>wincmd x<bar>wincmd p<CR>

" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Recover from accidental Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" custom text-object
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

helptags ~/.vim/doc

colorscheme gerard


if executable('rg')
    " Note we extract the column as well as the file and line number
    set grepprg=rg\ --vimgrep\ $*
    set grepformat^=%f:%l:%c:%m,%f
    " %f supports "grep -l" which lists just the names of the files with matches
elseif executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --vimgrep\ $*
    set grepformat^=%f:%l:%c:%m,%f
    " %f supports "grep -l" which lists just the names of the files with matches
endif

" automatically open quickfix or location list
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" implement :GGrep
" https://github.com/junegunn/fzf.vim#example-git-grep-wrapper
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)

if exists('$TMUX')
   let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

   " full screen:
   " let g:fzf_layout = { 'tmux': '-p90%,60%' }

   " split below
   " let g:fzf_layout = { 'tmux': '-d30%' }
endif

command! AbortDispatchAll exe ':!tmux kill-pane -a -t $TMUX_PANE'

augroup terminal_settings
   autocmd!
   autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no nolist
   autocmd BufEnter * if &buftype ==# 'terminal' | setlocal nonumber norelativenumber signcolumn=no nolist
augroup END

let g:oscyank_term = 'default'
augroup oscyank
au!
   autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
augroup END

function! g:Tapi_lcd(bufnum, path)
   let l:orig_bufnum=bufnr('%')
   if isdirectory(a:path)
      execute 'buffer' a:bufnum
      execute 'silent lcd ' . fnameescape(a:path)
      execute 'file !/bin/bash' getcwd() '(' . win_getid() . ')'
      execute 'buffer' l:orig_bufnum
   endif
endfunction

function! g:Tapi_gdb(_, files)
   packadd termdebug
   let cwd = getcwd()
   let bin = a:files[0]
   echo bin
   let args = join(a:files[1:], ' ')
   if !exists(':Gdb')
      exec 'tabnew | silent! Termdebug'
   endif
   exe 'Gdb'
   call term_sendkeys(bufndr('%'), 'set args' . args . '')
   call term_sendkeys(bufndr('%'), 'cd ' . cwd . '')
   call term_sendkeys(bufndr('%'), 'set confirm off')
   call term_sendkeys(bufndr('%'), 'file ' . bin . '')
   call term_sendkeys(bufndr('%'), 'set confitm on')
endfunction

function! g:Tapi_vimdiff(_, files)
   execute ':!vimdiff ' . join(map(a:files, 'v:val[0:0]==#"-"?v:val:shellescape(v:val)'),' ')
endfunction

" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if !exists('g:COMPILER_MAP')
   let g:COMPILER_MAP={}
   let g:BUILD_MAP={}
   let g:TESTFILE_MAP={}
endif

function! GitGetRepoName() abort
   if exists('*FugitiveRemoteUrl')
      let s:git_url = FugitiveRemoteUrl()
      return matchstr(s:git_url, '/\([^/]*\).git$')[1:-5] . ' '
   endif
endfunction

let g:compiler_defaults = {}
" let g:compiler_defaults['target ']='target'
function! MyRooter()
   if !exists('*GitGetRepoName')
      return
   endif

   execute 'Rooter'

   if has_key(g:BUILD_MAP, getcwd())
      let $BUILD=g:BUILD_MAP[getcwd()]
   elseif has_key(g:compiler_defaults, GitGetRepoName())
      let $BUILD='debug'
      let g:BUILD_MAP[getcwd()]=$BUILD
   else
      let $BUILD=''
   endif

   if has_key(g:TESTFILE_MAP, getcwd())
      let l:test_file=g:TESTFILE_MAP[getcwd()]
   else
      let l:test_file=''
   endif

   if has_key(g:COMPILER_MAP, getcwd()) && !empty(g:COMPILER_MAP[getcwd()])
      for item in split(g:COMPILER_MAP[getcwd()])
         execute 'compiler '.item
      endfor
   elseif has_key(g:compiler_defaults, getcwd()) && !empty(g:compiler_defaults[getcwd()])
         execute 'compiler '.g:compiler_defaults[getcwd()]
   else
      execute 'compiler none'
   endif

   let $TEST_FILENAME=l:test_file
   if has_key(g:TESTFILE_MAP, getcwd())
      let g:TESTFILE_MAP[getcwd()]=l:test_file
   endif
endfunction

augroup ale
   au!
   autocmd VimEnter,BufReadPost,BufEnter * nested call MyRooter()
   autocmd BufWritePost * nested call MyRooter()
augroup END

function! BuildChanged()
   let g:BUILD_MAP[getcwd()]=$BUILD
endfunction

function! CompilerChanged()
   let g:COMPILER_MAP[getcwd()]=$VIMCOMPILER
   let g:TESTFILE_MAP[getcwd()]=''
   let $TEST_FILENAME=''
   if !has_key(g:BUILD_MAP, getcwd())
      let $BUILD='debug'
      let g:BUILD_MAP[getcwd()]=$BUILD
   endif
endfunction

function! SetTestfile(testfile)
   call CompilerChanged()
   let $TEST_FILENAME=a:testfile
   let g:TESTFILE_MAP[getcwd()=a:testfile
endfunction


command! Worktrees :G -p worktree list
command! Merge G -p diff --name-only --diff-filter=U --relative
nnoremap <C-W><C-F> <C-W>vgf/====<CR>

augroup oldfiles
   au!
   " autocmd VimEnter * if !argc() | call timer_start(200, { -> execute('History') }) | endif
augroup END
command! -nargs=0 Oldfiles History

augroup my_airline_plugins
   au!
   autocmd VimEnter * runtime! my_airline_plugins/airline/**/*.vim
augroup END

