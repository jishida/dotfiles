set number
set tabstop=2
set shiftwidth=2
set expandtab
set splitright
set clipboard=unnamed
set hls
set cursorline
set helplang=ja
set laststatus=2
set backspace=start,indent,eol
set fenc=utf-8
set list
set listchars=tab:^\ ,trail:\ ,eol:↲,extends:»,precedes:«,nbsp:%

set confirm
set hidden
set autoread
set nobackup
set noswapfile

set timeoutlen=500
let g:mapleader = "\<Space>"

let g:netrw_liststyle=3
let g:netrw_preview=1
let g:netrw_browse_split=1

" swlen
let g:swlen#default_column_end_ratio = 0.5
let g:swlen#default_rows = 3
" let g:swlen#default_row_end_ratio = 0.5

source ~/.config/vim/util.vim
source ~/.config/vim/map.vim
if filereadable(expand('~/.vimrc.local'))
  execute 'source' expand('~/.vimrc.local')
endif

if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if has('nvim')
  let s:dein_env_toml = '~/.config/vim/dein-nvim.toml'
else
  let s:dein_env_toml = '~/.config/vim/dein-vim.toml'
endif
let s:dein_toml = '~/.config/vim/dein.toml'
let s:deinft_toml = '~/.config/vim/deinft.toml'

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein', [expand('<sfile>'), s:dein_env_toml, s:dein_toml, s:deinft_toml])
  call dein#load_toml(s:dein_env_toml)
  call dein#load_toml(s:dein_toml)
  call dein#load_toml(s:deinft_toml)
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on

if dein#check_install()
  call dein#install()
  call dein#remote_plugins()
endif

set background=dark
colorscheme hybrid
syntax enable
