"these lines are suggested to be at the top of every colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif

if !empty($COLORTERM) && has("termguicolors")
   if &term =~# 'xterm'
      if exists('$TMUX')
         " tmux truecolor
         let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
         let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
         " tmux italic
         let &t_ZH="\e[3m"
         let &t_ZR="\e[23m"
      endif
      " fix undercurl
      let &t_Cs = "\e[4:3m"
      let &t_Ce = "\e[4:0m"
      " change cursor style in insert mode
      let &t_SI = "\e[5 q"    " https://stackoverflow.com/questions/6488683/how-to-change-the-cursor-between-normal-and-insert-modes-in-vim
      let &t_EI = "\e[2 q"
   endif
   set termguicolors
   set background=dark
   runtime colors/solarized8.vim
   let g:colors_name = "gerard"
   hi LineNrAbove term=NONE cterm=NONE ctermfg=166 ctermbg=236 guifg=#839496 guibg=#073642
   hi LineNrBelow term=NONE cterm=NONE ctermfg=166 ctermbg=236 guifg=#839496 guibg=#073642
   hi LineNr ctermfg=256 ctermbg=236 cterm=bold guifg=darkorange
   hi StatusLineTerm ctermbg=24 ctermfg=254 guibg=#004f87 guifg=#e4e4e4
   hi StatusLineTermNC ctermbg=252 ctermfg=238 guibg=#d0d0d0 guifg=#444444
   hi CocErrorVirtualText cterm=undercurl,italic ctermfg=9 ctermbg=235 guifg=#ff0000 guibg=#002b36
   hi CocWarningVirtualText cterm=undercurl,italic ctermfg=130 ctermbg=235 guifg=#ff922b guibg=#002b36
   hi CocInfoVirtualText cterm=italic ctermfg=11 ctermbg=235 guifg=#fab005 guibg=#002b36
   hi CocHintVirtualText cterm=italic ctermfg=12 ctermbg=235 guifg=#15aabf guibg=#002b36
   hi Comment cterm=italic term=italic ctermfg=11 gui=italic guifg=#586e75
endif
