filetype plugin indent on

let mapleader = "\ "

set spell
augroup markdownSpell
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
let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_modified_removed='┻'
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
set listchars=tab:→\ ,trail:●,nbsp:⎵
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
    " Plug 'vim-scripts/argtextobj.vim'
call plug#end()

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
nnoremap <leader>qq :call CloseWindow()<CR>
nnoremap <C-W><leader>qq <C-W>:call CloseWindow()<CR>
" nnoremap dq :call SwitchToSecondDiffWindow() \| exe winnr('#') . 'wincmd c'<CR>
nnoremap dq :call fugitive#DiffClose()<CR>
nnoremap <leader>z :call Zoom()<CR>
nnoremap <C-w><leader>z :call Zoom()<CR>
tnoremap <C-w><leader>z <C-w>:call Zoom()<CR>

cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>

nnoremap + <Cmd>Git<CR>
nnoremap \ <Cmd>vertical Git \| vertical resize 80<CR>
augroup FugitiveToggle
  autocmd!
  autocmd Filetype fugitive nnoremap <buffer> + :close \| wincmd p<CR>
  autocmd Filetype fugitive nnoremap <buffer> \ :close \| wincmd p<CR>
augroup END

" git log
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gC :BCommits<CR>
inoremap <leader>gC :BCommits<CR>
xnoremap <leader>gC :BCommits<CR>
nnoremap <leader>gb :GBranches<CR>
nnoremap <leader>gw :GWorktree<CR>
nnoremap <leader>gl :Gclog! -500<CR>
xnoremap <leader>gl :Gclog! -500<CR>
nnoremap <leader>gL :Gclog! -500 -- %<CR>
xnoremap <leader>gL :Gclog! -500<CR>
nnoremap <leader>gn :Gclog! -500 --name-only<CR>
nnoremap <leader>gB :GBrowse<CR>

" fzf
nnoremap <leader>ag :Ag<CR>
tnoremap <C-w><leader>ag <C-w>:Ag<CR>
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

" COC

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nnoremap <silent> [G gg<Plug>(coc-diagnostic-next)
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> ]G G<Plug>(coc-diagnostic-prev)

" GoTo code navigation
nnoremap <silent> gd :call GotoDefinition()<CR>
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gh :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent> gH :CocCommand clangd.switchSourceHeader vsplit<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! GotoDefinition()
  if CocAction('hasProvider', 'definition')
    call CocActionAsync('jumpDefinition')
  else
    execute 'normal! gd'
  endif
endfunction

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
" interferes with <leader>c
" nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

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
nnoremap <leader>do :GitGutterDiffOrig<CR>
nnoremap <leader>dd :GitGutterDiffOrig<CR>
nnoremap <leader>df :GitGutterFold<CR>
nnoremap <leader>dp :Gdiffsplit !~1<CR>

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


if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

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
   execute ':!vimdiff ' . join(map(a:files, 'shellescape(v:val)'),' ')
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
command! -nargs=0 OldFiles History
command! -nargs=0 Oldfiles History

augroup my_airline_plugins
   au!
   autocmd VimEnter * runtime! my_airline_plugins/airline/**/*.vim
augroup END
