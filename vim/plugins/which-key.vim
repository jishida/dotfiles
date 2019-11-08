call which_key#register('<Space>', 'g:leader_map')
call which_key#register(',', 'g:localleader_map')

let s:spkey_dict = {
      \ '<Space>': ' ',
      \ '<Bar>'  : '|',
      \ }
function! s:_map(key, cmd, desc, mapcmd, local) abort
  let leaderkey = a:local ? '<localleader>' : '<leader>'
  let key = '.'.a:key
  let key = substitute(key, '\.\.', '.<Dot>', 'g')
  let key = strpart(key, 1)
  let keys = split(key, '\.')
  let keys = map(keys, {_, val -> val =~? '^<dot>$' ? '.' : val})
  if len(keys) == 0
    throw a:key.' is invalid'
  endif
  for k in keys
    if empty(k)
      throw a:key.' contains empty key'
    endif
  endfor
  let key = remove(keys, -1)
  let mapped_keys = leaderkey.join(keys, '').key
  let keys = map(keys, {_, val -> get(s:spkey_dict, val, val)})
  let m = a:local ? g:localleader_map : g:leader_map
  for k in keys
    if !has_key(m, k)
      throw a:key.' not found'
    endif
    let m = m[k]
    if type(m) != 4
      throw a:key.' has not dictionary'
    endif
  endfor
  if a:cmd =~? '^<Plug>'
    let cmd = a:cmd
  else
    let cmd = ':<C-u>'.a:cmd.'<CR>'
  endif
  execute a:mapcmd '<silent>' mapped_keys cmd
  if empty(a:desc)
    let m[key] = 'which_key_ignore'
  else
    let m[key] = a:desc
  endif
endfunction

function! s:noremap(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'nnoremap', 0)
endfunction

function! s:map(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'nmap', 0)
endfunction

function! s:noremap_local(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'nnoremap', 1)
endfunction

function! s:map_local(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'nmap', 1)
endfunction

let g:leader_map = { '1-9': 'switch-window' }
for i in [1,2,3,4,5,6,7,8,9]
  call s:noremap(i, i.'wincmd w', '')
endfor
call s:noremap('r' , '<C-l>'                  , 'refresh'         )

let g:leader_map.w = { 'name': '+window' }
call s:noremap('w.q'     , 'quit'              , 'quit'               )
call s:noremap('w.Q'     , 'quit!'             , 'force-quit'         )
call s:noremap('w.c'     , 'close'             , ''                   )
call s:noremap('w.n'     , 'new'               , 'new'                )
call s:noremap('w.s'     , 'split'             , 'horizental-split'   )
call s:noremap('w.S'     , 'new'               , 'horizental-new'     )
call s:noremap('w.v'     , 'vsplit'            , 'vertical-split'     )
call s:noremap('w.V'     , 'vnew'              , 'vertical-new'       )
call s:noremap('w.o'     , 'only'              , 'only'               )
call s:noremap('w.j'     , 'wincmd j'          , 'go-below'           )
call s:noremap('w.k'     , 'wincmd k'          , 'go-up'              )
call s:noremap('w.h'     , 'wincmd h'          , 'go-left'            )
call s:noremap('w.l'     , 'wincmd l'          , 'go-right'           )
call s:noremap('w.t'     , 'wincmd t'          , 'go-top'             )
call s:noremap('w.b'     , 'wincmd b'          , 'go-bottom'          )
call s:noremap('w.w'     , 'wincmd w'          , 'go-next'            )
call s:noremap('w.W'     , 'wincmd W'          , 'go-previous'        )
call s:noremap('w.p'     , 'wincmd p'          , 'go-previous-active' )
call s:noremap('w.P'     , 'wincmd P'          , 'go-preview'         )
call s:noremap('w.J'     , 'SwitchHeight -1'   , 'switch-height -'    )
call s:noremap('w.K'     , 'SwitchHeight 1'    , 'switch-height +'    )
call s:noremap('w.H'     , 'SwitchWidth -1'    , 'switch-width -'     )
call s:noremap('w.L'     , 'SwitchWidth 1'     , 'switch-width +'     )
call s:noremap('w._'     , 'wincmd _'          , 'expand-height-max'  )
call s:noremap('w.<Bar>' , 'wincmd <Bar>'      , 'expand-width-max'   )
call s:noremap('w.='     , 'wincmd ='          , 'balance-windows'    )
call s:noremap('w.T'     , 'terminal'          , 'terminal'           )

