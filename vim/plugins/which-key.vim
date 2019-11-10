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
  let mapped_keys = leaderkey.join(keys, '')
  let keys = map(keys, {_, val -> get(s:spkey_dict, val, val)})
  let key = remove(keys, -1)
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

let g:leader_map.t = { 'name': '+tab', '1-9': 'switch-tab' }
for i in [1,2,3,4,5,6,7,8,9]
  call s:noremap('t.'.i, i.'tabnext', '')
endfor
call s:noremap( 't.t' , 'call TabNewWithTerminal()' , 'new-terminal'  )
call s:noremap( 't.n' , 'call TabNewWithDefx()'     , 'new-defx'      )
call s:noremap( 't.N' , 'tabnew'                    , 'new'           )
call s:noremap( 't.j' , '$tabnext'                  , 'go-last'       )
call s:noremap( 't.k' , '1tabnext'                  , 'go-first'      )
call s:noremap( 't.h' , '-tabnext'                  , 'go-previous'   )
call s:noremap( 't.l' , '+tabnext'                  , 'go-next'       )
call s:noremap( 't.J' , '0tabmove'                  , 'move-first'    )
call s:noremap( 't.K' , '$tabmove'                  , 'move-last'     )
call s:noremap( 't.H' , '-tabmove'                  , 'move-previous' )
call s:noremap( 't.L' , '+tabmove'                  , 'move-next'     )
call s:noremap( 't.q' , 'tabclose'                  , 'close'         )
call s:noremap( 't.Q' , 'tabclose!'                 , 'force-close'   )

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
call s:noremap( '<Space>.a'       , 'CocAction'                         , 'coc-action'                  )
call s:map(     '<Space>.l'       , '<Plug>(coc-openlink)'              , 'open-link'                   )
call s:map(     '<Space>.q'       , '<Plug>(coc-fix-current)'           , 'quickfix-action'             )

let g:leader_map[' '].o = { 'name': '+output' }
call s:noremap( '<Space>.o.i'     , 'CocInfo'                           , 'coc-info'                    )
call s:noremap( '<Space>.o.l'     , 'CocOpenLog'                        , 'coc-open-log'                )

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

let g:leader_map.T = { 'name': '+test' }
call s:noremap( 'T.n' , 'TestNearest' , 'nearest' )
call s:noremap( 'T.f' , 'TestFile'    , 'file'    )
call s:noremap( 'T.s' , 'TestSuite'   , 'suite'   )
call s:noremap( 'T.l' , 'TestLast'    , 'last'    )
call s:noremap( 'T.v' , 'TestVisit'   , 'visit'   )

let g:leader_map.q = { 'name': '+quit' }
call s:noremap( 'q.q' , 'quitall'   , 'quit-all'          )
call s:noremap( 'q.Q' , 'quitall!'  , 'force-quit-all'    )
call s:noremap( 'q.w' , 'quit'      , 'quit-window'       )
call s:noremap( 'q.W' , 'quit!'     , 'force-quit-window' )
call s:noremap( 'q.t' , 'tabclose'  , 'quit-tab'          )
call s:noremap( 'q.T' , 'tabclose!' , 'force-quit-tab'    )

let g:localleader_map = {}
call s:map_local( 's'     , '<Plug>(easymotion-s2)'       , 'easymotion-s2'       )
call s:map_local( 'f'     , '<Plug>(easymotion-f2)'       , 'easymotion-f2'       )
call s:map_local( 'F'     , '<Plug>(easymotion-F2)'       , 'easymotion-F2'       )
call s:map_local( 't'     , '<Plug>(easymotion-t2)'       , 'easymotion-t2'       )
call s:map_local( 'T'     , '<Plug>(easymotion-T2)'       , 'easymotion-T2'       )
call s:map_local( 'j'     , '<Plug>(easymotion-sol-j)'    , 'easymotion-sol-j'    )
call s:map_local( 'J'     , '<Plug>(easymotion-eol-j)'    , 'easymotion-eol-j'    )
call s:map_local( 'k'     , '<Plug>(easymotion-sol-k)'    , 'easymotion-sol-k'    )
call s:map_local( 'K'     , '<Plug>(easymotion-eol-k)'    , 'easymotion-eol-k'    )
call s:map_local( 'm'     , '<Plug>(easymotion-sol-bd-jk)', 'easymotion-sol-bd-jk')
call s:map_local( '<Dot>' , '<Plug>(easymotion-eol-bd-jk)', 'easymotion-eol-bd-jk')
call s:map_local( 'w'     , '<Plug>(easymotion-bd-w)'     , 'easymotion-bd-w'     )
call s:map_local( 'W'     , '<Plug>(easymotion-bd-W)'     , 'easymotion-bd-W'     )
call s:map_local( 'e'     , '<Plug>(easymotion-bd-e)'     , 'easymotion-bd-e'     )
call s:map_local( 'E'     , '<Plug>(easymotion-bd-E)'     , 'easymotion-bd-E'     )
call s:map_local( 'r'     , '<Plug>(easymotion-repeat)'   , 'easymotion-repeat'   )
call s:map_local( 'n'     , '<Plug>(easymotion-n)'        , 'easymotion-n'        )
call s:map_local( 'N'     , '<Plug>(easymotion-N)'        , 'easymotion-N'        )

