let g:ale_linters = {
      \ 'javascript': ['eslint','tsserver'],
      \ 'typescript': ['tslint','tsserver'],
      \ 'c': ['ccls', 'clang', 'clangtidy'],
      \ 'cpp': ['ccls', 'clang', 'clangtidy'],
      \ 'kotlin': ['languageserver'],
      \ }

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ }

let g:ale_fix_on_save_ignore = {
      \ }

let g:ale_fix_on_save = 1
