call which_key#register('<Space>', 'g:leader_map')
call which_key#register(',', 'g:localleader_map')

let s:spkey_dict = {
      \ '<Space>': ' ',
      \ '<Bar>'  : '|',
      \ }
function! s:_map(key, cmd, desc, prefix, local) abort
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
  if a:cmd =~? '^<'
    let mapcmd = 'map'
    let cmd = a:cmd
  else
    let mapcmd = 'noremap'
    let cmd = ':<C-u>'.a:cmd.'<CR>'
  endif
  let mapcmd = a:prefix.mapcmd
  execute mapcmd '<silent>' mapped_keys cmd
  if empty(a:desc)
    let m[key] = 'which_key_ignore'
  else
    let m[key] = a:desc
  endif
endfunction

function! s:nmap(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'n', 0)
endfunction

function! s:lnmap(key, cmd, desc) abort
  call s:_map(a:key, a:cmd, a:desc, 'n', 1)
endfunction

let g:leader_map = { '1-9': 'switch-window' }
for i in [1,2,3,4,5,6,7,8,9]
  call s:nmap(i, i.'wincmd w', '')
endfor
call s:nmap('r' ,'redraw!', 'refresh')

let g:leader_map.w = { 'name': '+window' }
call s:nmap('w.q'     , 'quit'              , 'quit'               )
call s:nmap('w.Q'     , 'quit!'             , 'force-quit'         )
call s:nmap('w.c'     , 'close'             , ''                   )
call s:nmap('w.n'     , 'new'               , 'new'                )
call s:nmap('w.s'     , 'split'             , 'horizental-split'   )
call s:nmap('w.S'     , 'new'               , 'horizental-new'     )
call s:nmap('w.v'     , 'vsplit'            , 'vertical-split'     )
call s:nmap('w.V'     , 'vnew'              , 'vertical-new'       )
call s:nmap('w.o'     , 'only'              , 'only'               )
call s:nmap('w.j'     , 'wincmd j'          , 'go-below'           )
call s:nmap('w.k'     , 'wincmd k'          , 'go-up'              )
call s:nmap('w.h'     , 'wincmd h'          , 'go-left'            )
call s:nmap('w.l'     , 'wincmd l'          , 'go-right'           )
call s:nmap('w.t'     , 'wincmd t'          , 'go-top'             )
call s:nmap('w.b'     , 'wincmd b'          , 'go-bottom'          )
call s:nmap('w.w'     , 'wincmd w'          , 'go-next'            )
call s:nmap('w.W'     , 'wincmd W'          , 'go-previous'        )
call s:nmap('w.p'     , 'wincmd p'          , 'go-previous-active' )
call s:nmap('w.P'     , 'wincmd P'          , 'go-preview'         )
call s:nmap('w.J'     , 'SwitchHeight -1'   , 'switch-height -'    )
call s:nmap('w.K'     , 'SwitchHeight 1'    , 'switch-height +'    )
call s:nmap('w.H'     , 'SwitchWidth -1'    , 'switch-width -'     )
call s:nmap('w.L'     , 'SwitchWidth 1'     , 'switch-width +'     )
call s:nmap('w._'     , 'wincmd _'          , 'expand-height-max'  )
call s:nmap('w.<Bar>' , 'wincmd <Bar>'      , 'expand-width-max'   )
call s:nmap('w.='     , 'wincmd ='          , 'balance-windows'    )
call s:nmap('w.T'     , 'terminal'          , 'terminal'           )

let g:leader_map.t = { 'name': '+tab', '1-9': 'switch-tab' }
for i in [1,2,3,4,5,6,7,8,9]
  call s:nmap('t.'.i, i.'tabnext', '')
endfor
call s:nmap('t.t' , 'call TabNewWithTerminal()' , 'new-terminal'  )
call s:nmap('t.n' , 'call TabNewWithDefx()'     , 'new-defx'      )
call s:nmap('t.N' , 'tabnew'                    , 'new'           )
call s:nmap('t.j' , '$tabnext'                  , 'go-last'       )
call s:nmap('t.k' , '1tabnext'                  , 'go-first'      )
call s:nmap('t.h' , '-tabnext'                  , 'go-previous'   )
call s:nmap('t.l' , '+tabnext'                  , 'go-next'       )
call s:nmap('t.J' , '0tabmove'                  , 'move-first'    )
call s:nmap('t.K' , '$tabmove'                  , 'move-last'     )
call s:nmap('t.H' , '-tabmove'                  , 'move-previous' )
call s:nmap('t.L' , '+tabmove'                  , 'move-next'     )
call s:nmap('t.q' , 'tabclose'                  , 'close'         )
call s:nmap('t.Q' , 'tabclose!'                 , 'force-close'   )

