" ---- [0] VARIABLES AND FUNCTIONS ----
function! QFix()
	if !exists("t:qFixWin")
		let t:qFixWin = 0
	endif
	if t:qFixWin == 0
		copen
		let t:qFixWin = 1
	else
		ccl
		let t:qFixWin = 0
	endif
endfunction

function! QFixClose()
	ccl
	let t:qFixWin = 0
endfunction

" Jumps you to the next/previous ultisnips location if exists.
" Else it jumps to the next/previous delimiter.
" Default delimiters: "'(){}[]
" To change default delimiters just change b:smartJumpElements
function! SmartJump()
	call UltiSnips#JumpForwards()
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}\[]"
	endif
	if g:ulti_jump_forwards_res == 1
		return ""
	endif
	let cursorPos = getpos('.')
	let pos = match(getline('.'), b:smartJumpElements, cursorPos[2] - 1)
	if pos == -1
		return ""
	else
		let cursorPos[2] = pos + 1
		call setpos('.', cursorPos)
		call feedkeys("\<right>",'i')
	endif
	return ""
endfunction
function! SmartJumpBack()
	call UltiSnips#JumpBackwards()
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}\[]"
	endif
	if g:ulti_jump_backwards_res == 1
		return ""
	endif
	let cursorPos = getpos('.')
	let newPos = match(getline('.'), b:smartJumpElements)
	let pos = newPos
	if pos == -1 || pos > cursorPos[2] + 1
		return ""
	endif
	let matchCount = 1
	while newPos < cursorPos[2] - 1
		if newPos == -1
			break
		endif
		let pos = newPos
		let newPos = match(getline('.'), b:smartJumpElements, 0, matchCount)
		let matchCount += 1
	endwhile
	let cursorPos[2] = pos + 1
	call setpos('.', cursorPos)
	return ""
endfunction
" --------------------
" ---- [1] NORMAL VIMSETTINGS ----
autocmd!
set nocompatible
set relativenumber
set guioptions=
set incsearch
set ruler
set completeopt=menu,longest
set tabpagemax=100
set notimeout
if &guifont
	set guifont=Inconsolata\ bold\ 10
endif
set wildmode=longest:full,list
set directory=~/.vim/tmp//
set nobackup
set winminheight=0
set visualbell
set hidden
set splitbelow
set splitright
set scrolloff=999
set nrformats-=octal
set ignorecase
set smartcase
set autoread
set cryptmethod=blowfish
set formatoptions-=cro
set updatetime=1000
set backspace=indent,eol,start
let $LANG = 'en'
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

syntax on
" ---------
" ---- [2] SESSION SETTINGS ----
set sessionoptions-=options
set sessionoptions+=folds

function! GetDir()
	let l:name = getcwd()
	let l:name = substitute(l:name, "\\", "-", "g")
	let l:name = substitute(l:name, ":", "-", "g")
	let l:name = substitute(l:name, "/", "-", "g")
	let l:name = "~/.cache/unite/session/" . l:name . ".vim"
	return l:name
endfunction

function! SaveSession()
	exe "mksession! " . GetDir()
endfunction

" --------------------
" ---- [3] PLUGINS ----
" ---- [3.0] VUNDLE ----
if !exists("g:reload")
	" Required by vundle
	filetype off
	set rtp+=~/.vim/bundle/Vundle.vim/
	call vundle#begin()
	Plugin 'gmarik/Vundle.vim'

	" Vundle addons"
	Plugin 'Shougo/neomru.vim'
	Plugin 'Shougo/unite.vim'
	Plugin 'Shougo/unite-build'
	Plugin 'Shougo/unite-session'
	Plugin 'tsukkee/unite-tag'
	Plugin 'skeept/ultisnips-unite'
	Plugin 'Shougo/neocomplcache'
	Plugin 'JazzCore/neocomplcache-ultisnips'
	Plugin 'SirVer/ultisnips'
	Plugin 'scrooloose/nerdtree'
	Plugin 'OmniSharp/omnisharp-vim'
	Plugin 'tpope/vim-dispatch'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'Rip-Rip/clang_complete'
	Plugin 'majutsushi/tagbar'
	Plugin 'xolox/vim-easytags'
	Plugin 'xolox/vim-misc'
	Plugin 'Konfekt/FastFold'
	Plugin 'Raimondi/delimitMate'

	" Required by vundle
	call vundle#end()
	filetype plugin indent on
