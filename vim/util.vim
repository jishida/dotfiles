function! s:clear_messages() abort
  for i in range(201)
    echom ''
  endfor
endfunction
command! -bar Clear call s:clear_messages()

source ~/.config/vim/swlen.vim

function! InitDefaultDefx() abort
  call EnterDefaultDefx()
  call swlen#init_width({
        \ 'count': get(g:, 'initdefx_count', 6),
        \ 'start': get(g:, 'initdefx_start', 0),
        \ 'end': get(g:, 'initdefx_end', 3),
        \ 'pos': get(g:, 'initdefx_pos', 1),
        \ 'step': get(g:, 'initdefx_step', 1),
        \ 'margin-start': get(g:, 'initdefx_margin_start', 0),
        \ 'margin-end': get(g:, 'initdefx_margin_end', 0)
        \ })
  call s:update_initdefx_tab_width()
  call EnterDefaultDefx()
endfunction

function! EnterDefaultDefx() abort
  let var = s:initdefx_var()
  let suffix = exists(var) ? ' -winwidth='.float2nr(eval(var)) : ''
  execute 'Defx -listed -show-ignored-files -buffer-name=tab'.tabpagenr() '-split=vertical -direction=topleft -resume'.suffix
  setlocal nowrap
endfunction

command! -nargs=1 SwitchDefaultDefx call s:switch_default_defx(<f-args>)
function! s:switch_default_defx(step) abort
  call swlen#switch_width(str2nr(a:step))
  call s:update_initdefx_tab_width()
endfunction

function! s:update_initdefx_tab_width() abort
  execute 'let' s:initdefx_var() '=' string(swlen#get_width())
endfunction

function! s:initdefx_var() abort
  return 'g:initdefx_tab'.tabpagenr().'_width'
endfunction

function! s:on_vim_enter() abort
  if g:session_autoload !=? 'yes'
    call InitDefaultDefx()
  endif
endfunction

augroup vim_enter
  autocmd!
  autocmd VimEnter * call s:on_vim_enter()
augroup END

function! s:init_local() abort
  let directory = getcwd() . '/.vim/sessions'
  let name = get(g:, 'session_default_name', 'default')
  let ext = get(g:, 'session_extension', '.vim')
  let file = directory . '/' . name . ext
  if filereadable(file)
    echo 'local session already exists'
    return 1
  endif

  if !isdirectory(directory)
    call mkdir(directory, 'p')
  endif
  let g:session_directory = directory
  let g:session_autosave = 'yes'
  let g:session_autosave_periodic = 5
  execute 'SaveSession'
  return 0
endfunction

command! InitLocal call s:init_local()

function! s:source_local_vimrc(location) abort
  if empty(a:location)
    return
  endif
  if exists('b:__local_vimrc_loaded')
    return
  endif
  let b:__local_vimrc_loaded = 1
  let files = findfile('.vim/vimrc', escape(a:location, ' \') . ';', -1)
  let files = filter(files, 'filereadable(v:val)')
  let files = reverse(files)
  for file in files
    source `=file`
  endfor
endfunction

augroup local_vimrc
  autocmd!
  autocmd BufWinEnter * call s:source_local_vimrc(expand('<afile>:p:h'))
augroup END

function! s:edit_local_vimrc() abort
  let dir = getcwd() . '/.vim'
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  execute 'e' escape(dir . '/vimrc', ' \')
endfunction

command! EditLocal call s:edit_local_vimrc()
