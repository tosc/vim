if exists("b:current_syntax")
  finish
endif

syn match Everything '^.*$' contains=Package,Flags,String,Vars,Values
syn match Package '^\s\+[a-zA-Z0-9_#\-.\\%$/]\+' contained
syn match Flags ' -\S\+'
syn match Vars '{[^{}]\+}'
syn match Values '= \?\S\+'
syn match String '"[^"]\+"' contained

hi def link Package Special
hi def link Vars Package
hi def link Everything Identifier
hi def link Flags String
hi def link Values Flags