endif
" ----------
" ---- [3.1] ULTISNIPS ----
" --------
" ---- [3.2] ECLIM ----
" Sets eclims completionmethod to omnifunc
let g:EclimCompletionMethod = 'omnifunc'
" -----
" ---- [3.3] OMNISHARP (C# OMNICOMPLETE) ---- 
let g:OmniSharp_typeLookupInPreview = 1
" Sets the sln file to the first file avaliable
let g:OmniSharp_sln_list_index = 1
" If omnisharp server is running never stop it.
let g:Omnisharp_stop_server = 0
" -------
" ---- [3.4] UNITE ----
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_update_time = 300
let g:unite_cursor_line_highlight = 'TabLine'

let s:bufferaction = {'description' : 'verbose', 'is_selectable' : 1,}

"call unite#custom#source('file_rec', 'ignore_pattern', join(['.pyc$', '.exe$', '.o$'], '\|'))
"call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_pattern', join([
"			\ '.pyc$',
"			\ '.o$',
"			\ ], '\|'))
" call unite#custom#source('tab', 'ignore_pattern', join(['unite'], '\|'))
call unite#custom#default_action('buffer', 'goto')

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
" --------------------
" ---- [3.5] Fugitive ----
" --------------------
" ---- [3.6] NEOCOMPLCACHE ----
let g:neocomplcache_enable_at_startup = 1

" Required for clang_complete to play nice with NEOCOMPLCACHE.
if !exists('g:neocomplcache_force_omni_patterns')
	let g:neocomplcache_force_omni_patterns = {}
endif
if !exists('g:neocomplcache_omni_functions')
	    let g:neocomplcache_omni_functions = {}
endif

let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
			\ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
			\ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.objc =
			\ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.objcpp =
			\ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

let g:neocomplcache_enable_smart_case = 0
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_ignore_case = 0
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_auto_close_preview = 0

let g:clang_complete_auto = 0
let g:clang_auto_select = 0

let g:ulti_expand_res = 0
let g:ulti_jump_forwards_res = 0
let g:ulti_jump_backwards_res = 0
function! NeoTab()
	call UltiSnips#ExpandSnippet()
	if g:ulti_expand_res == 1
		return ""
	endif
	let longestCommon = neocomplcache#complete_common_string()
	if longestCommon == ""
		return pumvisible() ? "" : "\<TAB>"
	endif
	return longestCommon
