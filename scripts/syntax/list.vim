if exists("b:current_syntax")
  finish
endif

syn match List '^.*$' contains=List,Value
syn match Value '\t\zs.*' contained

hi def link List Identifier
hi def link Value Conditional
