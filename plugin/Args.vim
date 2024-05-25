
function! NumberArgs()
    if argc() == 0
       return
    endif
    " count cols and account for numbers so it won't wrap
    let split_args = split(execute('args'),'\n')
    let cols = len(split(split_args[0]))*4
    let chars = cols*4
    let &columns -= chars
    " do not split, use the whitespace provided by vim to preserve columns
    let arglist = execute('args')
    let split_args = split(arglist,'\n')
    let length = len(split_args)
    let &columns += chars
    " remove leading newline
    let arglist = substitute(arglist, '\n', '', '')
    " remove trailing whitespace from each line
    let arglist = substitute(arglist, '\s\+\n', '\n', 'g')
    let numbered_arglist = ''
    let i = 1
    let j = 0
    while arglist != ''
       let n = i + j * length
        let item_end = match(arglist, '\(\s\+\|\n\+\)\zs\S')
        if item_end == -1
            let numbered_arglist .= printf("%2d", n) . ': ' . arglist
            let arglist = ''
        else
            let numbered_arglist .= printf("%2d", n) . ': ' . strpart(arglist, 0, item_end)
            if match(strpart(arglist, 0, item_end),'\n') == -1
               let j += 1
            else
               let i += 1
               let j = 0
            endif
            let arglist = strpart(arglist, item_end)
        endif
    endwhile

    echo numbered_arglist

    let choice = input('Enter argument number (or 0 to exit): ')
    if choice =~ '^\d\+$'
        let choice = str2nr(choice)
        if choice > 0
            execute 'argument' choice
       endif
    endif
endfunction

command! Args call NumberArgs()