endfunction
" --------------------
" ---- [3.7] NERDTREE ----
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 0
let NERDTreeShowBookmarks = 1
let NERDTreeMinimalUI = 1
let NERDTreeIgnore=['\.\.$,','\.$']
let NERDTreeWinSize = 50
let NERDTreeSortOrder = ['^\a.*/$', '\/$', '^\a.*$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeStatusline = "%{getcwd()}"


function! Explorer(node)
	call system('explorer ' . a:node.path._str())
endfunction

function! RunFile(node)
	let fname = a:node.path._str()
	if fname =~ ".mkv$" || fname =~ ".mp4$" || fname =~ ".avi$" || fname =~ ".wmv$" || fname =~ ".mov$" || fname =~ ".exe$" || fname =~ ".msi$" || fname =~ ".png$"
		call system('cmd /c start ' . a:node.path._str())
	else
		call ActivateFileNode(a:node)
	endif
endfunction
function! ActivateFileNode(node)
	call a:node.activate({'reuse': 1, 'where': 'p'})
endfunction
function! ActivateDirNode(node)
	call a:node.activate({'reuse': 1})
endfunction
function! ActivateBookmark(bm)
	call a:bm.activate(!a:bm.path.isDirectory ? {'where': 'p'} : {})
endfunction

function! NERDRemove(node)
	call system("rm -r " . "\"" . a:node.path._str() . "\"")
endfunction
" --------------------
" ---- [3.8] EASYTAGS ----
let g:easytags_updatetime_warn = 0
let g:easytags_by_filetype = '~/.vim/tags/'
" --------------------
" ---- [3.9] FastFold ----
let g:fastfold_savehook = 1
let g:fastfold_togglehook = 0
let g:fastfold_map = 1
" --------------------
" --------------------
" ---- [4] FOLDING ----
" ---- [4.0] FOLDSETTINGS ----
set foldmethod=expr
set foldnestmax=2
set foldopen=
set foldlevelstart=0
" --------------------
" ---- [4.1] FOLDEXPR ----
let g:InsideBrace = 0
let g:InsideVar = 0

" Foldfunction for braces and vars indented one forward (C# and JAVA)
" 1	import/using bla; 
" 1	import/using bla; 
" 1	import/using bla; 
"
" 	class
" 	{
" 1 		var
" 1 		var
" 1 		var
"
" 1		var
" 1 		var
" 1 		var
"
" 1 		fun{
" 1			bla 
" 1		}
"
" 1 		fun
" 1		{
" 1			bla
" 1		}
" 	}
function! OneIndentBraceFolding(lnum)
	let line=getline(a:lnum)
	let nextline=getline(a:lnum + 1)
	" Catches start of function body
	if indent(a:lnum) == 8 && line =~ '{'
			let g:InsideBrace = 1
			let g:InsideVar = 0
	endif
	" Catches end of function body
	if indent(a:lnum) == 8 && line =~ '^\s*}'
			let g:InsideBrace = 0
			return 1
	endif
	" If inside function body
	if g:InsideBrace
		return 1
	" If inside multiline variable declaration or something similar, like a multiline comment with indentation
	elseif g:InsideVar && line =~ '\S'
		return 1
	" Cacthes start of multiline variable or comment
	elseif indent(a:lnum) == 8 && line =~ '\S'
		let g:InsideVar = 1
		return 1
	" Catches import/using for folding
	elseif indent(a:lnum) == 0 && (line =~ 'import' || line=~ 'using')
		return 1
	" Rest, don't fold
	else
		let g:InsideVar = 0
		return 0
	endif
endfunction

" Foldfunction for braces (C)
" 1	fun
" 1	{
" 1		bla
" 1	}
function! BraceFolding(lnum)
	let line=getline(a:lnum)
	let nextline=getline(a:lnum + 1)
	" Catches start of function body
	if indent(a:lnum + 1) == 0 && nextline =~ '{'
			let g:InsideBrace = 1
	endif
	" Catches end of function body
	if indent(a:lnum) == 0 && line =~'}'
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

" Foldfunction for " ---(-) (VIMRC)
" 1	" ---
" 1	bla
" 1	" -----
function! VimrcFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^\" ---- '
		return 'a1'
	elseif line =~ '^\" -----'
		return 's1'
	else
		return '='
	endif
endfunction


" Foldfunction for snippet->endsnippet (snippet)
" 1	snippet
" 1	bla
" 1	endsnippet
function! SnippetFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^snippet'
		return ">1"
	elseif line =~ '^endsnippet'
		return "<1"
	else
		return '='
	endif
endfunction

" Indentionfolding, includes row before new indent.
function! IndentFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^import' || line =~ '^from'
		return 1
	elseif line =~ '\S'
		if indent(a:lnum)/8 < indent(a:lnum+1)/8
			return ">" . indent(a:lnum+1)/8
		else
			return indent(a:lnum)/8
		endif
	else
		return '='
	endif
endfunction

" Indentfolding, includes row before new indent and row after.
function! IndentFolding2(lnum)
	let line = getline(a:lnum)
	if line =~ "^\s*$"
		return '='
	elseif indent(a:lnum)/8 < indent(a:lnum+1)/8
		return ">" . indent(a:lnum+1)/8
	elseif indent(a:lnum)/8 < indent(a:lnum-1)/8 && (line =~ '^\s*\\end' || line =~ '^\s*\\]')
		return "<" . indent(a:lnum-1)/8
	else
		return indent(a:lnum)/8
	endif
endfunction


"Passfolding
function! PassFolding(lnum)
	let line = getline(a:lnum)
	if line == ""
		return 0
	endif
	return ">1"
endfunction

"MARKDOWNfolding
function! MDFolding(lnum)
	let line = getline(a:lnum)
	if line =~ "#"
		let ind = strlen(substitute(line, "[^#]", "", "g"))
		return '>' . ind
	else
		return '='
	endif

endfunction
" ---------------
" ---- [4.2] FOLDTEXT ----
" 
" 1 if either line has a brace, else 2
" (1)
"-------Line1 Line2
" (2)
" 	Line1 Line2	
"function! SpecialBraceFoldText()
"	let i = v:foldstart
"	let line = getline(i)
"	let i = i+1
"	let line .= getline(i)
"	if line =~ '{'
"		return '-------' . line
"	else
"		return '       ' . line
"	endif
"endfunction
function! SpecialBraceFoldText()
	let i = v:foldstart
	let line = getline(i)
	while(line =~ '/' || line =~ '@' || line !~ '\S')
		let i = i+1
		let line = getline(i)
	endwhile

	let line = substitute(line,'^\s*','','')
	let indent_level = indent(v:foldstart)
	let indent = repeat(' ', indent_level)
	return indent . line
endfunction

" Line1
function! NormalFoldText()
	let line = substitute(getline(v:foldstart),'^\s*','','')
	let indent_level = indent(v:foldstart)
	let indent = repeat(' ', indent_level)
	if line =~ 'import'
	       let line = "import"	
	endif
	return indent . line
endfunction

" name pass username
" name ------------- 
function! PassFoldText()
	let line = getline(v:foldstart)
	let words = split(line, '\t')
	return words[0]
endfunction

" --------------------
" --------------------
" ---- [5] AUTOCMD ----
autocmd BufWritePost * call SaveSession() | call SlowStatusLine()
autocmd BufEnter * call SlowStatusLine() 

autocmd InsertEnter * hi StatusLine gui=reverse
autocmd InsertLeave * hi StatusLine guibg=NONE gui=underline

" To make FastFold calculate the folds when you open a file.
autocmd BufReadPost * let &foldlevel=0
" --------------------
" ---- [6] FILETYPE SPECIFIC ----
" ---- [6.0] All ----
" :set filetype? To know current loaded filetype
" for specific startfolding - let &foldlevel=0
" --------
" ---- [6.1] JAVA ----
function! JavaSettings()
	setlocal omnifunc=JavaOmni
	let g:neocomplcache_omni_patterns.java = '.*'
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

function! JavaOmni(findstart, base)
	let words = eclim#java#complete#CodeComplete(a:findstart, a:base)
	if a:findstart
		return words
	elseif type(words) == 0 && words < 0
		return words
	else
		return filter(words, 'match(v:val["word"], a:base)==0')
	endif
endfunction

autocmd Filetype java call JavaSettings()
" --------
" ---- [6.2] C# ----
function! CSSettings()
	setlocal omnifunc=CSOmni
	let g:neocomplcache_omni_patterns.cs = '.*'
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

function! CSOmni(findstart, base)
	let words = OmniSharp#Complete(a:findstart, a:base)
	if a:findstart
		return words
	elseif type(words) == 0 && words < 0
		return words
	else
		return filter(words, 'match(v:val["word"], a:base)==0')
	endif
endfunction

" Updates omnisharp to include new methods
autocmd BufWritePost *.cs :OmniSharpReloadSolution

autocmd Filetype cs call CSSettings()
" ----------------
" ---- [6.3] C ----
function! CSettings()
	setlocal omnifunc=COmni
	setlocal foldexpr=BraceFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

function! COmni(findstart, base)
	let words = UltiSnips#SnippetsInCurrentScope()
	if a:findstart
		return words
	elseif type(words) == 0 && words < 0
		return words
	else
		return filter(words, 'match(v:val["word"], a:base)==0')
	endif
endfunction

autocmd Filetype c,cpp call CSettings()
" --------------------
" ---- [6.4] VIMRC ----
function! VIMSettings()
	setlocal foldexpr=VimrcFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	set textwidth=0
endfunction

" Pentadactyl file is a vim file.
autocmd BufRead .pentadactylrc set filetype=vim

" Runs the new vimrc when you save it.
autocmd BufWritePost .vimrc so ~/git/vim/.vimrc

autocmd Filetype vim call VIMSettings()
" -------------
" ---- [6.5] SNIPPET ----
function! SNIPPETSSettings()
	setlocal foldexpr=SnippetFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype snippets call SNIPPETSSettings()
" --------------------
" ---- [6.6] TODO ----
function! TODOSettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Files that end with .td are now todofiles.
autocmd BufEnter *.td setlocal filetype=todo

autocmd Filetype todo call TODOSettings()
" --------------------
" ---- [6.7] PYTHON ----
function! PythonSettings()
	setlocal omnifunc=PythonOmni
	let g:neocomplcache_omni_patterns.python = '.*'
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

function! PythonOmni(findstart, base)
	let words = eclim#python#complete#CodeComplete(a:findstart, a:base)
	if a:findstart
		return words
	elseif type(words) == 0 && words < 0
		return words
	else
		return filter(words, 'match(v:val["word"], a:base)==0')
	endif
endfunction

autocmd Filetype python call PythonSettings()
" --------------------
" ---- [6.8] LUA ----
function! LUASettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype lua call LUASettings()
" -------------
" ---- [6.9] MAKE ----
function! MAKESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype make call MAKESettings()
" -------------
" ---- [6.10] PASS ----
function! PASSSettings()
	setlocal foldexpr=PassFolding(v:lnum)
	setlocal foldtext=PassFoldText()
	setlocal foldminlines=0
	FastFoldUpdate
endfunction

function! GenPass(...)
let l:passLen = (a:0 > 0 ? a:1 : 8)
python << endpy
import random, string, vim, sys
characters = string.ascii_letters + string.digits + '@&-_=+?!'
passLen = int(vim.eval("l:passLen"))
password = "".join(random.choice(characters) for x in range(0,passLen))
vim.command("let l:password = '" + str(password) + "'")
endpy
execute "normal a".l:password
endfunction

" Files that end with .pass are now password files.
autocmd BufNewFile,BufRead *.pass set filetype=pass

autocmd Filetype pass call PASSSettings()
" -------------
" ---- [6.11] JAPANESE ----
function! JAPANESESettings()
	set guifont=MS_Gothic:h16:w8
	set fileencoding=utf-8
	set encoding=utf-8
endfunction

" Files that end with .jp are now japanese files.
autocmd BufNewFile,BufRead *.jp set filetype=jp

autocmd Filetype jp call JAPANESESettings()
" -------------
" ---- [6.12] LATEX ----
function! TEXSettings()
	setlocal foldexpr=IndentFolding2(v:lnum)
	setlocal foldtext=NormalFoldText()
	setlocal spell spelllang=en_us
endfunction


" Compile latex to a pdf when you save
autocmd BufWritePre *.tex silent !start /min rm -f %:r.aux
autocmd BufWritePost *.tex silent !start /min pdflatex -halt-on-error -output-directory=%:h %

autocmd Filetype tex call TEXSettings()
" --------------------
" ---- [6.13] GitCommit ----
function! GITCSettings()
	" Don't fold gitstuff.
	let &foldlevel = 99
	call FugitiveBindings()
endfunction

autocmd FileType gitcommit call GITCSettings()
" --------------------
" ---- [6.14] MARKDOWN ----
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd FileType markdown call MDSettings()
" --------------------
" --------------------
" ---- [7] BINDINGS ----
" ---- [7.0] NORMAL ----
"Not vi-compatible but more logical. Y yanks to end of line.
noremap Y y$

"Switches repeat f/F, feels more logical on swedish keyboard.
noremap , ;
noremap ; ,

" perform math on cursor
noremap å viw"xc<C-R>=getreg('x')

" Jumps when stuff is selected
" snoremap <TAB> <ESC>:call UltiSnips#JumpForwards()<CR>

"noremap ö :Unite -no-split window buffer file_mru<CR>
noremap ö :Unite -no-split buffer file_mru<CR>
noremap Ö :NERDTreeToggle .<CR>

noremap <C-J> <C-]>