let g:leader_map[' '] = { 'name': '+coc' }
call s:nmap('<Space>.<Space>' , 'CocList'                           , 'coc-list'                    )
call s:nmap('<Space>.I'       , '<Plug>(coc-diagnostic-info)'       , 'show-diagnostic-message'     )
call s:nmap('<Space>.m'       , '<Plug>(coc-diagnostic-next)'       , 'jump-to-next-diagnostic'     )
call s:nmap('<Space>.M'       , '<Plug>(coc-diagnostic-prev)'       , 'jump-to-previous-diagnostic' )
call s:nmap('<Space>.e'       , '<Plug>(coc-diagnostic-next-error)' , 'jump-to-next-error'          )
call s:nmap('<Space>.E'       , '<Plug>(coc-diagnostic-prev-error)' , 'jump-to-previous-error'      )
call s:nmap('<Space>.d'       , '<Plug>(coc-definition)'            , 'jump-to-definition'          )
call s:nmap('<Space>.D'       , '<Plug>(coc-declaration)'           , 'jump-to-declaration'         )
call s:nmap('<Space>.i'       , '<Plug>(coc-implementaion)'         , 'jump-to-implementaion'       )
call s:nmap('<Space>.t'       , '<Plug>(coc-type-definition)'       , 'jump-to-type-declaration'    )
call s:nmap('<Space>.r'       , '<Plug>(coc-reference)'             , 'jump-to-reference'           )
call s:nmap('<Space>.F'       , '<Plug>(coc-format-selected)'       , 'format-selected-range'       )
call s:nmap('<Space>.f'       , '<Plug>(coc-format)'                , 'format'                      )
call s:nmap('<Space>.R'       , '<Plug>(coc-rename)'                , 'rename-symbol'               )
call s:nmap('<Space>.a'       , 'CocAction'                         , 'coc-action'                  )
call s:nmap('<Space>.l'       , '<Plug>(coc-openlink)'              , 'open-link'                   )
call s:nmap('<Space>.q'       , '<Plug>(coc-fix-current)'           , 'quickfix-action'             )

let g:leader_map[' '].o = { 'name': '+output' }
call s:nmap('<Space>.o.i'     , 'CocInfo'                           , 'coc-info'                    )
call s:nmap('<Space>.o.l'     , 'CocOpenLog'                        , 'coc-open-log'                )

let g:leader_map[' '].w = { 'name': '+window' }
call s:nmap('<Space>.w.q'     , '<Plug>(coc-float-hide)'            , 'hide-all-float-window'       )
call s:nmap('<Space>.w.j'     , '<Plug>(coc-float-jump)'            , 'jump-to-first-float-window'  )
call s:nmap('<Space>.w.r'     , '<Plug>(coc-refactor)'              , 'refactor'                    )

let g:leader_map[' '].s = { 'name': '+select' }
call s:nmap('<Space>.s.n'     , '<Plug>(coc-range-select)'          , 'select-next-selection-range' )
call s:nmap('<Space>.s.p'     , '<Plug>(coc-range-select-backward)' , 'select-prev-selection-range' )
call s:nmap('<Space>.s.i'     , '<Plug>(coc-funcobj-i)'             , 'select-inside-function'      )
call s:nmap('<Space>.s.a'     , '<Plug>(coc-funcobj-a)'             , 'select-current-function'     )

let g:leader_map[' '].c = { 'name': '+config' }
call s:nmap('<Space>.c.j'     , 'CocConfig'                         , 'open-current-window'         )
call s:nmap('<Space>.c.s'     , 'split<CR>:<C-u>CocConfig'          , 'open-horizontal-split'       )
call s:nmap('<Space>.c.v'     , 'vsplit<CR>:<C-u>CocConfig'         , 'open-vertical-split'         )