let g:leader_map.e = { 'name': '+tab', '1-9': 'switch-tab' }
for i in [1,2,3,4,5,6,7,8,9]
  call s:noremap('e.'.i, i.'tabnext', '')
endfor
call s:noremap( 'e.e' , 'call TabNewWithTerminal()' , 'new-terminal'  )
call s:noremap( 'e.n' , 'call TabNewWithDefx()'     , 'new-defx'      )
call s:noremap( 'e.N' , 'tabnew'                    , 'new'           )
call s:noremap( 'e.j' , '$tabnext'                  , 'go-last'       )
call s:noremap( 'e.k' , '1tabnext'                  , 'go-first'      )
call s:noremap( 'e.h' , '-tabnext'                  , 'go-previous'   )
call s:noremap( 'e.l' , '+tabnext'                  , 'go-next'       )
call s:noremap( 'e.J' , '0tabmove'                  , 'move-first'    )
call s:noremap( 'e.K' , '$tabmove'                  , 'move-last'     )
call s:noremap( 'e.H' , '-tabmove'                  , 'move-previous' )
call s:noremap( 'e.L' , '+tabmove'                  , 'move-next'     )
call s:noremap( 'e.q' , 'tabclose'                  , 'close'         )
call s:noremap( 'e.Q' , 'tabclose!'                 , 'force-close'   )

" let g:leader_map[' '] = { 'name': '+ale' }
" call s:noremap( '<Space>.i'   , 'ALEInfo'                          , 'info'            )
" call s:map(     '<Space>.o'   , '<Plug>(ale_hover)'                , 'hover'           )
" call s:map(     '<Space>.p'   , '<Plug>(ale_documentation)'        , 'documentation'   )
" call s:noremap( '<Space>.R'   , 'ALERename'                        , 'rename'          )
" call s:map(     '<Space>.l'   , '<Plug>(ale_lint)'                 , 'lint'            )
" call s:map(     '<Space>.m'   , '<Plug>(ale_detail)'               , 'detail'          )
" call s:map(     '<Space>.r'   , '<Plug>(ale_find_references)'      , 'find-reference'  )
" call s:map(     '<Space>.f'   , '<Plug>(ale_fix)'                  , 'fix'             )
" call s:map(     '<Space>.e'   , '<Plug>(ale_next_wrap_error)'      , 'next-error'      )
" call s:map(     '<Space>.E'   , '<Plug>(ale_previous_wrap_error)'  , 'previous-error'  )
" call s:map(     '<Space>.w'   , '<Plug>(ale_next_wrap_warning)'    , 'next-warning'    )
" call s:map(     '<Space>.W'   , '<Plug>(ale_previous_wrap_warning)', 'previous-warning')
"
" let g:leader_map[' '].d = { 'name': '+go-to-definition' }
" call s:map(     '<Space>.d.j' , '<Plug>(ale_go_to_definition)'          , 'current-window'  )
" call s:map(     '<Space>.d.s' , '<Plug>(ale_go_to_definition_in_split)' , 'horizontal-split')
" call s:map(     '<Space>.d.v' , '<Plug>(ale_go_to_definition_in_vsplit)', 'vertical-split'  )
"
" let g:leader_map[' '].t = { 'name': '+go-to-type-definition' }
" call s:map(     '<Space>.t.j' , '<Plug>(ale_go_to_type_definition)'           , 'current-window'  )
" call s:map(     '<Space>.t.s' , '<Plug>(ale_go_to_type_definition_in_split)'  , 'horizental-split')
" call s:map(     '<Space>.t.v' , '<Plug>(ale_go_to_type_definition_in_vsplit)' , 'vertical-split'  )
"
" let g:leader_map[' '].q = { 'name': '+control' }
" call s:map(     '<Space>.q.r' , '<Plug>(ale_reset_buffer)'  , 'reset-buffer'  )
" call s:map(     '<Space>.q.R' , '<Plug>(ale_reset)'         , 'reset'         )
" call s:map(     '<Space>.q.t' , '<Plug>(ale_toggle_buffer)' , 'toggle-buffer' )
" call s:map(     '<Space>.q.T' , '<Plug>(ale_toggle)'        , 'toggle'        )
" call s:map(     '<Space>.q.d' , '<Plug>(ale_disable_buffer)', 'disable-buffer')
" call s:map(     '<Space>.q.D' , '<Plug>(ale_disable)'       , 'disable'       )
" call s:map(     '<Space>.q.e' , '<Plug>(ale_enable_buffer)' , 'enable-buffer' )
" call s:map(     '<Space>.q.E' , '<Plug>(ale_enable)'        , 'enable'        )

