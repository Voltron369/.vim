
" reload fugitive if git gutter stage hunk
function s:reload_fugitive_index()
   for w in getwininfo()
      if bufname(w.bufnr) =~ "^fugitive://.*\.git/.*"
         exec w.winnr . "windo e | wincmd p"
      endif
   endfor
endfunction
autocmd User GitGutterStage nested call s:reload_fugitive_index()
