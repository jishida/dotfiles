nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey ','<CR>

" Escape
"inoremap <C-Space> <Esc><Esc>
inoremap <C-c> <Esc><Esc>

" 端末ジョブモード→端末ノーマルモードへの移行
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

" " ale
" nmap     <C-Down>     <Plug>(ale_next_wrap)
" nmap     <C-Up>       <Plug>(ale_previous_wrap)
" nmap     <C-Left>     <Plug>(ale_first)
" nmap     <C-Right>    <Plug>(ale_last)
