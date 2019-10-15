nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>

" Escape
"inoremap <C-Space> <Esc><Esc>
inoremap <C-c> <Esc><Esc>

" 端末ジョブモード→端末ノーマルモードへの移行
tnoremap <C-Space> <C-\><C-n>
tnoremap <C-c><C-c> <C-\><C-n>

" gtags
nnoremap <C-\> :<C-u>GtagsCursor<CR>

" Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l へのカーソル移動キーバインド
let s:step = 5

function! s:map_arrow(mode, step) abort
  execute a:mode . 'noremap <C-j> ' . a:step . '<Down>'
  execute a:mode . 'noremap <C-k> ' . a:step . '<Up>'
  execute a:mode . 'noremap <C-h> ' . a:step . '<Left>'
  execute a:mode . 'noremap <C-l> ' . a:step . '<Right>'
endfunction

call s:map_arrow('n', s:step)
call s:map_arrow('v', s:step)
call s:map_arrow('i', '')

" Altキーバインド
for i in [1,2,3,4,5,6,7,8,9]
  execute 'nnoremap <A-'.i.'>' ':<C-u>'.i.'wincmd w<CR>'
endfor

nnoremap <A-j>        <C-w>j
nnoremap <A-k>        <C-w>k
nnoremap <A-h>        <C-w>h
nnoremap <A-l>        <C-w>l
nnoremap <A-t>        <C-w>t
nnoremap <A-b>        <C-w>b
nnoremap <A-w>        <C-w>w
nnoremap <A-W>        <C-w>W
nnoremap <A-p>        <C-w>p
nnoremap <A-P>        <C-w>P
nnoremap <A-s>        <C-w>s
nnoremap <A-v>        <C-w>v

nnoremap <A-Down>     <C-w>-
nnoremap <A-up>       <C-w>+
nnoremap <A-Left>     <C-w><
nnoremap <A-Right>    <C-w>>

nnoremap <C-A-j>      :<C-u>SwitchHeight -1<CR>
nnoremap <C-A-k>      :<C-u>SwitchHeight 1<CR>
nnoremap <C-A-h>      :<C-u>SwitchWidth -1<CR>
nnoremap <C-A-l>      :<C-u>SwitchWidth 1<CR>

" ale
imap     <C-Space> <Plug>(ale_complete)
nmap     <C-Down>  <Plug>(ale_next_wrap)
nmap     <C-Up>    <Plug>(ale_previous_wrap)
nmap     <C-Left>  <Plug>(ale_first)
nmap     <C-Right> <Plug>(ale_last)

" <Space>
"nmap <Space> [space]
"nnoremap [space] <Nop>

" " <Space>?
" nnoremap <leader>? :<C-u>edit ~/.config/vim/map.vim<CR>

" " <Space>q
" nnoremap <silent> <leader>qq :<C-u>qa<CR>
" nnoremap <silent> <leader>qy :<C-u>qa!<CR>
" nnoremap <silent> <leader>qw :<C-u>q<CR>

" " <Space>r
" nnoremap <leader>r <C-l>

" " <Space>w
" nnoremap <leader>w <C-w>
" nnoremap <leader>wt :<C-u>vsplit<CR>:<C-u>terminal<CR>
" nnoremap <leader>wT :<C-u>split<CR>:<C-u>terminal<CR>
"
" for i in [1,2,3,4,5,6,7,8,9]
"   execute('nnoremap <silent> <leader>' . i . ' :<C-u>' . i . 'wincmd w<CR>')
" endfor

