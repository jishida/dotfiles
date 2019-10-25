call coc#config('list.insertMappings', {
      \ '<C-c>': 'do:exit',
      \ '<C-j>': 'do:next',
      \ '<C-k>': 'do:previous',
      \ })
call coc#config('list.normalMappings', {
      \ '<C-c>': 'do:exit',
      \ 'v': 'action:vsplit',
      \ 'p': 'action:preview',
      \ })
