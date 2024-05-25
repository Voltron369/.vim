
function! NumberArgs()
    if !argc() | return | endif
    let old_args = argv()
    execute '%argdel | 0argadd' join(map(argv(), {idx, val -> fnameescape(printf("%2d: %s", idx + 1, val))}),' ')
    echo execute('args')
    execute '%argdel | 0argadd' join(map(old_args, {_, val -> fnameescape(val)}),' ')
    let choice = str2nr(input('Enter argument number (or 0 to exit): '))
    if !choice | return | endif
    execute 'argument' choice
endfunction

command! Args call NumberArgs()