" " <Space>f
" nnoremap <silent> <leader>fj :<C-u>call EnterDefaultDefx()<CR>
" nnoremap <silent> <leader>fo :<C-u>Denite file/old<CR>
" nnoremap <silent> <leader>fbb :<C-u>Denite buffer<CR>
"
" nnoremap <silent> <leader>fg :<C-u>Denite grep -buffer-name=denite-search<CR>
" nnoremap <silent> <leader>fwg :<C-u>DeniteCursorWord grep -buffer-name=denite-search<CR>
" nnoremap <silent> <leader>fbg :<C-u>Denite -resume -buffer-name=denite-search<CR>
"
" nnoremap <silent> <leader>fF :<C-u>Denite file -buffer-name=denite-file<CR>
" nnoremap <silent> <leader>ff :<C-u>Denite file/rec -buffer-name=denite-file<CR>
" nnoremap <silent> <leader>fh :<C-u>Denite file/rec:~ -buffer-name=denite-file<CR>
" nnoremap <silent> <leader>fc :<C-u>Denite file/rec:~/.config/vim -buffer-name=denite-file<CR>
" nnoremap <silent> <leader>fwf :<C-u>DeniteCursorWord file/rec -buffer-name=denite-file<CR>
" nnoremap <silent> <leader>fbf :<C-u>Denite -resume -buffer-name=denite-file<CR>
"
" nnoremap <silent> <leader>fzf :<C-u>FZF<CR>
" nnoremap <silent> <leader>fzh :<C-u>FZF ~<CR>

" " <Space>u
" nnoremap <silent> <leader>ue :<C-u>%s/\s\+$//gc<CR>

" " <Space><Tab>
" nnoremap <silent> <leader><Tab>n :<C-u>tabnew<CR>:<C-u>call EnterDefaultDefx()<CR>
" nnoremap <silent> <leader><Tab>N :<C-u>tabnew<CR>
" nnoremap <silent> <leader><Tab>j :<C-u>$tabnext<CR>
" nnoremap <silent> <leader><Tab>k :<C-u>1tabnext<CR>
" nnoremap <silent> <leader><Tab>h :<C-u>-tabnext<CR>
" nnoremap <silent> <leader><Tab>l :<C-u>+tabnext<CR>
" nnoremap <silent> <leader><Tab>J :<C-u>0tabmove<CR>
" nnoremap <silent> <leader><Tab>K :<C-u>$tabmove<CR>
" nnoremap <silent> <leader><Tab>H :<C-u>-tabmove<CR>
" nnoremap <silent> <leader><Tab>L :<C-u>+tabmove<CR>
" nnoremap <silent> <leader><Tab>c :<C-u>tabclose<CR>
" nnoremap <silent> <leader><Tab>q :<C-u>tabclose!<CR>
"
" for i in range(1, 9)
"   execute 'nnoremap <silent> <leader><Tab>'.i ':<C-u>'.i.'tabnext<CR>'
" endfor
"
" nnoremap <silent> <leader><Tab><Tab> :<C-u>tabnew<CR>:<C-u>terminal<CR>

" " <Space>t
" nnoremap <silent> <leader>tn :<C-u>TestNearest<CR>
" nnoremap <silent> <leader>tf :<C-u>TestFile<CR>
" nnoremap <silent> <leader>ts :<C-u>TestSuite<CR>
" nnoremap <silent> <leader>tl :<C-u>TestLast<CR>
" nnoremap <silent> <leader>tv :<C-u>TestVisit<CR>

" " <Space>g
" nmap <leader>g [git]
" nnoremap [git] <Nop>
"
" nnoremap <silent> [git]s  :<C-u>Gstatus<CR>
" nnoremap <silent> [git]r  :<C-u>Gread<CR>
" nnoremap <silent> [git]w  :<C-u>Gwrite<CR>
" nnoremap <silent> [git]d  :<C-u>Gdiff<CR>
" nnoremap <silent> [git]m  :<C-u>Gmerge<CR>
" nnoremap <silent> [git]c  :<C-u>Gcommit<CR>
" nnoremap <silent> [git]M  :<C-u>Gmove<CR>
" nnoremap <silent> [git]R  :<C-u>Gremove<CR>
" nnoremap <silent> [git]t  :<C-u>GitGutterToggle<CR>

