
" Function to toggle JSON formatting for the current line
function! ToggleJsonFormat()
    set filetype=json
    " Get the current line number
    let l:current_line = line('.')

    " Get the current line text
    let l:current_line_text = getline(l:current_line)

    " Check if the line is empty
    if l:current_line_text ==# ''
        echo 'Current line is empty'
        return
    endif

    " Check if the line is already formatted as JSON
        " Toggle between pretty-printed and compact JSON
       if l:current_line_text =~# '^\s*{.*}$'
            " Pretty-print JSON
             execute '.!' . 'python3 -m json.tool --indent 3'
        else
            " Compact JSON
            let l:start_line = search('^{', 'bcnW')
            let l:end_line = search('^}', 'nW')
            if l:start_line && l:end_line
                execute l:start_line . ',' . l:end_line . '!' . 'python3 -m json.tool --compact'
            else
                echo 'Current line is not valid JSON'
            endif
        endif
endfunction

" Map the toggle function to a key combination
nnoremap <leader>jt :call ToggleJsonFormat()<CR>
autocmd FileType json nmap <buffer> S :call ToggleJsonFormat()<CR>



function! PreviewJqCmd()
    set filetype=json
    let l:current_line = getline('.')
    let l:jq_result = system('echo ' . shellescape(l:current_line) . ' | python3 -m json.tool --indent 3')

    if !empty(l:jq_result)
        " Open a preview window on the left
        pclose
        vertical pedit PreviewJqCmd

        " Switch to the preview window
        wincmd P
        setlocal previewwindow
        vertical resize 50

        " Set the contents of the preview window to the jq result
        setlocal modifiable
        setlocal buftype=nofile
        silent %delete _
        call setline(1, split(l:jq_result, "\n"))
        setlocal nomodifiable
        wincmd w
    else
        echohl WarningMsg
        echo 'No output from jq command.'
        echohl None
    endif
endfunction

nnoremap <leader>jq :call PreviewJqCmd()<CR>
autocmd FileType json nmap <buffer> s :call PreviewJqCmd()<CR>

