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

colorscheme desert

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

function! LoadSession()
	exe "so " . GetDir()
endfunction



function! LoadOldSessions()
	exe "cd ~/.vim/sessions/"
	let l:rawfiles = system("ls")
	let l:files = split(l:rawfiles, "\n")
	let l:fixFiles = []
	let i = 1
	for line in l:files
		if i < 10
			let line = " " . i . ": " . line
		else
			let line = i . ": " . line
		endif
		let i = i + 1
		call add(fixFiles, line)
	endfor
	let l:fixFiles = insert(l:fIxFiles, "Select session: ")
	let l:session = inputlist(l:fixFiles)

	exe "so " . l:files[l:session - 1]
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
	Plugin 'Rip-Rip/clang_complete'
	Plugin 'majutsushi/tagbar'
	Plugin 'xolox/vim-easytags'
	Plugin 'xolox/vim-misc'
	Plugin 'Konfekt/FastFold'

	" Required by vundle
	call vundle#end()
	filetype plugin indent on
endif
" ----------
" ---- [3.1] ULTISNIPS ----
let g:UltiSnipsEditSplit = 'horizontal'
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
set foldlevelstart=99
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
	if indent(a:lnum)/8 < indent(a:lnum+1)/8
		return ">" . indent(a:lnum+1)/8
	else
	return indent(a:lnum)/8
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

autocmd BufRead .pentadactylrc set filetype=vim
" --------------------
" ---- [6] FILETYPE SPECIFIC ----
" ---- [6.0] All ----
" :set filetype? To know current loaded filetype
" --------
" ---- [6.1] JAVA ----
" Removes all other types of matches from the omnicomplete, ex smartcomplete
" so that completeopt=longest will work
autocmd Filetype java setlocal omnifunc=JavaOmni
autocmd Filetype java let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
autocmd FileType java let g:neocomplcache_omni_patterns.java = '.*'
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

autocmd Filetype java setlocal foldexpr=OneIndentBraceFolding(v:lnum)
autocmd Filetype java setlocal foldtext=SpecialBraceFoldText()
" --------
" ---- [6.2] C# ----
" Removes all other types of matches from the omnicomplete, ex smartcomplete
" so that completeopt=longest will work
autocmd Filetype cs setlocal omnifunc=CSOmni
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

autocmd Filetype cs setlocal foldexpr=OneIndentBraceFolding(v:lnum)
autocmd Filetype cs setlocal foldtext=SpecialBraceFoldText()
autocmd Filetype cs let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
autocmd FileType cs let g:neocomplcache_omni_patterns.cs = '.*'

" ----------------
" ---- [6.3] C ----
autocmd Filetype c,cpp setlocal omnifunc=COmni
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


autocmd Filetype c,cpp setlocal foldexpr=BraceFolding(v:lnum)
autocmd Filetype c,cpp setlocal foldtext=NormalFoldText()
" --------------------
" ---- [6.4] VIMRC ----
autocmd Filetype vim setlocal foldexpr=VimrcFolding(v:lnum)
autocmd Filetype vim setlocal foldtext=NormalFoldText()
autocmd Filetype vim let &foldlevel=0
autocmd Filetype vim set textwidth=0
autocmd BufWritePost .vimrc so ~/git/vim/.vimrc
" -------------
" ---- [6.5] SNIPPET ----
autocmd Filetype snippets setlocal foldexpr=SnippetFolding(v:lnum)
autocmd Filetype snippets setlocal foldtext=NormalFoldText()
" --------------------
" ---- [6.6] TODO ----
autocmd BufEnter *.td setlocal filetype=todo
autocmd Filetype todo setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype todo setlocal foldtext=NormalFoldText()
" --------------------
" ---- [6.7] PYTHON ----
autocmd Filetype python setlocal omnifunc=PythonOmni
autocmd Filetype python let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
autocmd FileType python let g:neocomplcache_omni_patterns.python = '.*'
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
autocmd Filetype python setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype python setlocal foldtext=NormalFoldText()
" --------------------
" ---- [6.8] LUA ----
autocmd Filetype lua setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype lua setlocal foldtext=NormalFoldText()
" -------------
" ---- [6.9] MAKE ----
autocmd Filetype make setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype make setlocal foldtext=NormalFoldText()
" -------------
" ---- [6.10] PASS ----
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

autocmd Filetype pass setlocal foldexpr=PassFolding(v:lnum)
autocmd Filetype pass setlocal foldtext=PassFoldText()
autocmd Filetype pass setlocal foldminlines=0
autocmd Filetype pass let &foldlevel=0
autocmd BufNewFile,BufRead *.pass set filetype=pass
" -------------
" ---- [6.11] JAPANESE ----
autocmd Filetype jp set guifont=MS_Gothic:h16:w8
autocmd Filetype jp set fileencoding=utf-8
autocmd Filetype jp set encoding=utf-8
autocmd BufNewFile,BufRead *.jp set filetype=jp
" -------------
" ---- [6.12] LATEX ----
" Compile latex to a pdf when you save
autocmd Filetype tex setlocal foldexpr=IndentFolding2(v:lnum)
autocmd Filetype tex setlocal foldtext=NormalFoldText()
autocmd BufWritePre *.tex silent !start /min rm -f %:r.aux
autocmd BufWritePost *.tex silent !start /min pdflatex -halt-on-error -output-directory=%:h %
autocmd Filetype tex setlocal spell spelllang=en_us
" --------------------
" --------------------
" ---- [7] BINDINGS ----
" ---- [7.0] NORMAL ----
"Not vi-compatible but more logical. Y yanks to end of line.
noremap Y y$

