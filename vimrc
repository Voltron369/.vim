syntax on
set hidden
set history=1000
set path+=**
let g:netrw_winsize=25
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set incsearch
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
Plug 'airblade/vim-rooter'
call plug#end()

au VimEnter * CompileDbPathIfExists compile_commands.json

command! -nargs=1 C compiler <args> | Make




""let g:ale_cpp_ccls_init_options={'clang': {'extraArgs': ['-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1']}}