let g:leader_map[' '] = { 'name': '+coc' }
call s:noremap( '<Space>.<Space>' , 'CocList'                           , 'coc-list'                    )
call s:map(     '<Space>.I'       , '<Plug>(coc-diagnostic-info)'       , 'show-diagnostic-message'     )
call s:map(     '<Space>.m'       , '<Plug>(coc-diagnostic-next)'       , 'jump-to-next-diagnostic'     )
call s:map(     '<Space>.M'       , '<Plug>(coc-diagnostic-prev)'       , 'jump-to-previous-diagnostic' )
call s:map(     '<Space>.e'       , '<Plug>(coc-diagnostic-next-error)' , 'jump-to-next-error'          )
call s:map(     '<Space>.E'       , '<Plug>(coc-diagnostic-prev-error)' , 'jump-to-previous-error'      )
call s:map(     '<Space>.d'       , '<Plug>(coc-definition)'            , 'jump-to-definition'          )
call s:map(     '<Space>.D'       , '<Plug>(coc-declaration)'           , 'jump-to-declaration'         )
call s:map(     '<Space>.i'       , '<Plug>(coc-implementaion)'         , 'jump-to-implementaion'       )
call s:map(     '<Space>.t'       , '<Plug>(coc-type-definition)'       , 'jump-to-type-declaration'    )
call s:map(     '<Space>.r'       , '<Plug>(coc-reference)'             , 'jump-to-reference'           )
call s:map(     '<Space>.F'       , '<Plug>(coc-format-selected)'       , 'format-selected-range'       )
call s:map(     '<Space>.f'       , '<Plug>(coc-format)'                , 'format'                      )
call s:map(     '<Space>.R'       , '<Plug>(coc-rename)'                , 'rename-symbol'               )
call s:map(     '<Space>.a'       , '<Plug>(coc-codeaction)'            , 'code-action'                 )
call s:map(     '<Space>.A'       , '<Plug>(coc-codeaction-selected)'   , 'code-action-selected-region' )
call s:map(     '<Space>.l'       , '<Plug>(coc-openlink)'              , 'open-link'                   )
call s:map(     '<Space>.q'       , '<Plug>(coc-fix-current)'           , 'quickfix-action'             )

let g:leader_map[' '].w = { 'name': '+window' }
call s:map(     '<Space>.w.q' , '<Plug>(coc-float-hide)'            , 'hide-all-float-window'       )
call s:map(     '<Space>.w.j' , '<Plug>(coc-float-jump)'            , 'jump-to-first-float-window'  )
call s:map(     '<Space>.w.r' , '<Plug>(coc-refactor)'              , 'refactor'                    )

let g:leader_map[' '].s = { 'name': '+select' }
call s:map(     '<Space>.s.n' , '<Plug>(coc-range-select)'          , 'select-next-selection-range' )
call s:map(     '<Space>.s.p' , '<Plug>(coc-range-select-backward)' , 'select-prev-selection-range' )
call s:map(     '<Space>.s.i' , '<Plug>(coc-funcobj-i)'             , 'select-inside-function'      )
call s:map(     '<Space>.s.a' , '<Plug>(coc-funcobj-a)'             , 'select-current-function'     )

let g:leader_map[' '].c = { 'name': '+config' }
call s:noremap( '<Space>.c.j' , 'CocConfig'                         , 'open-current-window'         )
call s:noremap( '<Space>.c.s' , 'split<CR>:<C-u>CocConfig'          , 'open-horizontal-split'       )
call s:noremap( '<Space>.c.v' , 'vsplit<CR>:<C-u>CocConfig'         , 'open-vertical-split'         )