let g:leader_map.a = { 'name': '+ale' }
call s:nmap('a.i'             , 'ALEInfo'                           , 'info'                        )
call s:nmap('a.o'             , '<Plug>(ale_hover)'                 , 'hover'                       )
call s:nmap('a.p'             , '<Plug>(ale_documentation)'         , 'documentation'               )
call s:nmap('a.R'             , 'ALERename'                         , 'rename'                      )
call s:nmap('a.l'             , '<Plug>(ale_lint)'                  , 'lint'                        )
call s:nmap('a.m'             , '<Plug>(ale_detail)'                , 'detail'                      )
call s:nmap('a.r'             , '<Plug>(ale_find_references)'       , 'find-reference'              )
call s:nmap('a.f'             , '<Plug>(ale_fix)'                   , 'fix'                         )
call s:nmap('a.e'             , '<Plug>(ale_next_wrap_error)'       , 'next-error'                  )
call s:nmap('a.E'             , '<Plug>(ale_previous_wrap_error)'   , 'previous-error'              )
call s:nmap('a.w'             , '<Plug>(ale_next_wrap_warning)'     , 'next-warning'                )
call s:nmap('a.W'             , '<Plug>(ale_previous_wrap_warning)' , 'previous-warning'            )

let g:leader_map.a.d = { 'name': '+go-to-definition' }
call s:nmap('a.d.j'           , '<Plug>(ale_go_to_definition)'          , 'current-window'          )
call s:nmap('a.d.s'           , '<Plug>(ale_go_to_definition_in_split)' , 'horizontal-split'        )
call s:nmap('a.d.v'           , '<Plug>(ale_go_to_definition_in_vsplit)', 'vertical-split'          )

let g:leader_map.a.t = { 'name': '+go-to-type-definition' }
call s:nmap('a.t.j'           , '<Plug>(ale_go_to_type_definition)'           , 'current-window'    )
call s:nmap('a.t.s'           , '<Plug>(ale_go_to_type_definition_in_split)'  , 'horizental-split'  )
call s:nmap('a.t.v'           , '<Plug>(ale_go_to_type_definition_in_vsplit)' , 'vertical-split'    )

let g:leader_map.a.q = { 'name': '+control' }
call s:nmap('a.q.r'           , '<Plug>(ale_reset_buffer)'                    , 'reset-buffer'      )
call s:nmap('a.q.R'           , '<Plug>(ale_reset)'                           , 'reset'             )
call s:nmap('a.q.t'           , '<Plug>(ale_toggle_buffer)'                   , 'toggle-buffer'     )
call s:nmap('a.q.T'           , '<Plug>(ale_toggle)'                          , 'toggle'            )
call s:nmap('a.q.d'           , '<Plug>(ale_disable_buffer)'                  , 'disable-buffer'    )
call s:nmap('a.q.D'           , '<Plug>(ale_disable)'                         , 'disable'           )
call s:nmap('a.q.e'           , '<Plug>(ale_enable_buffer)'                   , 'enable-buffer'     )
call s:nmap('a.q.E'           , '<Plug>(ale_enable)'                          , 'enable'            )

let g:leader_map.f = { 'name': '+file' }
call s:nmap('f.j'  , 'call EnterDefaultDefx()'                                , 'defx'                    )
call s:nmap('f.k'  , 'call EnterDefaultDefxCurrent()'                         , 'defx(current file)'      )
call s:nmap('f.o'  , 'Denite file/old'                                        , 'denite file/old'         )
call s:nmap('f.g'  , 'Denite grep -buffer-name=denite-grep'                   , 'denite grep'             )
call s:nmap('f.F'  , 'Denite file -buffer-name=denite-file'                   , 'denite file'             )
call s:nmap('f.f'  , 'Denite file/rec -buffer-name=denite-file'               , 'denite file/rec'         )
call s:nmap('f.h'  , 'Denite file/rec:~ -buffer-name=denite-file'             , 'denite file/rec:~'       )
call s:nmap('f.d'  , 'Denite coc-diagnostic -buffer-name=denite-coc-diagnostic' , 'coc-diagnostic'        )
call s:nmap('f.l'  , 'Denite coc-symbols -buffer-name=denite-coc-symbols'       , 'coc-symbols'           )
call s:nmap('f.L'  , 'Denite coc-workspace -buffer-name=denite-coc-workspace'   , 'coc-workspace'         )
call s:nmap('f.s'  , 'Denite coc-source -buffer-name=denite-coc-source'         , 'coc-source'            )
call s:nmap('f.S'  , 'Denite coc-service -buffer-name=denite-coc-service'       , 'coc-service'           )
call s:nmap('f.c'  , 'Denite coc-command -buffer-name=denite-coc-command'       , 'coc-command'           )

