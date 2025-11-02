" Enable wildmenu for bash completion
set wildmenu

" Map <Tab> for bash/vim completion
cnoremap <expr> <Tab> <SID>completion(getcmdline())

function! s:completion(cmdline)
    " Check if the current command starts with "!"
    if a:cmdline[:0] ==# '!'
        " Use compgen to generate bash completion
        let completions = system('compgen -c -f -o bashdefault -- "' . a:cmdline[1:] . '"')
        " If there are completions, update the wildmenu
        if !empty(completions)
           return completions
            return "\<C-R>=wildmenumode()\<CR>\<C-R>=" . completions . "\<CR>"
        endif
    else
        " Use default Vim completion
        return "\<C-X>\<C-V>"
    endif
    " If no completions, return an empty string
    return ''
endfunction
