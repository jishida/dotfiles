command! -nargs=? SwitchHeight call swlen#switch_height(<f-args>)
command! -nargs=? SwitchWidth call swlen#switch_width(<f-args>)

command! -nargs=* InitSwitchHeight call swlen#init_height_cmd(<f-args>)
command! -nargs=* InitSwitchWidth call swlen#init_width_cmd(<f-args>)

function! swlen#switch_height(...) abort
  let info = s:get_info(0)
  if a:0 > 0
    call s:switch_length(info, a:1)
  else
    call s:switch_length(info)
  endif
endfunction

function! swlen#switch_width(...) abort
  let info = s:get_info(1)
  if a:0 > 0
    call s:switch_length(info, a:1)
  else
    call s:switch_length(info)
  endif
endfunction

function! swlen#init_height(opts) abort
  call s:init_length(a:opts, 0)
endfunction

function! swlen#init_width(opts) abort
  call s:init_length(a:opts, 1)
endfunction

function! swlen#init_height_cmd(...) abort
  let opts = s:parse_args(a:000)
  call s:init_length(opts, 0)
endfunction

function! swlen#init_width_cmd(...) abort
  let opts = s:parse_args(a:000)
  call s:init_length(opts, 1)
endfunction

function! swlen#get_info(...)
  return deepcopy(a:0 > 0 ? s:get_info(a:1) : s:get_info())
endfunction

function! swlen#get_height()
  let info = s:get_info(0)
  return s:get_length(info, 0)
endfunction

function! swlen#get_width()
  let info = s:get_info(1)
  return s:get_length(info, 0)
endfunction

" implementation

function! s:init_length(opts, vertical) abort
  call s:init_info(a:opts, a:vertical)
  let info = s:get_info(a:vertical)
  call s:switch_length(info, 0)
endfunction

function! s:get_length(info, step) abort
  let count = a:info['count']
  let start = a:info['start']
  let end = a:info['end']
  let mstart = a:info['margin-start']
  let mend = a:info['margin-end']
  let max_length = (a:info['vertical'] ? &columns : &lines) - mstart - mend
  let unit = max_length / a:info['count']
  let length = end - start
  if length == 0
    let a:info['pos'] = start
  elseif a:step != 0
    let a:info['pos'] = s:rotate(a:info['pos'] - start, a:step, length) + start
  endif
  let pos = a:info['pos']
  return unit * pos + mstart
endfunction

function! s:switch_length(info, ...) abort
  let step = a:0 > 0 ? a:1 : a:info['step']
  let length = s:get_length(a:info, step)
  execute s:get_cmd(a:info['vertical']) s:str(length)
endfunction

function! s:rotate(pos, step, length)
  if a:step > 0
    if a:pos >= a:length
      return 0
    endif
    let pos = a:pos + a:step
    return pos > a:length ? a:length : pos
  elseif a:step < 0
    if a:pos <= 0
      return a:length
    endif
    let pos = a:pos + a:step
    return pos < 0 ? 0 : pos
  endif
  return pos
endfunction

function! s:get_info_key(vertical)
  return a:vertical ? '1' : '0'
endfunction

function! s:get_cmd(vertical)
  return a:vertical ? 'vertical resize' : 'resize'
endfunction

function! s:has_info(...)
  if ! exists('b:swlen_info')
    return 0
  endif
  if a:0 == 0
    return 1
  endif
  return has_key(b:swlen_info, s:get_info_key(a:1))
endfunction

function! s:init_info(opts, vertical) abort
  let count = s:float(get(a:opts, 'count', s:default_count(a:vertical)))
  let count = count < 1 ? 1.0 : count
  let start = s:float(get(a:opts, 'start', s:default_start(a:vertical)))
  let start = start > count ? count : start
  let end = s:float(get(a:opts, 'end', s:default_end(a:vertical, count, start)))
  let end = end < start ? start : end > count ? count : end
  let pos = s:float(get(a:opts, 'pos', ((end - start) / 2) + start))
  let pos = pos < start ? start : pos > end ? end : pos
  let step = s:float(get(a:opts, 'step', 1))
  let mstart = s:nr(get(a:opts, 'margin-start', 0))
  let mend = s:nr(get(a:opts, 'margin-end', 0))

  let info = {
        \ 'vertical': a:vertical ? 1 : 0,
        \ 'count': count,
        \ 'start': start,
        \ 'end': end,
        \ 'pos': pos,
        \ 'step': step,
        \ 'margin-start': mstart,
        \ 'margin-end': mend
        \ }
  if ! s:has_info()
    let b:swlen_info = {}
  endif
  let b:swlen_info[s:get_info_key(a:vertical)] = info
endfunction

let s:optnames = [ 'count', 'start', 'end', 'pos', 'step', 'margin-start', 'margin-end' ]

function! s:parse_args(args)
  let opts = {}
  let args = []

  for a in a:args
    if a =~ '^-'
      if a =~ '^-count='
        let opts['count'] = strpart(a, 7)
        continue
      elseif a =~ '^-start='
        let opts['start'] = strpart(a, 7)
        continue
      elseif a =~ '^-end='
        let opts['end'] = strpart(a, 5)
        continue
      elseif a =~ '^-pos='
        let opts['pos'] = strpart(a, 5)
        continue
      elseif a =~ '^-step='
        let opts['step'] = strpart(a, 6)
        continue
      elseif a =~ '^-margin-start='
        let opts['margin-start'] = strpart(a, 14)
        continue
      elseif a =~ '^-margin-end='
        let opts['margin-end'] = strpart(a, 12)
        continue
      endif
    endif
    call add(args, s:str(a))
  endfor

  for i in range(len(s:optnames))
    if len(args) <= i
      break
    endif
    let opts[s:optnames[i]] = args[i]
  endfor

  return opts
endfunction

function! s:default_count(vertical)
  let var = 'swlen#default_'.(a:vertical ? 'columns' : 'rows')
  return get(g:, var, 6)
endfunction

function! s:default_start(vertical)
  let var = 'swlen#default_'.(a:vertical ? 'column' : 'row').'_start'
  return get(g:, var, 0)
endfunction

function! s:default_end(vertical, count, start)
  let var = 'swlen#default_'.(a:vertical ? 'column' : 'row').'_end_ratio'
  let ratio = s:float(get(g:, var, 1))
  let ratio = ratio < 0 ? 0 : ratio > 1 ? 1.0 : ratio
  return ((a:count - a:start) * ratio) + a:start
endfunction

function! s:get_info(...)
  if a:0 > 0
    let key = s:get_info_key(a:1)
    if ! s:has_info(a:1)
      call s:init_info({}, a:1)
    endif
    return b:swlen_info[key]
  endif

  for i in range(2)
    if ! s:has_info(i)
      call s:init_info({}, i)
    endif
  endfor
  return b:swlen_info
endfunction

function! s:str(val) abort
  return type(a:val) == 1 ? a:val : string(a:val)
endfunction

function! s:nr(val) abort
  let s = s:str(a:val)
  if s !~ '^-\?[0-9]\+$'
    throw 'Invalid number: '.s
  endif
  return str2nr(s)
endfunction

function! s:float(val) abort
  let s = s:str(a:val)
  if s !~ '^-\?[0-9]\+\(\.[0-9]\+\(e[0-9]\+\)\?\)\?$'
    throw 'Invalid float: '.s
  endif
  return str2float(s)
endfunction