let g:leader_map.f.w = { 'name': '+cursor-word' }
call s:nmap('f.w.g', 'DeniteCursorWord grep -buffer-name=denite-grep'         , 'denite grep'             )
call s:nmap('f.w.f', 'DeniteCursorWord file/rec -buffer-name=denite-file'     , 'denite file/rec'         )

let g:leader_map.f.z = { 'name': '+fzf' }
call s:nmap('f.z.f', 'FZF'    , 'fzf'   )
call s:nmap('f.z.h', 'FZF ~'  , 'fzf ~' )

let g:leader_map.b = { 'name': '+buffer' }
call s:nmap('b.b'  , 'Denite buffer'                                          , 'buffer'            )
call s:nmap('b.g'  , 'Denite -resume -buffer-name=denite-grep'                , 'grep'              )
call s:nmap('b.f'  , 'Denite -resume -buffer-name=denite-file'                , 'file'              )

let g:leader_map.b.G = { 'name': '+gtags' }
call s:nmap('b.G.d', 'Denite -resume -buffer-name=gtags_def'                  , 'definition'        )
call s:nmap('b.G.r', 'Denite -resume -buffer-name=gtags_ref'                  , 'reference'         )
call s:nmap('b.G.x', 'Denite -resume -buffer-name=gtags_context'              , 'context'           )
call s:nmap('b.G.g', 'Denite -resume -buffer-name=gtags_grep'                 , 'grep'              )
call s:nmap('b.G.c', 'Denite -resume -buffer-name=gtags_completion'           , 'completion'        )
call s:nmap('b.G.f', 'Denite -resume -buffer-name=gtags_file'                 , 'file'              )
call s:nmap('b.G.F', 'Denite -resume -buffer-name=gtags_files'                , 'files'             )

let g:leader_map.g = { 'name': '+git' }
call s:nmap('g.s' , 'Gstatus'         , 'status'        )
call s:nmap('g.r' , 'Gread'           , 'read'          )
call s:nmap('g.w' , 'Gwrite'          , 'write'         )
call s:nmap('g.d' , 'Gdiff'           , 'diff'          )
call s:nmap('g.m' , 'Gmerge'          , 'merge'         )
call s:nmap('g.c' , 'Gcommit'         , 'commit'        )
call s:nmap('g.M' , 'Gmove'           , 'move'          )
call s:nmap('g.R' , 'Gremove'         , 'remove'        )
call s:nmap('g.t' , 'GitGutterToggle' , 'gutter-toggle' )

let g:leader_map.G = { 'name': '+gtags' }
call s:nmap('G.d' , 'DeniteCursorWord -buffer-name=gtags_def gtags_def'         , 'definition-of-tag'               )
call s:nmap('G.r' , 'DeniteCursorWord -buffer-name=gtags_ref gtags_ref'         , 'reference-to-tag'                )
call s:nmap('G.x' , 'DeniteCursorWord -buffer-name=gtags_context gtags_context' , 'definition/reference-to-tag'     )
call s:nmap('G.g' , 'DeniteCursorWord -buffer-name=gtags_grep gtags_grep'       , 'grep-search-of-tag'              )
call s:nmap('G.c' , 'Denite -buffer-name=gtags_completion gtags_completion'     , 'list-all-tags'                   )
call s:nmap('G.f' , 'Denite -buffer-name=gtags_file gtags_file'                 , 'list-all-tags-in-file'           )
call s:nmap('G.F' , 'Denite -buffer-name=gtags_files gtags_files'               , 'list-all-tags-under-current-dir' )
call s:nmap('G.D' , 'GtagsCursor'                                               , 'go-to-definition(quickfix)'      )
call s:nmap('G.G' , 'Gtags -f %'                                                , 'generate-gtags'                  )