" Close everything except current fold.
noremap zV zMzv

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter. 
noremap <S-Space> :call SmartJump()<CR>
noremap <S-BS> :call SmartJumpBack()<CR>

" Good avaliable binds
" ´
" Enter
" Backspace
" Shift enter
" l&r Shift solo
" ä
" Ä
" H (doesn't do anything since cursor always in middle for me)
" M (doesn't do anything since cursor always in middle for me)
" L (doesn't do anything since cursor always in middle for me)
" s (synonym for cl)
" S (synonym for cc)

" --------------------
" ---- [7.1] INSERT ----
" Ultisnips bindings
" f9 just to remove them. TODO look for better way to remove binding
let g:UltiSnipsExpandTrigger="<f10>"
let g:UltiSnipsListSnippets = "<f10>"
let g:UltiSnipsJumpForwardTrigger="<f-10>"
let g:UltiSnipsJumpBackwardTrigger="<f-10>"
"inoremap <C-J> <C-R>=UltiSnips#JumpForwards()<CR>

" Run my special tab-command that.
inoremap <TAB> <C-R>=NeoTab()<CR>

" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>de

" inoremap <silent> ( (<C-R>=UltiSnips#Anon('($1)$0', '(', '', 'i')<cr>
" inoremap <silent> " "<C-R>=UltiSnips#Anon('"$1"$0', '"', '', 'i')<cr>
" inoremap <silent> ' '<C-R>=UltiSnips#Anon("\'$1\'$0", "\'", '', 'i')<cr>

