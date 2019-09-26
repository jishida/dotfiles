" Escape
"inoremap <C-Space> <Esc><Esc>
inoremap <C-c> <Esc><Esc>

" 端末ジョブモード→端末ノーマルモードへの移行
tnoremap <C-Space> <C-\><C-n>
tnoremap <C-c><C-c> <C-\><C-n>

" gtags
nnoremap <C-\> :<C-u>GtagsCursor<CR>

" QuickFix
nnoremap <C-n> :<C-u>cn<CR>
nnoremap <C-p> :<C-u>cp<CR>

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
nnoremap <A-Up> <C-w>+
nnoremap <A-Down> <C-w>-
nnoremap <A-Right> <C-w>>
nnoremap <A-Left> <C-w><

nnoremap <A-j> :<C-u>SwitchHeight -1<CR>
nnoremap <A-k> :<C-u>SwitchHeight 1<CR>
nnoremap <A-h> :<C-u>SwitchWidth -1<CR>
nnoremap <A-l> :<C-u>SwitchWidth 1<CR>

" <Space>
nmap <Space> [space]
nnoremap [space] <Nop>

" <Space>?
nnoremap [space]? :<C-u>edit ~/.config/vim/map.vim<CR>

" <Space>q
nnoremap <silent> [space]qq :<C-u>qa<CR>
nnoremap <silent> [space]qy :<C-u>qa!<CR>

" <Space>r
nnoremap [space]r <C-l>

" <Space>c
nnoremap <silent> [space]cq :<C-u>cclose<CR>
nnoremap <silent> [space]co :<C-u>copen<CR>

" <Space>w
nnoremap [space]w <C-w>
nnoremap [space]wt :<C-u>vsplit<CR>:<C-u>terminal<CR>
nnoremap [space]wT :<C-u>split<CR>:<C-u>terminal<CR>

nnoremap <silent> [space]<Tab> :<C-u>wincmd w<CR>
for i in [1,2,3,4,5,6,7,8,9]
  execute('nnoremap <silent> [space]' . i . ' :<C-u>' . i . 'wincmd w<CR>')
endfor

" <Space>f
nnoremap <silent> [space]fj :<C-u>call EnterDefaultDefx()<CR>
nnoremap <silent> [space]fo :<C-u>Denite file/old<CR>
nnoremap <silent> [space]fbb :<C-u>Denite buffer<CR>

nnoremap <silent> [space]fg :<C-u>Denite grep -buffer-name=denite-search<CR>
nnoremap <silent> [space]fwg :<C-u>DeniteCursorWord grep -buffer-name=denite-search<CR>
nnoremap <silent> [space]fbg :<C-u>Denite -resume -buffer-name=denite-search<CR>

nnoremap <silent> [space]fF :<C-u>Denite file -buffer-name=denite-file<CR>
nnoremap <silent> [space]ff :<C-u>Denite file/rec -buffer-name=denite-file<CR>
nnoremap <silent> [space]fh :<C-u>Denite file/rec:~ -buffer-name=denite-file<CR>
nnoremap <silent> [space]fc :<C-u>Denite file/rec:~/.config/vim -buffer-name=denite-file<CR>
nnoremap <silent> [space]fwf :<C-u>DeniteCursorWord file/rec -buffer-name=denite-file<CR>
nnoremap <silent> [space]fbf :<C-u>Denite -resume -buffer-name=denite-file<CR>

nnoremap <silent> [space]fzf :<C-u>FZF<CR>
nnoremap <silent> [space]fzh :<C-u>FZF ~<CR>

" <Space>u
nnoremap <silent> [space]ue :<C-u>%s/\s\+$//gc<CR>

" <Space><Tab>
nnoremap <silent> [space]<Tab>n :<C-u>tabnew<CR>:<C-u>call InitDefaultDefx()<CR>
nnoremap <silent> [space]<Tab>N :<C-u>tabnew<CR>
nnoremap <silent> [space]<Tab>j :<C-u>$tabnext<CR>
nnoremap <silent> [space]<Tab>k :<C-u>1tabnext<CR>
nnoremap <silent> [space]<Tab>h :<C-u>-tabnext<CR>
nnoremap <silent> [space]<Tab>l :<C-u>+tabnext<CR>
nnoremap <silent> [space]<Tab>J :<C-u>0tabmove<CR>
nnoremap <silent> [space]<Tab>K :<C-u>$tabmove<CR>
nnoremap <silent> [space]<Tab>H :<C-u>-tabmove<CR>
nnoremap <silent> [space]<Tab>L :<C-u>+tabmove<CR>
nnoremap <silent> [space]<Tab>c :<C-u>tabclose<CR>
nnoremap <silent> [space]<Tab>q :<C-u>tabclose!<CR>

for i in range(1, 9)
  execute 'nnoremap <silent> [space]<Tab>'.i ':<C-u>'.i.'tabnext<CR>'
endfor

nnoremap <silent> [space]<Tab><Tab> :<C-u>tabnew<CR>:<C-u>terminal<CR>

" <Space>t
nnoremap <silent> [space]tn :<C-u>TestNearest<CR>
nnoremap <silent> [space]tf :<C-u>TestFile<CR>
nnoremap <silent> [space]ts :<C-u>TestSuite<CR>
nnoremap <silent> [space]tl :<C-u>TestLast<CR>
nnoremap <silent> [space]tv :<C-u>TestVisit<CR>