" same as <leader>bg
let g:leader_map.G.b = { 'name': '+buffer' }
call s:nmap('G.b.d' , 'Denite -resume -buffer-name=gtags_def'        , 'definition' )
call s:nmap('G.b.r' , 'Denite -resume -buffer-name=gtags_ref'        , 'reference'  )
call s:nmap('G.b.x' , 'Denite -resume -buffer-name=gtags_context'    , 'context'    )
call s:nmap('G.b.g' , 'Denite -resume -buffer-name=gtags_grep'       , 'grep'       )
call s:nmap('G.b.c' , 'Denite -resume -buffer-name=gtags_completion' , 'completion' )
call s:nmap('G.b.f' , 'Denite -resume -buffer-name=gtags_file'       , 'file'       )
call s:nmap('G.b.F' , 'Denite -resume -buffer-name=gtags_files'      , 'files'      )

let g:leader_map.T = { 'name': '+test' }
call s:nmap('T.n'   , 'TestNearest' , 'nearest' )
call s:nmap('T.f'   , 'TestFile'    , 'file'    )
call s:nmap('T.s'   , 'TestSuite'   , 'suite'   )
call s:nmap('T.l'   , 'TestLast'    , 'last'    )
call s:nmap('T.v'   , 'TestVisit'   , 'visit'   )

let g:leader_map.q = { 'name': '+quit' }
call s:nmap('q.q'   , 'quitall'     , 'quit-all'          )
call s:nmap('q.Q'   , 'quitall!'    , 'force-quit-all'    )
call s:nmap('q.w'   , 'quit'        , 'quit-window'       )
call s:nmap('q.W'   , 'quit!'       , 'force-quit-window' )
call s:nmap('q.t'   , 'tabclose'    , 'quit-tab'          )
call s:nmap('q.T'   , 'tabclose!'   , 'force-quit-tab'    )

let g:localleader_map = {}
call s:lnmap('s'      , '<Plug>(easymotion-s2)'         , 'easymotion-s2'         )
call s:lnmap('f'      , '<Plug>(easymotion-f2)'         , 'easymotion-f2'         )
call s:lnmap('F'      , '<Plug>(easymotion-F2)'         , 'easymotion-F2'         )
call s:lnmap('t'      , '<Plug>(easymotion-t2)'         , 'easymotion-t2'         )
call s:lnmap('T'      , '<Plug>(easymotion-T2)'         , 'easymotion-T2'         )
call s:lnmap('j'      , '<Plug>(easymotion-sol-j)'      , 'easymotion-sol-j'      )
call s:lnmap('J'      , '<Plug>(easymotion-eol-j)'      , 'easymotion-eol-j'      )
call s:lnmap('k'      , '<Plug>(easymotion-sol-k)'      , 'easymotion-sol-k'      )
call s:lnmap('K'      , '<Plug>(easymotion-eol-k)'      , 'easymotion-eol-k'      )
call s:lnmap('m'      , '<Plug>(easymotion-sol-bd-jk)'  , 'easymotion-sol-bd-jk'  )
call s:lnmap('<Dot>'  , '<Plug>(easymotion-eol-bd-jk)'  , 'easymotion-eol-bd-jk'  )
call s:lnmap('w'      , '<Plug>(easymotion-bd-w)'       , 'easymotion-bd-w'       )
call s:lnmap('W'      , '<Plug>(easymotion-bd-W)'       , 'easymotion-bd-W'       )
call s:lnmap('e'      , '<Plug>(easymotion-bd-e)'       , 'easymotion-bd-e'       )
call s:lnmap('E'      , '<Plug>(easymotion-bd-E)'       , 'easymotion-bd-E'       )
call s:lnmap('r'      , '<Plug>(easymotion-repeat)'     , 'easymotion-repeat'     )
call s:lnmap('n'      , '<Plug>(easymotion-n)'          , 'easymotion-n'          )
call s:lnmap('N'      , '<Plug>(easymotion-N)'          , 'easymotion-N'          )

