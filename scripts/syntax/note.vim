function! SubSyntax(syntaxType)
	let b:current_syntax = ''
	unlet b:current_syntax
	let st = a:syntaxType
	let sT = toupper(st)	
	exec "syntax include @" . sT . " syntax/" . st . ".vim"
	exec "syntax region cSnip matchgroup=Snip " .
		\ "start=\"^>" . st ."\" " .
		\ "start=\" >" . st . "$\" " .
		\ "end=\"^[^ \t]\"me=e-1 " .
		\ "end=\"^<\" " .
		\ "end=\"<$\" " .
		\ "contains=@" . sT ." containedin=@HELP concealends"
endfunction
let b:current_syntax = ''
unlet b:current_syntax
runtime! syntax/help.vim

let b:current_syntax = ''
unlet b:current_syntax
syntax include @HELP syntax/help.vim
if has("ebcdic")
	syn match helpHyperTextEntry	"\*[^"*|]\+\*\s"he=e-1 contains=helpStar
	syn match helpHyperTextEntry	"\*[^"*|]\+\*$" contains=helpStar
else
	syn match helpHyperTextEntry	"\*[åäö#-)!+-~]\+\*\s"he=e-1 contains=helpStar
	syn match helpHyperTextEntry	"\*[åäö#-)!+-~]\+\*$" contains=helpStar
endif

call SubSyntax("c")
call SubSyntax("sh")
call SubSyntax("python")
call SubSyntax("vim")
call SubSyntax("linux")
call SubSyntax("xf86conf")
call SubSyntax("systemd")
call SubSyntax("fun-args")
call SubSyntax("cc")
call SubSyntax("list")

"Unuseful syntaxfiles.
"call SubSyntax("make") - Requires formatting.

syn match Snip "." contained conceal
hi def link Snip Ignore
let b:current_syntax = 'note'

