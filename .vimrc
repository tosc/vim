
" ---- [0] Defining variables ----
let s:CompletionCommand = "\<C-X>\<C-N>"

function! CompletionCommand(complKeys)
	if a:complKeys == "K"
		let s:CompletionCommand = "\<C-X>\<C-K>"
	elseif a:complKeys == "N"
		let s:CompletionCommand = "\<C-X>\<C-N>"
	elseif a:complKeys == "O"
		let s:CompletionCommand = "\<C-X>\<C-O>"
	endif
endfunction

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

" ---- [1] Normal vimsettings ----
set nocompatible
set number
set showmatch
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

set ignorecase
set smartcase

set cryptmethod=blowfish
set formatoptions-=cro

" Sets what backspace works on
set backspace=indent,eol,start

let $LANG = 'en'

colorscheme desert

cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == "h" ? "tab h" : "h"
" ---------

" ---- [2] Session settings ----
set sessionoptions-=options
set sessionoptions-=folds

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

if !exists("g:reload")
	autocmd BufWritePost * call SaveSession()
endif
" --------------------

" ---- [3] Plugins ----
" ---- [3.0] VUNDLE ----
if !exists("g:reload")
	" Required by vundle
	filetype off
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()
	Bundle 'gmarik/vundle'

	" Vundle addons"
	Bundle "SirVer/ultisnips"  
	Bundle 'nosami/Omnisharp'
	Bundle 'tpope/vim-dispatch'
	Bundle 'jcf/vim-latex'
	Bundle 'tpope/vim-fugitive'
	Bundle 'Rip-Rip/clang_complete'
	Bundle 'Shougo/vimproc'
	Bundle 'Shougo/vimshell'
	Bundle 'Shougo/unite'
	Bundle 'terryma/vim-multiple-cursors'
	Bundle 'Shougo/neomru'
	Bundle 'Shougo/unite-help'
	Bundle 'Shougo/unite-outline'
	Bundle 'Shougo/unite-build'
	Bundle 'Shougo/unite-session'
	Bundle 'skeept/ultisnips-unite'
"	Bundle 'airblade/vim-gitgutter'
	" Required by vundle
	filetype plugin indent on
	syntax on
endif
" ----------

" ---- [3.1] ULTISNIPS ----
" Ultisnips bindings
" f9 just to remove them. TODO look for better way to remove binding
let g:UltiSnipsExpandTrigger="<f10>"
let g:UltiSnipsJumpForwardTrigger="<f9>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets = "<f9>"

" Global variables that UltiSnips_ExpandSnippet and UltiSnips_JumpForwards
" calls when used.
let g:ulti_expand_res = 0 "default value, just set once
let g:ulti_jump_forwards_res = 0 "default value, just set once

" Handles all the different <TAB> bindings in the correct order.
" 1: Expand word if expandable
" 2: Choose next word in omnicomplete if omnicompletewindow visible
" 3: Jump to next jump in snippet if another jump is avalible
" 4: Normal tab

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

function! SmartEnter()
	call UltiSnips#JumpForwards()
	if g:ulti_jump_forwards_res 
		return ""
	else
		return "\<CR>"
	endif
endfunction

" Adds a new split when running ultisnips edit instead of taking over the
" current window
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

" ---- [3.4] LATEX ----
" Cursor hold delay = 1sek
set updatetime=1000
if !exists("g:reload")
	" Compile latex to a pdf when you save
	autocmd BufWritePost *.tex silent !start /min pdflatex %
	" Save when you leave insertmove
	autocmd InsertLeave *.tex nested w
	"Save when you don't do any editing for a while
	autocmd CursorHold *.tex nested w
	autocmd CursorHoldI *.tex nested w
endif
" ---------------

" ---- [3.5] UNITE ----
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_update_time = 300

function! s:unite_settings()
	nnoremap <buffer> <ESC> <Plug>(unite_all_exit)
	nnoremap <buffer> <BS> <Plug>()
	inoremap <buffer> <TAB> <Plug>(unite_select_next_line)
	inoremap <buffer> <S-TAB> <Plug>(unite_select_previous_line)
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

let s:bufferaction = {'description' : 'verbose', 'is_selectable' : 1,}

call unite#custom#source('file_rec', 'ignore_pattern', join(['.pyc$', '.exe$', '.o$'], '\|'))
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'ignore_pattern', join([
			\ '.pyc$',
			\ '.o$',
			\ ], '\|'))
" call unite#custom#source('tab', 'ignore_pattern', join(['unite'], '\|'))
call unite#custom#default_action('buffer', 'goto')

call unite#filters#matcher_default#use(['matcher_fuzzy'])
" --------------------

" ---- [3.6] VIMSHELL ----
" let g:vimshell_prompt = "% "
" let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'


