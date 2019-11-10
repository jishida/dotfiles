let s:directory = getcwd() . '/.vim/sessions'
if isdirectory(s:directory)
  let g:session_directory = s:directory
  let g:session_autosave = 'yes'
  let g:session_autoload = 'yes'
  let g:session_autosave_periodic = 5
else
  let g:session_directory = '~/.config/vim/sessions'
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:directory
