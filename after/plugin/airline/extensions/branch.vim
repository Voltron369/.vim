function! GitGetReponame()
   let s:git_config_url = split(system('git config --get remote.origin.url'),'\n')
   if len(s:git_config_url) == 0
      return ''
   endif
   let s:git_url = s:git_config_url[0]
   return matchstr(s:git_url, '/\([^/]*\).git$')[1:-5] . ' '
endfunction

function! airline#extensions#branch#get_head()
  let head = airline#extensions#branch#head()
  let winwidth = get(airline#parts#get('branch'), 'minwidth', 120)
  let minwidth = empty(get(b:, 'airline_hunks', '')) ? 14 : 7
  let head = airline#util#shorten(head, winwidth, minwidth)
  let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
  return empty(head)
        \ ? get(g:, 'airline#extensions#branch#empty_message', '')
        \ : printf('%s%s%s', GitGetReponame(), empty(symbol) ? '' : symbol.(g:airline_symbols.space),  head)
endfunction