" " <Space>G
" nnoremap <silent> <leader>Gd :<C-u>DeniteCursorWord -buffer-name=gtags_def gtags_def<CR>
" nnoremap <silent> <leader>Gr :<C-u>DeniteCursorWord -buffer-name=gtags_ref gtags_ref<CR>
" nnoremap <silent> <leader>Gx :<C-u>DeniteCursorWord -buffer-name=gtags_context gtags_context<CR>
" nnoremap <silent> <leader>Gg :<C-u>DeniteCursorWord -buffer-name=gtags_grep gtags_grep<CR>
" nnoremap <silent> <leader>Gc :<C-u>Denite -buffer-name=gtags_completion gtags_completion<CR>
" nnoremap <silent> <leader>Gf :<C-u>Denite -buffer-name=gtags_file gtags_file<CR>
" nnoremap <silent> <leader>GF :<C-u>Denite -buffer-name=gtags_files gtags_files<CR>
"
" nnoremap <silent> <leader>Gbd :<C-u>Denite -resume -buffer-name=gtags_def<CR>
" nnoremap <silent> <leader>Gbr :<C-u>Denite -resume -buffer-name=gtags_ref<CR>
" nnoremap <silent> <leader>Gbx :<C-u>Denite -resume -buffer-name=gtags_context<CR>
" nnoremap <silent> <leader>Gbg :<C-u>Denite -resume -buffer-name=gtags_grep<CR>
" nnoremap <silent> <leader>Gbc :<C-u>Denite -resume -buffer-name=gtags_completion<CR>
" nnoremap <silent> <leader>Gbf :<C-u>Denite -resume -buffer-name=gtags_file<CR>
" nnoremap <silent> <leader>GbF :<C-u>Denite -resume -buffer-name=gtags_files<CR>
"
" nnoremap <silent> <leader>GGc :<C-u>GtagsCursor<CR>
" nnoremap <silent> <leader>GGf :<C-u>Gtags -f %<CR>

" " <Space>a
" nmap <leader><Space> [ale]
" nnoremap [ale] <Nop>
"
" nnoremap <silent> [ale]i  :<C-u>ALEInfo<CR>
" nmap     <silent> [ale]o  <Plug>(ale_hover)
" nmap     <silent> [ale]p  <Plug>(ale_documentation)
" nnoremap <silent> [ale]R  :<C-u>ALERename<CR>
" nmap     <silent> [ale]l  <Plug>(ale_lint)
" nmap     <silent> [ale]m  <Plug>(ale_detail)
" nmap     <silent> [ale]r  <Plug>(ale_find_references)
" nmap     <silent> [ale]f  <Plug>(ale_fix)
"
" nmap     <silent> [ale]dj <Plug>(ale_go_to_definition)
" nmap     <silent> [ale]ds <Plug>(ale_go_to_definition_in_split)
" nmap     <silent> [ale]dv <Plug>(ale_go_to_definition_in_vsplit)
" nmap     <silent> [ale]tj <Plug>(ale_go_to_type_definition)
" nmap     <silent> [ale]ts <Plug>(ale_go_to_type_definition_in_split)
" nmap     <silent> [ale]tv <Plug>(ale_go_to_type_definition_in_vsplit)
"
" nmap     <silent> [ale]ej <Plug>(ale_next_wrap_error)
" nmap     <silent> [ale]ek <Plug>(ale_previous_wrap_error)
" nmap     <silent> [ale]wj <Plug>(ale_next_wrap_warning)
" nmap     <silent> [ale]wk <Plug>(ale_previous_wrap_warning)
"
" nmap     <silent> [ale]qr <Plug>(ale_reset_buffer)
" nmap     <silent> [ale]qR <Plug>(ale_reset)
" nmap     <silent> [ale]qt <Plug>(ale_toggle_buffer)
" nmap     <silent> [ale]qT <Plug>(ale_toggle)
" nmap     <silent> [ale]qd <Plug>(ale_disable_buffer)
" nmap     <silent> [ale]qD <Plug>(ale_disable)
" nmap     <silent> [ale]qe <Plug>(ale_enable_buffer)
" nmap     <silent> [ale]qE <Plug>(ale_enable)

" imap     <silent> <C-Space> <Plug>(ale_complete)
" nmap     <silent> <C-Down>  <Plug>(ale_next_wrap)
" nmap     <silent> <C-Up>    <Plug>(ale_previous_wrap)
" nmap     <silent> <C-Left>  <Plug>(ale_first)
" nmap     <silent> <C-Right> <Plug>(ale_last)