" Shift-Enter acts like O in normal
inoremap <S-CR> <C-O>O

" Autocomplete filename.
inoremap <C-F> <C-X><C-F>

" Autocomplete spelling
inoremap <C-S> <C-X><C-S>

" Force normal completion.
inoremap <expr><C-l>  neocomplcache#start_manual_complete()

" Pressing enter chooses completion if completion window is up, else normal enter.
inoremap <expr> <CR> pumvisible() ? '<C-e><CR>' : '<CR>'

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter. 
inoremap <S-Space> <C-R>=SmartJump()<CR>
inoremap <S-BS> <C-R>=SmartJumpBack()<CR>
" --------------------
" ---- [7.2] LEADER ----
let mapleader="\<space>"

" A
" B
" C
" D
map <leader>d :bn\|bd #<CR>
" E
" F
" G
map <leader>gg :Gstatus<CR>
map <leader>gc :Gcommit<CR>
map <leader>gp :Git push<CR> :call SlowStatusLine()<CR>
" H
" I
" J
" K
" L
" I
" M
map <leader>m :Unite -no-split -auto-preview -no-start-insert build:make <CR>
" N 
map <leader>n :bn <CR>
map <leader>N :bp <CR>
" O
" P 
map <leader>p :bp <CR>
" Q
map <leader>q :call QFix()<CR>
" R 
autocmd Filetype python map <buffer><silent> <leader>r :w <bar> ! python % <cr>
autocmd Filetype c map <buffer><silent> <leader>r :w <bar> !./%:r <cr>
autocmd Filetype cpp map <buffer><silent> <leader>r :w <bar> ! main <cr>
" S
map <leader>se :setlocal spell spelllang=en_us <CR>
map <leader>ss :setlocal spell spelllang=sv <CR>
map <leader>so :setlocal nospell <CR>
map <leader>sn :setlocal nospell <CR>
map <leader>sc :setlocal nospell <CR>
map <leader>sd :setlocal nospell <CR>
" T
map <leader>t :TagbarToggle <CR>
" U
map <leader>ue :UltiSnipsEdit <CR>
map <leader>uu :Unite -no-split file:~/vimfiles/Ultisnips <CR>
map <leader>us :Unite -no-split ultisnips <CR>
map <leader>ur :Unite -no-split register<CR>
map <leader>ut :Unite -no-split tag<CR>
"map <leader>uf :Unite -no-split -auto-preview -no-start-insert grep:. <CR>
" V
" W
" X
" Y
" Z
map <leader>z :Unite -no-split session<CR>
" !
" -
" /
" --------------------
" ---- [7.3] VISUAL ----