" Use current directory as vimshell prompt.
let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
" --------------------

" ---- [3.7] GITGUTTER ----
hi clear SignColumn

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
" --------------------
" --------------------

" ---- [4] FOLDING ----
" ---- [4.0] FOLDSETTINGS ----
set foldmethod=expr
set foldnestmax=2
set foldopen=mark
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
	if indent(a:lnum) == 8 && line =~'}'
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

" Indentionfolding
function! IndentFolding(lnum)
	if indent(a:lnum)/8 < indent(a:lnum+1)/8
		return ">" . indent(a:lnum+1)/8
	else
	return indent(a:lnum)/8
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

" ---- [5] Filetype specific ----
" ---- [5.0] JAVA specific ----
" Removes all other types of matches from the omnicomplete, ex smartcomplete
" so that completeopt=longest will work
autocmd Filetype java setlocal omnifunc=JavaOmni
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
autocmd Filetype java let s:CompletionCommand = "\<C-X>\<C-O>"
" --------

" ---- [5.1] C# specific ----
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
autocmd Filetype cs let s:CompletionCommand = "\<C-X>\<C-O>"
" ----------------

" ---- [5.2] C specific ----
autocmd Filetype c,cpp setlocal omnifunc=COmni
function! COmni(findstart, base)
	let words = eclim#c#complete#CodeComplete(a:findstart, a:base)
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
"autocmd Filetype c,cpp let s:CompletionCommand = "\<C-X>\<C-O>"
autocmd Filetype c,cpp let s:CompletionCommand = "\<C-X>\<C-U>"
" --------------------

" ---- [5.3] VIMRC specific ----
autocmd Filetype vim setlocal foldexpr=VimrcFolding(v:lnum)
autocmd Filetype vim setlocal foldtext=NormalFoldText()
autocmd Filetype vim let s:CompletionCommand = "\<C-X>\<C-P>"
autocmd Filetype vim let &foldlevel=0

if !exists("g:reload")
	autocmd BufWritePost .vimrc so ~/Dropbox/vim/.vimrc
endif
" -------------

" ---- [5.4] SNIPPET specific ----
autocmd Filetype snippets setlocal foldexpr=SnippetFolding(v:lnum)
autocmd Filetype snippets setlocal foldtext=NormalFoldText()
autocmd Filetype snippets let s:CompletionCommand = "\<C-X>\<C-P>"
" --------------------

" ---- [5.5] todo specific ----
autocmd BufEnter *.todo setlocal filetype=todo
autocmd Filetype todo setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype todo setlocal foldtext=NormalFoldText()
autocmd Filetype todo let s:CompletionCommand = "\<C-X>\<C-P>"
" --------------------

" ---- [5.6] PYTHON specific ----
autocmd Filetype python setlocal omnifunc=PythonOmni
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
autocmd Filetype python let s:CompletionCommand = "\<C-X>\<C-P>"
" --------------------

" ---- [5.7] LUA specific ----
autocmd Filetype lua setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype lua setlocal foldtext=NormalFoldText()
autocmd Filetype lua let s:CompletionCommand = "\<C-X>\<C-P>"
" -------------

" ---- [5.8] make specific ----
autocmd Filetype make setlocal foldexpr=IndentFolding(v:lnum)
autocmd Filetype make setlocal foldtext=NormalFoldText()
autocmd Filetype make let s:CompletionCommand = "\<C-X>\<C-P>"
" -------------

" ---- [5.9] pass specific ----
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
" --------------------

" ---- [6] Bindings ----
" ---- [6.0] Normal ----
" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>de

inoremap <C-F> <C-X><C-F>

" perform expression on cursor word | EX: select a number ex 5, 5ä, then
noremap ä viw"xc<C-R>=getreg('x')

noremap <Up> <C-W>k<C-W>
noremap <Down> <C-W>j<C-W>
noremap <Left> <C-W>h<C-W>
noremap <Right> <C-W>l<C-W>

" Runs my TabUltiNeo when you press tab
inoremap <TAB> <C-R>=SmartTab()<CR><C-R>=PostSmartTab()<CR>
snoremap <TAB> <ESC>:call UltiSnips#JumpForwards()<CR>
inoremap <CR> <C-R>=SmartEnter()<CR>


" When you press TAB and have something selected in visual mode, it saves it
" ultisnips and removes it.
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

noremap - :Unite -no-split window buffer file_mru directory_mru file file/new <CR>

noremap <space> za
" --------------------

" ---- [6.1] Leader ----
let mapleader="ö"

