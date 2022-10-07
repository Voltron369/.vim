syntax on
filetype plugin indent on
set hidden
set history=1000
set path+=**
let g:netrw_winsize=25
set autoindent
set incsearch
set list
set listchars=tab:→\ ,trail:●,nbsp:⎵
set showbreak=↪\ 
set nohlsearch
set wildignore+=**/node_modules,**/build,*.obj,tags,*.a
set wildmenu
set updatetime=250
set scrolloff=8
set noswapfile
set number
set relativenumber
:set laststatus=2
let g:ale_cpp_cc_executable='/usr/local/bin/g++-9'
set omnifunc=syntaxcomplete#Complete
let g:ale_completion_enabled=1
let g:rooter_patterns = ['.git']

" Install Plugin Manager (vim-plug)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load plugins
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'machakann/vim-highlightedyank'
Plug 'martong/vim-compiledb-path'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-rooter'
call plug#end()

au VimEnter * CompileDbPathIfExists compile_commands.json

noremap <leader>c :tabprev \| +tabclose<CR>

" git log
noremap <leader>gl :Gclog! -500<CR>

" git staged vs HEAD
noremap <leader>gc :!git difftool -y --staged<CR>

" log HEAD vs master merge-base
noremap <leader>ml :Gclog! -500 master..<CR>
noremap <leader>mn :Gclog! -500 --name-only master..<CR>
noremap <leader>ms :Gclog! -500 --name-status master..<CR>

" diff working vs HEAD
noremap <leader>gF :G<CR>
noremap <leader>gf :G difftool -y HEAD -- <cfile><CR>
noremap <leader>gd :G difftool -y HEAD -- %<CR>
noremap <leader>gD :!git difftool -y HEAD<CR>

" diff working vs master merge-base
noremap <leader>mF :cexpr system('git diff --name-only $(git merge-base master HEAD)') \| copen<CR>
noremap <leader>mf :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- <cfile>'<CR>
noremap <leader>md :exe 'G difftool -y' trim(system('git merge-base master HEAD')) '-- %'<CR>
noremap <leader>mD :!git difftool -y $(git merge-base master HEAD)<CR>

" diff HEAD vs master merge-base
noremap <leader>pF :cexpr system('git diff --name-only master...') \| copen<CR>
noremap <leader>pf :G difftool -y master... -- <cfile><CR>
noremap <leader>pd :G difftool -y master... -- %<CR>
noremap <leader>pD :!git difftool -y $(git merge-base master HEAD)<CR>

" checked in vs merge head (i.e., pr)
" noremap <leader>mD :!git difftool -y master...


noremap <leader>ad :ALEGoToDefinition<CR>
noremap <leader>ai :ALEGoToImplementation<CR>
noremap <leader>aq :ALEPopulateQuickfix<CR>
noremap <leader>ah :ALEHover<CR>
noremap <leader>an :ALENextWrap<CR>
noremap <leader>ap :ALEPreviousWrap<CR>


""let g:ale_cpp_ccls_init_options={'clang': {'extraArgs': ['-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1']}}
