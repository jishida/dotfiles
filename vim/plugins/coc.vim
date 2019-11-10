if exists('g:coc_conf_loaded')
  finish
endif
let g:coc_conf_loaded = 1

call dein#source([ 'coc.nvim' ])

call coc#config('list.insertMappings', {
      \   '<C-c>': 'do:exit',
      \   '<C-j>': 'do:next',
      \   '<C-k>': 'do:previous',
      \ })
call coc#config('list.normalMappings', {
      \   '<C-c>':  'do:exit',
      \   'v':      'action:vsplit',
      \   'p':      'action:preview',
      \ })
let s:lsmap = {}

if executable('ccls')
  let s:lsmap['ccls'] = {
        \   'command': 'ccls',
        \   'filetypes': [ 'c', 'cpp' ],
        \   'rootPatterns': [ '.ccls', '.git' ],
        \   'initializationOptions': {
        \     'cache': {
        \       'directory': '/tmp/ccls',
        \     },
        \   },
        \ }
endif

if executable('kotlin-language-server')
  let s:lsmap['kotlin'] = {
        \   'command': 'kotlin-language-server',
        \   'filetypes': [ 'kotlin' ],
        \   'rootPatterns': [ 'gradlew' ],
        \ }
endif

if executable('gopls')
  let s:lsmap['golang'] = {
        \   'command': 'gopls',
        \   'filetypes': [ 'go' ],
        \   'rootPatterns': [ 'go.mod' ],
        \ }
endif

call coc#config('languageserver', s:lsmap)

function! InitCocExtension() abort
  call coc#add_extension(
        \   'coc-json',
        \   'coc-python',
        \   'coc-tsserver',
        \   'coc-yaml',
        \   'coc-rls',
        \ )
endfunction
