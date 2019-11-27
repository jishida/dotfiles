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
call coc#config('python.jediEnabled', 0)

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

if executable('docker-langserver')
  let s:lsmap['dockerfile'] = {
        \   'command': 'docker-langserver',
        \   'filetypes': [ 'dockerfile' ],
        \   'args': [ '--stdio' ],
        \ }
endif

if executable('bash-language-server')
  let s:lsmap['bash'] = {
        \   'command': 'bash-language-server',
        \   'filetypes': [ 'sh' ],
        \   'args': [ 'start' ],
        \   'ignoredRootPaths': [ '-' ],
        \ }
endif

if executable('efm-langserver')
  let s:efm_filetypes = []

  if executable('vint')
    call add(s:efm_filetypes, 'vim')
  endif

  if executable('markdownlint')
    call add(s:efm_filetypes, 'markdown')
  endif

  if !empty(s:efm_filetypes)
    let s:efm_config = expand('<sfile>:p:h').'/efm.yaml'
    let s:lsmap['efm'] = {
          \   'command': 'efm-langserver',
          \   'args': [ '-c', s:efm_config ],
          \   'filetypes': s:efm_filetypes,
          \ }
  endif
endif

call coc#config('languageserver', s:lsmap)

call coc#add_extension(
      \   'coc-rls',
      \   'coc-java',
      \   'coc-json',
      \   'coc-python',
      \   'coc-tsserver',
      \   'coc-yaml',
      \   'coc-html',
      \   'coc-css',
      \ )
