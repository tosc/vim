"       FOLDING
" ---- [1] FOLDSETTINGS -----
set foldmethod=expr
set foldnestmax=2
set foldopen=
" ---------------------------
" ---- [2] FOLDEXPR ---------
" ---- [2.0] GLOBAL VARS ----
let g:InsideBrace = 0
let g:InsideVar = 0
let g:InsideComment = 0
" ---------------------------
" ---- [2.1] C# JAVA --------
function! OneIndentBraceFolding(lnum)
	let line = getline(a:lnum)
	let nextline = getline(a:lnum+1)
	if a:lnum == 1
		let g:InsideBrace = 0
		let g:InsideVar = 0
	endif
	if line =~ '^using' || line =~ '^import' || line =~ '^package'
		return 1
	elseif line =~ '^\s*$' && g:InsideComment == 0
		if nextline =~ '^\s*$' && g:InsideVar == 1
			return 1
		elseif g:InsideVar == 1
			let g:InsideVar = 0
			return '<1'
		else
			return '='
		endif
	else
		if g:InsideBrace == 1
			if line =~ '^\s*}' && indent(a:lnum)/&shiftwidth == 1
				let g:InsideBrace = 0
				if  nextline =~ '^\s*$'
					let g:InsideVar = 1
					return '1'
				else
					return '<1'
				endif
			else
				return 1
			endif
		elseif g:InsideComment == 1
			if line =~ '\*/$'
				let g:InsideComment = 0
				if  nextline =~ '^\s*$'
					let g:InsideVar = 1
					return '1'
				else
					return '<1'
				endif
			else
				return 1
			endif
		else
			if line =~ '^\s*/\*' && line =~ '\*/$'
				return '='
			elseif line =~ '^\s*/\*'
				let g:InsideComment = 1
				return '>1'
			elseif line =~ '{' && indent(a:lnum)/&shiftwidth == 1
				let g:InsideBrace = 1
				return ">1"
			elseif line =~ '/// <summary>' && indent(a:lnum)/&shiftwidth == 1
				let g:InsideBrace = 1
				return ">1"
			elseif line =~ '@Override' && indent(a:lnum)/&shiftwidth == 1
				let g:InsideBrace = 1
				return ">1"
			elseif nextline =~ '^\s*{' && indent(a:lnum + 1)/&shiftwidth == 1
				let g:InsideBrace = 1
				return ">1"
			elseif indent(a:lnum)/&shiftwidth >= 1
				return 1
			else
				return 0
			endif
		endif
	endif
endfunction
" ---------------------------
" ---- [2.2] C --------------
function! BraceFolding(lnum)
	let line=getline(a:lnum)
	let nextline=getline(a:lnum + 1)
	" Catches start of function body
	if indent(a:lnum + 1) == 0 && nextline =~ '{\s*$'
			let g:InsideBrace = 1
	endif
	" Catches end of function body
	if indent(a:lnum) == 0 && line =~'}\s*$'
			let g:InsideBrace = 0
			return 1
	endif
	" If inside function body
	if g:InsideBrace
		return 1
	" Rest, don't fold
	else
		let g:InsideVar = 0
		return 0
	endif
endfunction
" ---------------------------
" ---- [2.3] VIM ------------
function! VimrcFolding(lnum)
	let line = getline(a:lnum)
	let nextline = getline(a:lnum+1)
	if line =~ '^\" ---- ' || line =~ '^function' || line =~ '^\s*if' || line =~ '^\s*elseif'
		return 'a1'
	elseif line =~ '^\" ---------------------------' || line =~ '^endfunction' || line =~ '^\s*endif'
		if nextline =~ '^\s*elseif'
			return 's2'
		else
			return 's1'
		endif
	elseif nextline =~ '^\s*elseif'
		return 's1'
	else
		return '='
	endif
endfunction
" ---------------------------
" ---- [2.4] SNIPPETS -------
function! SnippetFolding(lnum)
	if a:lnum == 1
		let g:InsideBrace = 0
	endif
	let line = getline(a:lnum)
	if line =~ '^# ' && !g:InsideBrace
		return '>1'
	elseif (line =~ '^snippet' || line=~ '^pre_expand' || line=~ '^post_jump') && !g:InsideBrace
		let g:InsideBrace = 1
		return '>2'
	elseif line =~ '^endsnippet'
		let g:InsideBrace = 0
		return '<2'
	else
		return '='
	endif
endfunction
" ---------------------------
" ---- [2.5] TODO LUA MAKE --
" Includes row before new indent.
function! IndentFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^import' || line =~ '^from'
		return 1
	elseif line =~ '\S'
		if indent(a:lnum)/&shiftwidth < indent(a:lnum+1)/&shiftwidth
			return ">" . indent(a:lnum+1)/&shiftwidth
		else
			return indent(a:lnum)/&shiftwidth
		endif
	else
		return '='
	endif