let g:leader_map.a = { 'name': '+ale' }
call s:noremap( 'a.i'   , 'ALEInfo'                          , 'info'            )
call s:map(     'a.o'   , '<Plug>(ale_hover)'                , 'hover'           )
call s:map(     'a.p'   , '<Plug>(ale_documentation)'        , 'documentation'   )
call s:noremap( 'a.R'   , 'ALERename'                        , 'rename'          )
call s:map(     'a.l'   , '<Plug>(ale_lint)'                 , 'lint'            )
call s:map(     'a.m'   , '<Plug>(ale_detail)'               , 'detail'          )
call s:map(     'a.r'   , '<Plug>(ale_find_references)'      , 'find-reference'  )
call s:map(     'a.f'   , '<Plug>(ale_fix)'                  , 'fix'             )
call s:map(     'a.e'   , '<Plug>(ale_next_wrap_error)'      , 'next-error'      )
call s:map(     'a.E'   , '<Plug>(ale_previous_wrap_error)'  , 'previous-error'  )
call s:map(     'a.w'   , '<Plug>(ale_next_wrap_warning)'    , 'next-warning'    )
call s:map(     'a.W'   , '<Plug>(ale_previous_wrap_warning)', 'previous-warning')

let g:leader_map.a.d = { 'name': '+go-to-definition' }
call s:map(     'a.d.j' , '<Plug>(ale_go_to_definition)'          , 'current-window'  )
call s:map(     'a.d.s' , '<Plug>(ale_go_to_definition_in_split)' , 'horizontal-split')
call s:map(     'a.d.v' , '<Plug>(ale_go_to_definition_in_vsplit)', 'vertical-split'  )

let g:leader_map.a.t = { 'name': '+go-to-type-definition' }
call s:map(     'a.t.j' , '<Plug>(ale_go_to_type_definition)'           , 'current-window'  )
call s:map(     'a.t.s' , '<Plug>(ale_go_to_type_definition_in_split)'  , 'horizental-split')
call s:map(     'a.t.v' , '<Plug>(ale_go_to_type_definition_in_vsplit)' , 'vertical-split'  )

let g:leader_map.a.q = { 'name': '+control' }
call s:map(     'a.q.r' , '<Plug>(ale_reset_buffer)'  , 'reset-buffer'  )
call s:map(     'a.q.R' , '<Plug>(ale_reset)'         , 'reset'         )
call s:map(     'a.q.t' , '<Plug>(ale_toggle_buffer)' , 'toggle-buffer' )
call s:map(     'a.q.T' , '<Plug>(ale_toggle)'        , 'toggle'        )
call s:map(     'a.q.d' , '<Plug>(ale_disable_buffer)', 'disable-buffer')
call s:map(     'a.q.D' , '<Plug>(ale_disable)'       , 'disable'       )
call s:map(     'a.q.e' , '<Plug>(ale_enable_buffer)' , 'enable-buffer' )
call s:map(     'a.q.E' , '<Plug>(ale_enable)'        , 'enable'        )

let g:leader_map.f = { 'name': '+file' }
call s:noremap( 'f.j'  , 'call EnterDefaultDefx()'                                , 'defx'                    )
call s:noremap( 'f.o'  , 'Denite file/old'                                        , 'denite file/old'         )
call s:noremap( 'f.g'  , 'Denite grep -buffer-name=denite-grep'                   , 'denite grep'             )
call s:noremap( 'f.F'  , 'Denite file -buffer-name=denite-file'                   , 'denite file'             )
call s:noremap( 'f.f'  , 'Denite file/rec -buffer-name=denite-file'               , 'denite file/rec'         )
call s:noremap( 'f.h'  , 'Denite file/rec:~ -buffer-name=denite-file'             , 'denite file/rec:~'       )
call s:noremap( 'f.c'  , 'Denite file/rec:~/.config/vim -buffer-name=denite-file' , 'denite file/rec:[config]')

let g:leader_map.f.w = { 'name': '+cursor-word' }
call s:noremap( 'f.w.g', 'DeniteCursorWord grep -buffer-name=denite-grep'         , 'denite grep'     )
call s:noremap( 'f.w.f', 'DeniteCursorWord file/rec -buffer-name=denite-file'     , 'denite file/rec' )

