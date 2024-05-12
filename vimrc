filetype plugin indent on

let mapleader = "\ "

set spell
augroup markdownSpell
   autocmd FileType gitcommit setlocal spellcapcheck=
   autocmd FileType git setlocal nospell
augroup END

" Does not work as intended:
" augroup termLeave
"   au!
"   autocmd BufLeave * if &buftype ==# 'terminal' | call feedkeys("\<C-\>\<C-N>") | endif
" augroup END

" keep sorted
let $FZF_DEFAULT_OPTS='--bind ctrl-f:page-down,ctrl-b:page-up,ctrl-y:yank,ctrl-u:half-page-up+refresh-preview,ctrl-d:half-page-down+refresh-preview'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, " "))}}
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'
let g:netrw_winsize=25
let g:rooter_patterns = ['.git']
set autoindent
set autoread
set backspace=2
set fillchars+=vert:\ 
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:→\ ,trail:●,nbsp:⎵
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
call plug#end()

" au VimEnter * CompileDbPathIfExists compile_commands.json

function! SwitchToSecondDiffWindow()
    if &diff && winnr('#') > winnr()
        execute winnr('#') . 'wincmd w'
    endif
endfunction

function! Zoom()
    let l:cur_win = winnr()
    let l:cur_tab = tabpagenr()
    let l:num_wins = tabpagewinnr(l:cur_tab, '$')
    if l:num_wins == 1 || (&diff &&  l:num_wins == 2)
        tabprev
        +tabclose
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

nnoremap <leader>? :he gerard<CR>
nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <leader><leader> :update<CR>
nnoremap <leader>c :tabprev \| +tabclose<CR>
tnoremap <C-W><leader>c <C-W>:tabprev \| +tabclose<CR>
nnoremap gq :if tabpagewinnr(tabpagenr(), '$') > 1 \| close \| else \| tabprev \| +tabclose \| endif<CR>
tnoremap <C-W>gq <C-W>:if tabpagewinnr(tabpagenr(), '$') > 1 \| close \| else \| tabprev \| +tabclose \| endif<CR>
nnoremap dq :call SwitchToSecondDiffWindow() \| exe winnr('#') . 'wincmd c'<CR>
nnoremap <leader>z :call Zoom()<CR>
nnoremap <C-w><leader>z :call Zoom()<CR>
tnoremap <C-w><leader>z <C-w>:call Zoom()<CR>

nnoremap + <Cmd>Git<CR>
nnoremap \ <Cmd>vertical Git \| vertical resize 80<CR>
augroup FugitiveToggle
  autocmd!
  autocmd Filetype fugitive nnoremap <buffer> + :close \| wincmd p<CR>
  autocmd Filetype fugitive nnoremap <buffer> \ :close \| wincmd p<CR>
augroup END

" git log
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gb :BCommits<CR>
nnoremap <leader>gl :Gclog! -500<CR>
nnoremap <leader>gn :Gclog! -500 --name-only<CR>

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
nnoremap <leader>mF :cexpr system('git diff --name-only $(git merge-base master HEAD)') \| copen<CR>
nnoremap <leader>mf :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- <cfile>'<CR>
nnoremap <leader>md :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- %'<CR>
nnoremap <leader>mD :!git difftool -y $(git merge-base master HEAD)<CR>

" diff HEAD vs master merge-base
nnoremap <leader>pF :cexpr system('git diff --name-only master...') \| copen<CR>
nnoremap <leader>pf :G difftool -y master... -- <cfile><CR>
nnoremap <leader>pd :G difftool -y master... -- %<CR>
nnoremap <leader>pD :!git difftool -y $(git merge-base master HEAD)<CR>

" git staged vs HEAD
nnoremap <leader>sF :cexpr system('git diff --name-only --staged') \| copen<CR>
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

" Formatting selected code
xmap <leader>=  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)
xnoremap = :call Format()<CR>
nnoremap = :call Format()<CR>

function! Format()
  if CocAction('hasProvider', 'format')
    call CocAction('formatSelected')
  else
    execute 'normal! ='
  endif
endfunction

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
nmap <leader>cl  <Plug>(coc-codelens-action)

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

" implement :GGrep
" https://github.com/junegunn/fzf.vim#example-git-grep-wrapper
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)

if exists('$TMUX')
   " full screen:
   let g:fzf_layout = { 'tmux': '-p90%,60%' }

   " split below
   " let g:fzf_layout = { 'tmux': '-d30%' }
endif

let g:oscyank_term = 'default'
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif

function! g:Tapi_lcd(bufnum, path)
   let l:orig_bufnum=bufnr('%')
   if isdirectory(a:path)
      execute 'buffer' a:bufnum
      execute 'silent lcd ' . fnameescape(a:path)
      execute 'file !/bin/bash' getcwd() '(' . win_getid() . ')'
      execute 'buffer' l:orig_bufnum
   endif
endfunction

" C-PageDown does not map properly on mac iterm2
nnoremap <PageDown> <C-w>gt
nnoremap <PageUp> <C-w>gT

tnoremap <PageDown> <C-w>gt
tnoremap <PageUp> <C-w>gT

command! Worktrees :G -p worktree list
command! Merge G -p diff --name-only --diff-filter=U --relative
nnoremap <C-W><C-F> <C-W>vgf/====<CR>

function! MarkWin(reg)
   let l:reg = a:reg
   if l:reg ==# '"'
      let l:reg = input('Enter mark for tab [a-z]: ')
   endif
   exe 'let @' . l:reg '=":silent! call win_gotoid(' . win_getid() . ')\n"'
endfunction
command! MarkWin :call MarkWin("\"")
nnoremap <leader>t :call MarkWin(v:register)<CR>
tnoremap <C-w><leader>t <C-w>:call MarkWin(v:register)<CR>
tnoremap <C-w><C-@> <C-w>:@
tnoremap <C-w>@ <C-w>:@

augroup oldfiles
   au!
   " autocmd VimEnter * if !argc() | call timer_start(200, { -> execute('History') }) | endif
augroup END