endfunction
" ---------------------------
" ---- [2.6] PYTHON ---------
function! PythonFolding(lnum)
	let pline = getline(a:lnum-1)
	let line = getline(a:lnum)
	let nline = getline(a:lnum+1)
	if line =~ '^import' || line =~ '^from'
		let g:InsideVar = 0
		return 1
	elseif line =~ '\S'
		if line =~ '^\s*def' || line =~ '^\s*class'
			let g:InsideVar = 0
			return ">" . (indent(a:lnum)/&shiftwidth + 1)
		elseif indent(a:lnum) == 0
			if g:InsideVar == 0
				let g:InsideVar = 1
				return ">1"
			else
				return 1
			endif
		endif
	endif
	return '='
endfunction
" ---------------------------
" ---- [2.7] LATEX ----------
" Includes row before new indent and row after.
function! TexFolding(lnum)
	let line = getline(a:lnum)
	if line =~ "^\s*$"
		return '='
	elseif indent(a:lnum)/&shiftwidth < indent(a:lnum+1)/&shiftwidth
		return ">" . indent(a:lnum+1)/&shiftwidth
	elseif indent(a:lnum)/&shiftwidth < indent(a:lnum-1)/&shiftwidth && 
		\ (line =~ '^\s*\\end' || line =~ '^\s*\\]')
		return "<" . indent(a:lnum-1)/&shiftwidth
	else
		return indent(a:lnum)/&shiftwidth
	endif
endfunction
" ---------------------------
" ---- [2.8] PASS -----------
function! PassFolding(lnum)
	let line = getline(a:lnum)
	if line == "" || line =~ "^-"
		return 0
	endif
	return ">1"
endfunction
" ---------------------------
" ---- [2.9] MARKDOWN -------
function! MDFolding(lnum)
	let line = getline(a:lnum)
	if line =~ "^#"
		let ind = strlen(substitute(line, "[^#]", "", "g")) - 1
		return '>' . ind
	else
		return '='
	endif
endfunction
" ---------------------------
" ---- [2.10] LFS -------
function! LFSFolding(lnum)
	let line = getline(a:lnum)
	let ind = strlen(substitute(line, "[^#]", "", "g")) - 1
	if line =~ "^\s*<icon>"
		return 'a1'
	elseif line =~ "^\s*<\\icon>"
		return 's1'
	else
		return '='
	endif
endfunction
" ---------------------------
" ---------------------------
" ---- [3] FOLDTEXT ---------
" ---- [3.0] DEFAULT --------
" First line of fold
function! NormalFoldText()
	let line = substitute(getline(v:foldstart),'^\s*','','')
	let indent_level = indent(v:foldstart)
	if line =~ '^pre_expand' || line =~ '^post_jump'
		let line = substitute(getline(v:foldstart+1),'^\s*','','')
	endif
	if line =~ '^snippet'
		let indent_level = &l:tabstop
	endif
	let indent = repeat(' ', indent_level)
	if line =~ '^import'
	       let line = "import"	
	endif
	let endText = v:foldend - v:foldstart
	return indent . line . repeat(" ", 
		\ winwidth(0)-strlen(indent . line . endText) - 5) . 
		\ endText . " "
endfunction
" ---------------------------
" ---- [3.1] CS JAVA --------
function! SpecialBraceFoldText()
	let i = v:foldstart
	let line = getline(i)
	if line =~ '^using' || line =~ '^import' || line =~ '^package'
		let line = "IMPORT"
	elseif line =~ '/\*'
		let line = "COMMENT"
	elseif line =~ ';'
		let line = "VARIABLES"
	endif
	while(line =~ '^\s*/' || line =~ '@' || line !~ '\S')
		let i = i+1
		let line = getline(i)
	endwhile

	let line = substitute(line,'^\s*','','')
	let indent_level = indent(v:foldstart)
	let indent = repeat(' ', indent_level)
	return indent . line
endfunction
" ---------------------------
" ---- [3.2] PASS -----------
" name pass username
" name -------------
function! PassFoldText()
	let line = getline(v:foldstart)
	let words = split(line, '\t')
	return words[0]
endfunction
" ---------------------------
" ---- [3.3] PYTHON ---------
function! PythonFoldText()
	let line = substitute(getline(v:foldstart),'^\s*','','')
	let indent_level = indent(v:foldstart)
	let indent = repeat(' ', indent_level)
	let endText = v:foldend - v:foldstart
	if line =~ '^import' || line =~ '^from'
		let line = "import"	
	elseif !(line =~ '^\s*def' || line =~ '^\s*class')
		let line = "Code"
	endif
	return indent . line . repeat(" ", 
		\ winwidth(0)-strlen(indent . line . endText) - 5) . 
		\ endText . " "
endfunction
" ---------------------------
" ---------------------------
