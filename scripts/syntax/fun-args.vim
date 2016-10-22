if exists("b:current_syntax")
  finish
endif

syn match Fun '^.*$' contains=Fun,Args
syn match Args '^\s\+\S\+' contained

hi def link Fun Identifier
hi def link Args Conditional