" When you press TAB and have something selected in visual mode, it saves it
" ultisnips and removes it.
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

" Remapped visual s to vim-surround
xmap s S

" --------------------
" ---- [7.4] COMMAND ----
cnoremap <C-A> <home>
cnoremap <C-BS> <C-W>

cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == "h" ? "tab h" : "h"
" I tend to write :git instead of :Git
cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "Git" : "git"
" --------------------
" ---- [7.5] NERDTREE ----
let NERDTreeMapOpenSplit='<C-S>'
let NERDTreeMapOpenVSplit='<C-V>'
let NERDTreeMapOpenInTab='<C-T>'
let NERDTreeMapUpdir='<BS>'
let NERDTreeMapChdir='<C-C>'

autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<C-e>',
	\ 'callback': 'Explorer',
	\ 'quickhelpText': 'Opens windows explorer',
	\ 'scope': 'Bookmark'})
autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<C-e>',
	\ 'callback': 'Explorer',
	\ 'quickhelpText': 'Opens windows explorer',
	\ 'scope': 'DirNode'})

autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<CR>',
	\ 'callback': 'ActivateDirNode',
	\ 'quickhelpText': 'A smarter vim enter.',
	\ 'scope': 'DirNode'})

autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<CR>',
	\ 'callback': 'RunFile',
	\ 'quickhelpText': 'A smarter vim enter.',
	\ 'scope': 'FileNode'})

autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<CR>',
	\ 'callback': 'ActivateBookmark',
	\ 'quickhelpText': 'A smarter vim enter.',
	\ 'scope': 'Bookmark'})

autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<C-x>',
	\ 'callback': 'NERDRemove',
	\ 'quickhelpText': 'Removes stuff using NERDTree',
	\ 'scope': 'FileNode'})
autocmd Filetype nerdtree call NERDTreeAddKeyMap({
	\ 'key': '<C-x>',
	\ 'callback': 'NERDRemove',
	\ 'quickhelpText': 'Removes stuff using NERDTree',
	\ 'scope': 'DirNode'})
" --------------------
" ---- [7.6] UNITE ----
function! s:unite_settings()
	nmap <buffer> <S-Space> <Plug>(unite_redraw)
	nmap <buffer> <ESC> <Plug>(unite_all_exit)
	nnoremap <buffer> <BS> <Plug>()
	imap <buffer> <TAB> <Plug>(unite_select_next_line)
	imap <buffer> <S-TAB> <Plug>(unite_select_previous_line)
	inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	nnoremap <silent><buffer><expr> <C-t> unite#do_action('tab')
	"imap <buffer> <C-p> <Plug>(unite_toggle_auto_preview) 
	"nmap <buffer> <C-p> <Plug>(unite_toggle_auto_preview) 
	"inoremap <silent><buffer><expr> <C-p> empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&previewwindow") != 0')) ?  unite#do_action('preview') : ":\<C-u>pclose!\<CR>"
	"nnoremap <silent><buffer><expr> <C-p> empty(filter(range(1, winnr('$')), 'getwinvar(v:val, "&previewwindow") != 0')) ?  unite#do_action('preview') : ":\<C-u>pclose!\<CR>"
	inoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	nnoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	inoremap <silent><buffer><expr> <C-c> unite#do_action('cd') |
	nnoremap <silent><buffer><expr> <C-c> unite#do_action('cd')
endfunction
autocmd FileType unite call s:unite_settings()
" --------------------
" ---- [7.7] FUGITIVE ----
function! FugitiveBindings()
	" Fast movement for :GStatus
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
endfunction
" --------------------
" --------------------
" ---- [8] TABS ----
function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tab = i + 1
		let winnr = tabpagewinnr(tab)
		let buflist = tabpagebuflist(tab)

		let bufname = fnamemodify(bufname(buflist[0]), ':t:r')

		let bufmodified = 0
		for buf in buflist
			if !bufmodified
				let bufmodified = getbufvar(buf, "&mod")
			endif
		endfor

		let s .= '%' . tab . 'T'
		let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
		let s .= ' ' . tab . (bufmodified ? "+" : "") .' '
		let s .= (bufname != '' ? bufname . ' ' : '- ')
	endfor

	let s .= '%#TabLineFill#'
	return s
endfunction

set tabline=%!Tabline()
" --------------------
" ---- [9] OS SPECIFIC ----
" ---- [9.0] Windows ----
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" --------------------
" ---- [9.1] Linux ----
" --------------------
" --------------------
" ---- [10] STATUSLINE ----
set laststatus=2
set statusline=%<\[%f\]\ %{MyStatusLine()}\ %y\ %m%=%-14.(%l-%c%)\ %P