" A
map <leader>ad :call CompletionCommand("K")<CR>
map <leader>ao :call CompletionCommand("O")<CR>
map <leader>af :call CompletionCommand("N")<CR>
" B
" C
map <leader>c :w <CR>:make <CR>
" D
map <leader>d :bn <CR>:bd # <CR>
" E
" F
map <leader>f :Unite -no-split -auto-preview -no-start-insert grep:. <CR>
" G
" H
map <leader>h :Unite -no-split -auto-preview -no-start-insert help<CR>
" I
" J
" K
" L
" M
autocmd Filetype python map <buffer><silent> <leader>m :w <bar> ! python % <cr>
autocmd Filetype c map <buffer><silent> <leader>m :w <bar> make <bar> !./%:r <cr>
autocmd Filetype cpp map <buffer><silent> <leader>m :w <bar> make <bar> !./main <cr>
" N 
map <leader>n :bn <CR>
map <leader>N :bp <CR>
" O
" P 
map <leader>p :bp <CR>
" Q
map <leader>q :call QFix()<CR>
" R 
map <leader>r :Unite -no-split -auto-preview -no-start-insert build:make <CR>
" S
map <leader>se :setlocal spell spelllang=en_us <CR>
map <leader>ss :setlocal spell spelllang=sv <CR>
map <leader>so :setlocal nospell <CR>
" T
map <leader>t :e ~/Dropbox/vim/main.todo <CR>
" U
map <leader>ue :Unite -no-split -no-start-insert file:~/vimfiles/Ultisnips <CR>
map <leader>uu :Unite -no-split ultisnips <CR>
" V
" W
" X
" Y
" Z
map <leader>z :Unite -no-split -no-start-insert session<CR>
" !
" -
" /
" --------------------
" --------------------

" ---- [7] Tabs ----
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

" ---- [8] OS specific ----
" Windows
if(has("win32"))
	"set shell=C:\mingw\msys\1.0\bin\bash.exe
endif
" --------------------

" ---- [9] STATUSLINE ----
set laststatus=2
hi clear StatusLine
hi StatusLine gui=underline
if !exists("g:reload")
	autocmd BufWritePost,BufRead * call SlowStatusLine()

	au InsertEnter * hi StatusLine gui=reverse
	au InsertLeave * hi StatusLine guibg=NONE gui=underline
endif

function! SlowStatusLine()
	let SlowStatusLineVar = "[" . expand("%") . "] "
	let dir = expand("%:h")
	let gitTemp = system("git -C " . expand("%:h") . " status -b -s")
	let gitTemp = substitute(gitTemp, "##" , "", "")
	let gitTemp = substitute(gitTemp, "\\.\\.\\." , "-", "")
	if gitTemp !~ "fatal" 
		let gitList = split(gitTemp, "\n")
		if len(gitList) > 0
			let branchName = gitList[0]
			let branchName = substitute(branchName, " ", "[", "")
			let branchName = substitute(branchName, " ", "] ", "")
			let SlowStatusLineVar .= branchName
		endif
		if len(gitList) > 1
			let SlowStatusLineVar .= " [nc " . (len(gitList) -1) . "]"
		endif
	endif
	let &l:statusline=SlowStatusLineVar
endfunction
" --------------------

" ---- [10] AFTER VIMRC ----
if !exists("g:reload")
	let g:reload = 1
endif
" --------------------

" ---- [11] Fresh Install ----
" 1. Create a tmp folder, .vim/tmp for backup files.
" 2. Create session folder, .vim/session for sessionrestoring.
" 3. Link this vimrc to your homedir. 
" 4. Run :BundleInstall.
" 5. Link Ultisnips snippetfolder from Dropbox.
" 6. Build clang. Go into clang folder and run make install.
" 7. Eclim. Download the appropriate eclim version for your version of eclipse. Run jar.
" 8. Vimshell. Compile 
" 		Windows : make -f make_mingw32.mak
" 		mac 	: make -f make_mac.mak
" 		unix 	: make -f make_unix.mak

" For Windows install
" 1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/??/bin to path.
" 2. Add VIM as editor for files without extension.
" 		[HKEY_CLASSES_ROOT.] @="No Extension"
" 		[HKEY_CLASSES_ROOT\No Extension]
" 		[HKEY_CLASSES_ROOT\No Extension\Shell]
" 		[HKEY_CLASSES_ROOT\No Extension\Shell\Open]
" 		[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"
" --------------------

" ---- [12] Troubleshooting ----
" Omnisharp. Check omnisharp github for installation. (It may work without any special installation, if not, you may have to build the server component again. If you are on linux then you have to update your .slnfiles with correct paths.)
" Ultisnips - If completion doesn't work but ,u opens the correct file, check if there is another vimfiles folder and add a symlink to that one aswell. (Had to symlink UltiSnips to both _vimfiles and vimfiles last time to get it to work.)
" --------------------

