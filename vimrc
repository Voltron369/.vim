filetype plugin indent on

" keep sorted
let g:ale_completion_enabled=1
let g:ale_cpp_cc_executable='/usr/local/bin/g++-9'
let g:netrw_winsize=25
let g:rooter_patterns = ['.git']
set autoindent
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
set smartcase
set showbreak=↪\ 
set updatetime=250
set wildignore+=**/node_modules,**/build,*.obj,tags,*.a
set wildmenu
syntax on

" Install Plugin Manager (vim-plug)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load plugins
" sort -t / -k2,2 -f
call plug#begin()
    Plug 'dense-analysis/ale'
    Plug 'junegunn/gv.vim'
    Plug 'vim-scripts/ReplaceWithRegister'
    Plug 'tpope/vim-commentary'
    Plug 'martong/vim-compiledb-path'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'machakann/vim-highlightedyank'
    Plug 'tpope/vim-rhubarb'
    Plug 'airblade/vim-rooter'
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-vinegar'
call plug#end()

au VimEnter * CompileDbPathIfExists compile_commands.json

nnoremap <leader>c :tabprev \| +tabclose<CR>

" git log
nnoremap <leader>gl :Gclog! -500<CR>

" git staged vs HEAD
nnoremap <leader>gc :!git difftool -y --staged<CR>

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

" checked in vs merge head (i.e., pr)
" nnoremap <leader>mD :!git difftool -y master...


nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ai :ALEGoToImplementation<CR>
nnoremap <leader>aq :ALEPopulateQuickfix<CR>
nnoremap <leader>ah :ALEHover<CR>
nnoremap <leader>an :ALENextWrap<CR>
nnoremap <leader>ap :ALEPreviousWrap<CR>
nnoremap <leader>ar :ALEFindReferences<CR>

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

helptags ~/.vim/doc

""let g:ale_cpp_ccls_init_options={'clang': {'extraArgs': ['-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1']}}