let g:localleader_map[','] = { 'name': '+additional' }
call s:lnmap(',.s'    , '<Plug>(easymotion-s)'            , 'easymotion-s'            )
call s:lnmap(',.f'    , '<Plug>(easymotion-f)'            , 'easymotion-f'            )
call s:lnmap(',.F'    , '<Plug>(easymotion-F)'            , 'easymotion-F'            )
call s:lnmap(',.t'    , '<Plug>(easymotion-t)'            , 'easymotion-t'            )
call s:lnmap(',.T'    , '<Plug>(easymotion-T)'            , 'easymotion-T'            )
call s:lnmap(',.w'    , '<Plug>(easymotion-w)'            , 'easymotion-w'            )
call s:lnmap(',.W'    , '<Plug>(easymotion-W)'            , 'easymotion-W'            )
call s:lnmap(',.b'    , '<Plug>(easymotion-b)'            , 'easymotion-b'            )
call s:lnmap(',.B'    , '<Plug>(easymotion-B)'            , 'easymotion-B'            )
call s:lnmap(',.e'    , '<Plug>(easymotion-e)'            , 'easymotion-e'            )
call s:lnmap(',.E'    , '<Plug>(easymotion-E)'            , 'easymotion-E'            )
call s:lnmap(',.ge'   , '<Plug>(easymotion-ge)'           , 'easymotion-ge'           )
call s:lnmap(',.gE'   , '<Plug>(easymotion-gE)'           , 'easymotion-gE'           )
call s:lnmap(',.j'    , '<Plug>(easymotion-sol-j)'        , 'easymotion-sol-j'        )
call s:lnmap(',.k'    , '<Plug>(easymotion-sol-k)'        , 'easymotion-sol-k'        )
call s:lnmap(',.J'    , '<Plug>(easymotion-eol-j)'        , 'easymotion-eol-j'        )
call s:lnmap(',.k'    , '<Plug>(easymotion-eol-k)'        , 'easymotion-eol-k'        )

let g:localleader_map.o = { 'name': '+overwin' }
call s:lnmap('o.s'    , '<Plug>(easymotion-overwin-f2)'   , 'easymotion-overwin-f2'   )
call s:lnmap('o.f'    , '<Plug>(easymotion-overwin-f)'    , 'easymotion-overwin-f'    )
call s:lnmap('o.l'    , '<Plug>(easymotion-overwin-line)' , 'easymotion-overwin-line' )
call s:lnmap('o.w'    , '<Plug>(easymotion-overwin-w)'    , 'easymotion-overwin-w'    )

let g:localleader_map.l = { 'name': '+line' }
call s:lnmap('l.s'    , '<Plug>(easymotion-sl)'           , 'easymotion-sl'           )
call s:lnmap('l.f'    , '<Plug>(easymotion-fl)'           , 'easymotion-fl'           )
call s:lnmap('l.F'    , '<Plug>(easymotion-Fl)'           , 'easymotion-Fl'           )
call s:lnmap('l.t'    , '<Plug>(easymotion-tl)'           , 'easymotion-tl'           )
call s:lnmap('l.T'    , '<Plug>(easymotion-Tl)'           , 'easymotion-Tl'           )

let g:localleader_map.a = { 'name': '+anychars' }
call s:lnmap('a.s'    , '<Plug>(easymotion-sn)'           , 'easymotion-sn'           )
call s:lnmap('a.f'    , '<Plug>(easymotion-fn)'           , 'easymotion-fn'           )
call s:lnmap('a.F'    , '<Plug>(easymotion-Fn)'           , 'easymotion-Fn'           )
call s:lnmap('a.t'    , '<Plug>(easymotion-tn)'           , 'easymotion-tn'           )
call s:lnmap('a.T'    , '<Plug>(easymotion-Tn)'           , 'easymotion-Tn'           )

let g:localleader_map.l.a = { 'name': '+anychars' }
call s:lnmap('l.a.s'  , '<Plug>(easymotion-sln)'          , 'easymotion-sln'          )
call s:lnmap('l.a.f'  , '<Plug>(easymotion-fln)'          , 'easymotion-fln'          )
call s:lnmap('l.a.F'  , '<Plug>(easymotion-Fln)'          , 'easymotion-Fln'          )
call s:lnmap('l.a.t'  , '<Plug>(easymotion-tln)'          , 'easymotion-tln'          )
call s:lnmap('l.a.T'  , '<Plug>(easymotion-Tln)'          , 'easymotion-Tln'          )

let g:localleader_map.a.l = { 'name': '+line' }
call s:lnmap('a.l.s'  , '<Plug>(easymotion-sln)'          , 'easymotion-sln'          )
call s:lnmap('a.l.f'  , '<Plug>(easymotion-fln)'          , 'easymotion-fln'          )
call s:lnmap('a.l.F'  , '<Plug>(easymotion-Fln)'          , 'easymotion-Fln'          )
call s:lnmap('a.l.t'  , '<Plug>(easymotion-tln)'          , 'easymotion-tln'          )
call s:lnmap('a.l.T'  , '<Plug>(easymotion-Tln)'          , 'easymotion-Tln'          )
