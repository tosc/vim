if exists("b:current_syntax")
  finish
endif

syn match ColorE '^.*$' contains=Color0,Color1,Color2,Color3,Color4,Color5,Color6,Color7,Color8,Color9,ColorHide
syn match ColorHide '[0-9]$' contained
syn match Color0 '.*\ze0$' contains=ColorHide
syn match Color1 '.*\ze1$' contains=ColorHide
syn match Color2 '.*\ze2$' contains=ColorHide
syn match Color3 '.*\ze3$' contains=ColorHide
syn match Color4 '.*\ze4$' contains=ColorHide
syn match Color5 '.*\ze5$' contains=ColorHide
syn match Color6 '.*\ze6$' contains=ColorHide
syn match Color7 '.*\ze7$' contains=ColorHide
syn match Color8 '.*\ze8$' contains=ColorHide
syn match Color9 '.*\ze9$' contains=ColorHide

hi def link Color0 Conditional
hi def link Color1 LineNr
hi def link Color2 Todo7
hi def link Color3 String
hi def link Color4 Title
hi def link Color5 Include
hi def link Color6 Directory
hi def link Color7 Function
hi def link Color8 Todo3
hi def link Color9 MoreMsg
hi def link ColorHide Ignore