let g:leader_map.f.z = { 'name': '+fzf' }
call s:noremap( 'f.z.f', 'FZF'    , 'fzf'   )
call s:noremap( 'f.z.h', 'FZF ~'  , 'fzf ~' )

let g:leader_map.b = { 'name': '+buffer' }
call s:noremap( 'b.b'  , 'Denite buffer'                             , 'buffer' )
call s:noremap( 'b.g'  , 'Denite -resume -buffer-name=denite-grep'   , 'grep' )
call s:noremap( 'b.f'  , 'Denite -resume -buffer-name=denite-file'   , 'file' )

let g:leader_map.b.G = { 'name': '+gtags' }
call s:noremap( 'b.G.d' , 'Denite -resume -buffer-name=gtags_def'        , 'definition' )
call s:noremap( 'b.G.r' , 'Denite -resume -buffer-name=gtags_ref'        , 'reference'  )
call s:noremap( 'b.G.x' , 'Denite -resume -buffer-name=gtags_context'    , 'context'    )
call s:noremap( 'b.G.g' , 'Denite -resume -buffer-name=gtags_grep'       , 'grep'       )
call s:noremap( 'b.G.c' , 'Denite -resume -buffer-name=gtags_completion' , 'completion' )
call s:noremap( 'b.G.f' , 'Denite -resume -buffer-name=gtags_file'       , 'file'       )
call s:noremap( 'b.G.F' , 'Denite -resume -buffer-name=gtags_files'      , 'files'      )

let g:leader_map.g = { 'name': '+git' }
call s:noremap( 'g.s' , 'Gstatus'         , 'status'        )
call s:noremap( 'g.r' , 'Gread'           , 'read'          )
call s:noremap( 'g.w' , 'Gwrite'          , 'write'         )
call s:noremap( 'g.d' , 'Gdiff'           , 'diff'          )
call s:noremap( 'g.m' , 'Gmerge'          , 'merge'         )
call s:noremap( 'g.c' , 'Gcommit'         , 'commit'        )
call s:noremap( 'g.M' , 'Gmove'           , 'move'          )
call s:noremap( 'g.R' , 'Gremove'         , 'remove'        )
call s:noremap( 'g.t' , 'GitGutterToggle' , 'gutter-toggle' )

let g:leader_map.G = { 'name': '+gtags' }
call s:noremap( 'G.d' , 'DeniteCursorWord -buffer-name=gtags_def gtags_def'         , 'definition-of-tag'               )
call s:noremap( 'G.r' , 'DeniteCursorWord -buffer-name=gtags_ref gtags_ref'         , 'reference-to-tag'                )
call s:noremap( 'G.x' , 'DeniteCursorWord -buffer-name=gtags_context gtags_context' , 'definition/reference-to-tag'     )
call s:noremap( 'G.g' , 'DeniteCursorWord -buffer-name=gtags_grep gtags_grep'       , 'grep-search-of-tag'              )
call s:noremap( 'G.c' , 'Denite -buffer-name=gtags_completion gtags_completion'     , 'list-all-tags'                   )
call s:noremap( 'G.f' , 'Denite -buffer-name=gtags_file gtags_file'                 , 'list-all-tags-in-file'           )
call s:noremap( 'G.F' , 'Denite -buffer-name=gtags_files gtags_files'               , 'list-all-tags-under-current-dir' )
call s:noremap( 'G.D' , 'GtagsCursor'                                               , 'go-to-definition(quickfix)'      )
call s:noremap( 'G.G' , 'Gtags -f %'                                                , 'generate-gtags'                  )

" same as <leader>bg
let g:leader_map.G.b = { 'name': '+buffer' }
call s:noremap( 'G.b.d' , 'Denite -resume -buffer-name=gtags_def'        , 'definition' )
call s:noremap( 'G.b.r' , 'Denite -resume -buffer-name=gtags_ref'        , 'reference'  )
call s:noremap( 'G.b.x' , 'Denite -resume -buffer-name=gtags_context'    , 'context'    )
call s:noremap( 'G.b.g' , 'Denite -resume -buffer-name=gtags_grep'       , 'grep'       )
call s:noremap( 'G.b.c' , 'Denite -resume -buffer-name=gtags_completion' , 'completion' )
call s:noremap( 'G.b.f' , 'Denite -resume -buffer-name=gtags_file'       , 'file'       )
call s:noremap( 'G.b.F' , 'Denite -resume -buffer-name=gtags_files'      , 'files'      )