let g:localleader_map[','] = { 'name': '+additional' }
call s:map_local( ',.s'   , '<Plug>(easymotion-s)'      , 'easymotion-s'      )
call s:map_local( ',.f'   , '<Plug>(easymotion-f)'      , 'easymotion-f'      )
call s:map_local( ',.F'   , '<Plug>(easymotion-F)'      , 'easymotion-F'      )
call s:map_local( ',.t'   , '<Plug>(easymotion-t)'      , 'easymotion-t'      )
call s:map_local( ',.T'   , '<Plug>(easymotion-T)'      , 'easymotion-T'      )
call s:map_local( ',.w'   , '<Plug>(easymotion-w)'      , 'easymotion-w'      )
call s:map_local( ',.W'   , '<Plug>(easymotion-W)'      , 'easymotion-W'      )
call s:map_local( ',.b'   , '<Plug>(easymotion-b)'      , 'easymotion-b'      )
call s:map_local( ',.B'   , '<Plug>(easymotion-B)'      , 'easymotion-B'      )
call s:map_local( ',.e'   , '<Plug>(easymotion-e)'      , 'easymotion-e'      )
call s:map_local( ',.E'   , '<Plug>(easymotion-E)'      , 'easymotion-E'      )
call s:map_local( ',.ge'  , '<Plug>(easymotion-ge)'     , 'easymotion-ge'     )
call s:map_local( ',.gE'  , '<Plug>(easymotion-gE)'     , 'easymotion-gE'     )
call s:map_local( ',.j'   , '<Plug>(easymotion-sol-j)'  , 'easymotion-sol-j'  )
call s:map_local( ',.k'   , '<Plug>(easymotion-sol-k)'  , 'easymotion-sol-k'  )
call s:map_local( ',.J'   , '<Plug>(easymotion-eol-j)'  , 'easymotion-eol-j'  )
call s:map_local( ',.k'   , '<Plug>(easymotion-eol-k)'  , 'easymotion-eol-k'  )

let g:localleader_map.o = { 'name': '+overwin' }
call s:map_local( 'o.s' , '<Plug>(easymotion-overwin-f2)'     , 'easymotion-overwin-f2'     )
call s:map_local( 'o.f' , '<Plug>(easymotion-overwin-f)'      , 'easymotion-overwin-f'      )
call s:map_local( 'o.l' , '<Plug>(easymotion-overwin-line)'   , 'easymotion-overwin-line'   )
call s:map_local( 'o.w' , '<Plug>(easymotion-overwin-w)'      , 'easymotion-overwin-w'      )

let g:localleader_map.l = { 'name': '+line' }
call s:map_local( 'l.s' , '<Plug>(easymotion-sl)'             , 'easymotion-sl'             )
call s:map_local( 'l.f' , '<Plug>(easymotion-fl)'             , 'easymotion-fl'             )
call s:map_local( 'l.F' , '<Plug>(easymotion-Fl)'             , 'easymotion-Fl'             )
call s:map_local( 'l.t' , '<Plug>(easymotion-tl)'             , 'easymotion-tl'             )
call s:map_local( 'l.T' , '<Plug>(easymotion-Tl)'             , 'easymotion-Tl'             )

let g:localleader_map.n = { 'name': '+anychars' }
call s:map_local( 'n.s' , '<Plug>(easymotion-sn)'             , 'easymotion-sn'             )
call s:map_local( 'n.f' , '<Plug>(easymotion-fn)'             , 'easymotion-fn'             )
call s:map_local( 'n.F' , '<Plug>(easymotion-Fn)'             , 'easymotion-Fn'             )
call s:map_local( 'n.t' , '<Plug>(easymotion-tn)'             , 'easymotion-tn'             )
call s:map_local( 'n.T' , '<Plug>(easymotion-Tn)'             , 'easymotion-Tn'             )

let g:localleader_map.l.n = { 'name': '+anychars' }
call s:map_local( 'l.n.s' , '<Plug>(easymotion-sln)'          , 'easymotion-sln'            )
call s:map_local( 'l.n.f' , '<Plug>(easymotion-fln)'          , 'easymotion-fln'            )
call s:map_local( 'l.n.F' , '<Plug>(easymotion-Fln)'          , 'easymotion-Fln'            )
call s:map_local( 'l.n.t' , '<Plug>(easymotion-tln)'          , 'easymotion-tln'            )
call s:map_local( 'l.n.T' , '<Plug>(easymotion-Tln)'          , 'easymotion-Tln'            )

let g:localleader_map.n.l = { 'name': '+line' }
call s:map_local( 'n.l.s' , '<Plug>(easymotion-sln)'          , 'easymotion-sln'            )
call s:map_local( 'n.l.f' , '<Plug>(easymotion-fln)'          , 'easymotion-fln'            )
call s:map_local( 'n.l.F' , '<Plug>(easymotion-Fln)'          , 'easymotion-Fln'            )
call s:map_local( 'n.l.t' , '<Plug>(easymotion-tln)'          , 'easymotion-tln'            )
call s:map_local( 'n.l.T' , '<Plug>(easymotion-Tln)'          , 'easymotion-Tln'            )