function! MyStatusLine()
	if !exists("b:statusLineVar")
		call SlowStatusLine()
	endif
	return b:statusLineVar
endfunction

" Updates gitinfo for the statusline. 
" cf - Nr of [c]hanged [f]iles.
" cl - Nr of [c]hanged [l]ines in current file.
function! SlowStatusLine()
	let SlowStatusLineVar = ""
	if &modifiable
		let gitTemp = system("git -C " . expand("%:h") . " status -b -s")
		let gitTemp = substitute(gitTemp, "##" , "", "")
		let gitTemp = substitute(gitTemp, "\\.\\.\\." , "->", "")
		if gitTemp !~ "fatal" 
			let gitList = split(gitTemp, "\n")
			if len(gitList) > 0 
				let branchName = gitList[0]
				let branchName = substitute(branchName, " ", "[", "")
				let beforeSub = branchName
				let branchName = substitute(branchName, " ", "] ", "")
				if beforeSub == branchName
					let branchName .= "]"
				endif
				let SlowStatusLineVar .= branchName
			endif
			if len(gitList) > 1
				let SlowStatusLineVar .= " [m " . (len(gitList) -1) . "]"
			endif

			let changedRows = []
			let rowsTemp = split(system("git -C " . expand("%:h") . " diff --numstat"), "\n")
			for row in rowsTemp
				if row =~ escape(expand('%:t'), ".")
					let changedRows = split(row, "\t")
				endif
			endfor
			if(len(changedRows) > 0)
				let SlowStatusLineVar .= " [+" . changedRows[0] . " -" . changedRows[1] . "]"
			endif
		endif
	endif
	let b:statusLineVar = SlowStatusLineVar
endfunction
" --------------------
" ---- [11] MINIMALMODE ----
function! MinimalMode()
	let s:CompletionCommand = "\<C-X>\<C-U>"
	let g:PosBeforeCompletion = 0
	function! SmartTab()
		"if getline(line(".")) =~ '\S'
		if getline(".")[col('.') - 2] =~ '\S'
			call UltiSnips#ExpandSnippet()
			if g:ulti_expand_res
				return ""
			else
				if pumvisible()
					let g:PosBeforeCompletion = col('.')
					return "\<C-E>" . s:CompletionCommand
				else
					let g:PosBeforeCompletion = col('.')
					return s:CompletionCommand
				endif
			endif
		else
			return "\<TAB>"
		endif
	endfunction

	" No complete-as-you-type, instead tab autocompletes/open completion window.
	let g:neocomplcache_disable_auto_complete = 1
	inoremap <TAB> <C-R>=SmartTab()<CR>
endfunction
" --------------------
" ---- [12] COLORSETTINGS ----
colorscheme desert

" Change to better colors when using a terminal
if has("terminfo")
	let &t_Co=256
	set background=dark
	hi Title ctermfg=209
	hi SpecialKey ctermfg=242
	hi NonText ctermfg=7 ctermbg=8
	hi IncSearch ctermfg=191 ctermbg=8
	hi Search ctermfg=15 ctermbg=172
	hi MoreMsg ctermfg=22
	hi Visual ctermbg=15 ctermfg=70
	hi Folded ctermbg=236 ctermfg=11
	hi FoldColumn ctermbg=8 ctermfg=178
	hi Constant ctermfg=174
	hi Idetifier ctermfg=47
	hi Statement ctermfg=11 cterm=bold
	hi PreProc ctermfg=209
	hi Type ctermfg=3 cterm=bold
	hi Todo ctermfg=9 cterm=bold
	hi Special ctermfg=11
	hi Identifier ctermfg=47
	hi Normal ctermfg=15
endif


" More discreet color for whitespaces.
hi SpecialKey guifg=grey40
" Better color for the column that appears on the side.
hi SignColumn guibg=bg

hi clear StatusLine
hi StatusLine gui=underline
hi TabLineFill term=underline cterm=underline gui=underline guibg=grey30
hi TabLine term=underline cterm=underline gui=underline guibg=grey30
hi TabLineSel term=none cterm=none gui=none
" --------------------
" ---- [13] AFTER VIMRC ----
if !exists("g:reload")
	let g:reload = 1
endif
" --------------------
