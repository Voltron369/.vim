
augroup COCHasFormatMappings
   autocmd!
   autocmd VimEnter,BufEnter,BufReadPost * call CocFormatMappings()
augroup END

function! CocFormatMappings()
   if exists('*CocAction')
      try
         if !CocAction('hasProvider', 'format')
            return
         endif
      catch
         return
      endtry
   endif
   xmap <buffer> <silent> = :<C-U>call CocActionAsync('formatSelected', visualmode())<CR>
   nmap <buffer> <silent> = <Plug>(coc-format-operator)
   nmap <buffer> <silent> == :<C-U>call <SID>FormatLinesWithCount(v:count)<CR>
endfunction

function! s:FormatLinesWithCount(count)
   if !exists('*CocAction')
      return
   endif
   let line_count = a:count == 0 ? 1 : a:count
   if line_count == 1
      normal =_
   else
      let end_line_offset = line_count - 1
      execute "normal =".end_line_offset."j"
   endif
endfunction

function! s:format_op(type)
   if !exists('*CocAction')
      return
   endif
   if a:type == 'line'
      call CocActionAsync('formatSelected', 'line')
   elseif a:type == 'char'
      call CocActionAsync('formatSelected', 'char')
   elseif a:type == 'block'
      call CocActionAsync('formatSelected', 'char')
   endif
endfunction
nmap <silent> <Plug>(coc-format-operator) :set operatorfunc=<SID>format_op<CR>g@

