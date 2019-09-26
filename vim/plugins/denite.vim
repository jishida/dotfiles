call denite#custom#var('file/rec', 'command', ['rg', '--files', '--follow', '--hidden', '--no-ignore-vcs', '--no-messages', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])

call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
call denite#custom#source('file/old', 'matchers', ['matcher/fruzzy', 'matcher/project_files'])

call denite#custom#source('file/rec', 'sorters', ['sorter/word'])