"Switches repeat f/F, feels more logical
noremap , ;
noremap ; ,

" perform expression on cursor word | EX: select a number ex 5, 5ä, then
noremap å viw"xc<C-R>=getreg('x')

" Jumps when stuff is selected
" snoremap <TAB> <ESC>:call UltiSnips#JumpForwards()<CR>

" When you press TAB and have something selected in visual mode, it saves it
" ultisnips and removes it.
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

"noremap ö :Unite -no-split window buffer file_mru<CR>
noremap ö :Unite -no-split buffer file_mru<CR>
noremap Ö :NERDTreeToggle .<CR>

noremap ä /
noremap Ä ?

noremap <C-J> <C-]>


" Good avaliable binds
" ´
" Enter
" Backspace
" Shift space
" Shift enter
" Shift bs
" l&r Shift solo
" --------------------
" ---- [7.1] INSERT ----
" Ultisnips bindings
" f9 just to remove them. TODO look for better way to remove binding
let g:UltiSnipsExpandTrigger="<f10>"
let g:UltiSnipsJumpForwardTrigger="<F14>"
let g:UltiSnipsJumpBackwardTrigger="<F13>"
let g:UltiSnipsListSnippets = "<f9>"

inoremap <TAB> <C-R>=NeoTab()<CR>

"inoremap <C-J> <C-R>=UltiSnips#JumpForwards()<CR>

" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>de

inoremap <S-CR> <C-O>O

inoremap <C-F> <C-X><C-F>
inoremap <C-S> <C-X><C-S>
inoremap <expr><C-l>  neocomplcache#start_manual_complete()

inoremap <F13> <nop>
inoremap <F14> <nop>
inoremap <S-F13> <nop>
inoremap <S-F14> <nop>
inoremap <S-BS> <nop>

inoremap <expr> <CR> pumvisible() ? '<C-e><CR>' : '<CR>'
" --------------------
" ---- [7.2] LEADER ----
let mapleader="\<space>"

" A
" B
" C
map <leader>c <c-w>c
" D
map <leader>d :bn\|bd #<CR>
" E
" F
" G
map <leader>g :Gstatus<CR>
" H
map <leader>h <c-w>h
" I
" J
map <leader>j <c-w>j
" K
map <leader>k <c-w>k
" L
map <leader>l <c-w>l
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
map <leader>uu :Unite -no-split file:~/vimfiles/Ultisnips <CR>
map <leader>us :Unite -no-split ultisnips <CR>
map <leader>ur :Unite -no-split register<CR>
map <leader>ut :Unite -no-split tag<CR>
"map <leader>uf :Unite -no-split -auto-preview -no-start-insert grep:. <CR>
" V
map <leader>v <c-w>v
" W
" X
" Y
" Z
map <leader>z :Unite -no-split session<CR>
" !
" -
" /
" --------------------
" ---- [7.3] COMMAND ----
cnoremap <C-A> <home>
cnoremap <C-BS> <C-W>
cnoremap <F13> <nop>
cnoremap <F14> <nop>
cnoremap <S-F13> <nop>
cnoremap <S-F14> <nop>

cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == "h" ? "tab h" : "h"
" I tend to write :git instead of :Git
cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "Git" : "git"
" --------------------
" ---- [7.4] NERDTREE ----
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
" ---- [7.5] UNITE ----
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
hi TabLineFill term=underline cterm=underline gui=underline guibg=grey30
hi TabLine term=underline cterm=underline gui=underline guibg=grey30
hi TabLineSel term=none cterm=none gui=none
" --------------------
" ---- [9] OS SPECIFIC ----
" Windows
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" --------------------
" ---- [10] STATUSLINE ----
set laststatus=2
hi clear StatusLine
hi StatusLine gui=underline
set statusline=%<\[%f\]\ %{MyStatusLine()}\ %y\ %m%=%-14.(%l-%c%)\ %P

function! MyStatusLine()
	if !exists("b:statusLineVar")
		call SlowStatusLine()
	endif
	return b:statusLineVar
endfunction

function! SlowStatusLine()
	let SlowStatusLineVar = ""
	if &modifiable
		let gitTemp = system("git -C " . expand("%:h") . " status -b -s")
		let gitTemp = substitute(gitTemp, "##" , "", "")
		let gitTemp = substitute(gitTemp, "\\.\\.\\." , "-", "")
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
				let SlowStatusLineVar .= " [nc " . (len(gitList) -1) . "]"
			endif

			let changedRows = []
			let rowsTemp = split(system("git -C " . expand("%:h") . " diff --stat"), "\n")
			for row in rowsTemp
				if row =~ escape(expand('%:t'), ".")
					let changedRows = split(row, "|")
				endif
			endfor
			if(len(changedRows) > 0)
				let SlowStatusLineVar .= " [cr " . split(changedRows[1], " ")[0] . "]"
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

	function! PostSmartTab()
		if !pumvisible() && g:PosBeforeCompletion == col('.')
			call UltiSnips#JumpForwards()
		endif
		return ""
	endfunction

	" No complete-as-you-type, instead tab autocompletes/open completion window.
	let g:neocomplcache_disable_auto_complete = 1
	inoremap <TAB> <C-R>=SmartTab()<CR><C-R>=PostSmartTab()<CR>
endfunction
" --------------------
" ---- [12] TERMINALVIM ----
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
" --------------------
" ---- [13] AFTER VIMRC ----
if !exists("g:reload")
	let g:reload = 1
endif

" More discreet color for whitespaces.
hi SpecialKey guifg=grey40
" --------------------