" <Space>g
nmap [space]g [git]
nnoremap [git] <Nop>

nnoremap <silent> [git]s  :<C-u>Gstatus<CR>
nnoremap <silent> [git]r  :<C-u>Gread<CR>
nnoremap <silent> [git]w  :<C-u>Gwrite<CR>
nnoremap <silent> [git]d  :<C-u>Gdiff<CR>
nnoremap <silent> [git]m  :<C-u>Gmerge<CR>
nnoremap <silent> [git]c  :<C-u>Gcommit<CR>
nnoremap <silent> [git]M  :<C-u>Gmove<CR>
nnoremap <silent> [git]R  :<C-u>Gremove<CR>
nnoremap <silent> [git]t  :<C-u>GitGutterToggle<CR>

" <Space>G
nnoremap <silent> [space]Gd :<C-u>DeniteCursorWord -buffer-name=gtags_def gtags_def<CR>
nnoremap <silent> [space]Gr :<C-u>DeniteCursorWord -buffer-name=gtags_ref gtags_ref<CR>
nnoremap <silent> [space]Gx :<C-u>DeniteCursorWord -buffer-name=gtags_context gtags_context<CR>
nnoremap <silent> [space]Gg :<C-u>DeniteCursorWord -buffer-name=gtags_grep gtags_grep<CR>
nnoremap <silent> [space]Gc :<C-u>Denite -buffer-name=gtags_completion gtags_completion<CR>
nnoremap <silent> [space]Gf :<C-u>Denite -buffer-name=gtags_file gtags_file<CR>
nnoremap <silent> [space]GF :<C-u>Denite -buffer-name=gtags_files gtags_files<CR>

nnoremap <silent> [space]Gbd :<C-u>Denite -resume -buffer-name=gtags_def<CR>
nnoremap <silent> [space]Gbr :<C-u>Denite -resume -buffer-name=gtags_ref<CR>
nnoremap <silent> [space]Gbx :<C-u>Denite -resume -buffer-name=gtags_context<CR>
nnoremap <silent> [space]Gbg :<C-u>Denite -resume -buffer-name=gtags_grep<CR>
nnoremap <silent> [space]Gbc :<C-u>Denite -resume -buffer-name=gtags_completion<CR>
nnoremap <silent> [space]Gbf :<C-u>Denite -resume -buffer-name=gtags_file<CR>
nnoremap <silent> [space]GbF :<C-u>Denite -resume -buffer-name=gtags_files<CR>

nnoremap <silent> [space]GGc :<C-u>GtagsCursor<CR>
nnoremap <silent> [space]GGf :<C-u>Gtags -f %<CR>

" <Space>a
nmap [space]<Space> [ale]
nnoremap [ale] <Nop>

nnoremap <silent> [ale]i  :<C-u>ALEInfo<CR>
nmap     <silent> [ale]o  <Plug>(ale_hover)
nmap     <silent> [ale]p  <Plug>(ale_documentation)
nnoremap <silent> [ale]R  :<C-u>ALERename<CR>
nmap     <silent> [ale]l  <Plug>(ale_lint)
nmap     <silent> [ale]m  <Plug>(ale_detail)
nmap     <silent> [ale]r  <Plug>(ale_find_references)
nmap     <silent> [ale]f  <Plug>(ale_fix)

nmap     <silent> [ale]dj <Plug>(ale_go_to_definition)
nmap     <silent> [ale]ds <Plug>(ale_go_to_definition_in_split)
nmap     <silent> [ale]dv <Plug>(ale_go_to_definition_in_vsplit)
nmap     <silent> [ale]tj <Plug>(ale_go_to_type_definition)
nmap     <silent> [ale]ts <Plug>(ale_go_to_type_definition_in_split)
nmap     <silent> [ale]tv <Plug>(ale_go_to_type_definition_in_vsplit)

nmap     <silent> [ale]ej <Plug>(ale_next_wrap_error)
nmap     <silent> [ale]ek <Plug>(ale_previous_wrap_error)
nmap     <silent> [ale]wj <Plug>(ale_next_wrap_warning)
nmap     <silent> [ale]wk <Plug>(ale_previous_wrap_warning)

nmap     <silent> [ale]qr <Plug>(ale_reset_buffer)
nmap     <silent> [ale]qR <Plug>(ale_reset)
nmap     <silent> [ale]qt <Plug>(ale_toggle_buffer)
nmap     <silent> [ale]qT <Plug>(ale_toggle)
nmap     <silent> [ale]qd <Plug>(ale_disable_buffer)
nmap     <silent> [ale]qD <Plug>(ale_disable)
nmap     <silent> [ale]qe <Plug>(ale_enable_buffer)
nmap     <silent> [ale]qE <Plug>(ale_enable)

imap     <silent> <C-Space> <Plug>(ale_complete)
nmap     <silent> <C-Down>  <Plug>(ale_next_wrap)
nmap     <silent> <C-Up>    <Plug>(ale_previous_wrap)
nmap     <silent> <C-Left>  <Plug>(ale_first)
nmap     <silent> <C-Right> <Plug>(ale_last)
