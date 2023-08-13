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

" let g:ale_command_wrapper = '~/.vim/ale_command_wrapper'

" keep sorted
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:ale_completion_enabled=1
let g:ale_cpp_cc_executable='/usr/local/bin/g++-9'
let g:ale_cpp_clangd_executable = '/usr/local/opt/llvm/bin/clangd'
let g:ale_linters = {'rust': ['analyzer']}
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
    Plug 'dense-analysis/ale'
    Plug 'junegunn/gv.vim'
    Plug 'tomtom/tcomment_vim'
    Plug 'martong/vim-compiledb-path'
    Plug 'tpope/vim-dispatch'
    Plug 'milch/vim-fastlane'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'machakann/vim-highlightedyank'
    Plug 'ojroques/vim-oscyank'
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

nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <leader>c :tabprev \| +tabclose<CR>
nnoremap gq :if tabpagewinnr(tabpagenr(), '$') > 1 \| close \| else \| tabprev \| +tabclose \| endif<CR>

" git log
nnoremap <leader>gl :Gclog! -500<CR>
nnoremap <leader>gn :Gclog! -500 --name-only<CR>

" git find
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :GFiles<CR>
nnoremap <leader>gg :GGrep<CR>
nnoremap <C-_> :BLines<CR> | "actually Ctrl-/

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
nnoremap <leader>sf :G difftool -y --staged HEAD -- <cfile><CR>
nnoremap <leader>sd :G difftool -y --staged HEAD -- %<CR>
nnoremap <leader>sD :!git difftool -y --staged<CR>

" git commit vs commit
nnoremap <leader>gb :let gitbase=substitute(substitute(getline("."), "commit ",  "", ""), "\|.*", "", "g")<CR>
nnoremap <leader>ge :let gitend=substitute(substitute(getline("."), "commit ",  "", ""), "\|.*", "", "g")<CR>
nnoremap <leader>gc :exe 'G difftool -y ' gitbase gitend '-- <cfile>'<CR>
nnoremap <leader>gC :exe '!git difftool -y ' gitbase gitend<CR>
let gitbase=''
let gitend=''

" checked in vs merge head (i.e., pr)
" nnoremap <leader>mD :!git difftool -y master...


nmap <leader>ad <Plug>(ale_go_to_definition)
nmap <leader>ai <Plug>(ale_go_to_implementation)
nmap <leader>aq :ALEPopulateQuickfix \| copen<CR>
nmap <leader>ah <Plug>(ale_hover)
nmap <leader>an <Plug>(ale_next_wrap)
nmap <leader>ap <Plug>(ale_previous_wrap)
nmap <leader>af <Plug>(ale_find_references)
nmap <leader>ar :ALEFindReferences -quickfix \| copen<CR>
nmap <leader>at <Plug>(ale_go_to_type_definition)
nmap [R <Plug>(ale_first)
nmap [r <Plug>(ale_previous_wrap)
nmap ]r <Plug>(ale_next_wrap)
nmap ]R <Plug>(ale_last)

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

helptags ~/.vim/doc

colorscheme gerard

" implement :GFind {pattern}
" https://vi.stackexchange.com/a/2589
command! -nargs=1 -bang -complete=customlist,GitFindComplete
      \ Gfind find<bang> <args>
function! GitFindComplete(ArgLead, CmdLine, CursorPos)
   let search_pattern = a:ArgLead
   let shell_cmd = "git ls-files |  ~/.vim/plugged/fzf/bin/fzf --filter " . shellescape(search_pattern)
   return split(system(shell_cmd), "\n")
endfunction

" implement :GGrep
" https://github.com/junegunn/fzf.vim#example-git-grep-wrapper
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)

if exists('$TMUX')
   " full screen:
   " let g:fzf_layout = { 'tmux': '-p90%,60%' }

   " split below
   let g:fzf_layout = { 'tmux': '-d30%' }
endif

let g:oscyank_term = 'default'
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif

def g:Tapi_lcd(_, path: string)
   if isdirectory(path)
      execute 'silent lcd ' .. fnameescape(path)
   endif
enddef

" C-PageDown does not map properly on mac iterm2
nnoremap <PageDown> <C-w>gt
nnoremap <PageUp> <C-w>gT
nnoremap <silent><C-Down> <C-w>j
nnoremap <silent><C-Up> <C-w>k
nnoremap <silent><C-Left> <C-w>h
nnoremap <silent><C-Right> <C-w>l

tnoremap <PageDown> <C-w>gt
tnoremap <PageUp> <C-w>gT

""let g:ale_cpp_ccls_init_options={'clang': {'extraArgs': ['-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1']}}