let g:leader_map.t = { 'name': '+test' }
call s:noremap( 't.n' , 'TestNearest' , 'nearest' )
call s:noremap( 't.f' , 'TestFile'    , 'file'    )
call s:noremap( 't.s' , 'TestSuite'   , 'suite'   )
call s:noremap( 't.l' , 'TestLast'    , 'last'    )
call s:noremap( 't.v' , 'TestVisit'   , 'visit'   )

let g:leader_map.q = { 'name': '+quit' }
call s:noremap( 'q.q' , 'quitall'   , 'quit-all'          )
call s:noremap( 'q.y' , 'quitall!'  , 'force-quit-all'    )
call s:noremap( 'q.w' , 'quit'      , 'quit-window'       )
call s:noremap( 'q.W' , 'quit!'     , 'force-quit-window' )
call s:noremap( 'q.t' , 'tabclose'  , 'quit-tab'          )
call s:noremap( 'q.T' , 'tabclose!' , 'force-quit-tab'    )

let g:localleader_map = {}
call s:map_local( 's' , '<Plug>(easymotion-s2)'     , 'easymotion-s2'    )
call s:map_local( 'f' , '<Plug>(easymotion-f2)'     , 'easymotion-f2'    )
call s:map_local( 'F' , '<Plug>(easymotion-F2)'     , 'easymotion-F2'    )
call s:map_local( 't' , '<Plug>(easymotion-t2)'     , 'easymotion-t2'    )
call s:map_local( 'T' , '<Plug>(easymotion-T2)'     , 'easymotion-T2'    )
call s:map_local( 'j' , '<Plug>(easymotion-j)'      , 'easymotion-j'     )
call s:map_local( 'k' , '<Plug>(easymotion-k)'      , 'easymotion-k'     )
call s:map_local( 'b' , '<Plug>(easymotion-bd-jk)'  , 'easymotion-bd-jk' )
call s:map_local( 'w' , '<Plug>(easymotion-bd-w)'   , 'easymotion-bd-w'  )
call s:map_local( 'e' , '<Plug>(easymotion-bd-e)'   , 'easymotion-bd-e'  )

let g:localleader_map[','] = { 'name': '+additional'}
call s:map_local( ',.s' , '<Plug>(easymotion-s)'      , 'easymotion-s'     )
call s:map_local( ',.f' , '<Plug>(easymotion-f)'      , 'easymotion-f'     )
call s:map_local( ',.F' , '<Plug>(easymotion-F)'      , 'easymotion-F'     )
call s:map_local( ',.t' , '<Plug>(easymotion-t)'      , 'easymotion-t'     )
call s:map_local( ',.T' , '<Plug>(easymotion-T)'      , 'easymotion-T'     )
call s:map_local( ',.j' , '<Plug>(easymotion-j)'      , 'easymotion-j'     )
call s:map_local( ',.k' , '<Plug>(easymotion-k)'      , 'easymotion-k'     )
call s:map_local( ',.b' , '<Plug>(easymotion-bd-jk)'  , 'easymotion-bd-jk' )
call s:map_local( ',.w' , '<Plug>(easymotion-w)'      , 'easymotion-bd-w'  )
call s:map_local( ',.W' , '<Plug>(easymotion-W)'      , 'easymotion-bd-W'  )
call s:map_local( ',.e' , '<Plug>(easymotion-e)'      , 'easymotion-bd-e'  )
call s:map_local( ',.E' , '<Plug>(easymotion-E)'      , 'easymotion-bd-E'  )

let g:localleader_map.o = { 'name': '+overwin'}
call s:map_local( 'o.s' , '<Plug>(easymotion-overwin-f2)'      , 'easymotion-overwin-f2'     )
call s:map_local( 'o.f' , '<Plug>(easymotion-overwin-f)'       , 'easymotion-overwin-f'      )
call s:map_local( 'o.l' , '<Plug>(easymotion-overwin-line)'    , 'easymotion-overwin-line'   )
call s:map_local( 'o.w' , '<Plug>(easymotion-overwin-w)'       , 'easymotion-overwin-w'     )
