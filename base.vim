"       BASE VIM
" ---- [0] Init ----------------------
let requiredFolders = [
		\ "~/.vim",
		\ "~/.vim/tmp",
		\ "~/.vim/tmp/tmp",
		\ "~/.vim/tmp/swapfiles"]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
	endif
endfor
let g:mrufile = expand("~/.vim/tmp/mru")
let g:explorerpath = expand("~" . "/")
if !filereadable(g:mrufile)
	call writefile(([]), g:mrufile)
endif
" ------------------------------------
" ---- [1] Vimsettings ---------------
autocmd!
set nocompatible
set modelines=0
set relativenumber
set guioptions=c
set incsearch
set ruler
set completeopt=menu,longest
set tabpagemax=100
set notimeout
set guifont=Inconsolata\ bold\ 10
	" If you need to change this on another computer just use 
	" set guifont=*
	" Pick the font and size you want. Then type
	" set guifont?
	" To get the value you want to set guifont too. Then add that to your
	" local .vimrc.
set wildmode=longest:full,list
set directory=~/.vim/tmp/swapfiles//
set shortmess+=A
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
set updatetime=1000
set backspace=indent,eol,start
let $LANG = 'en'
set colorcolumn=78
set textwidth=0
set wrapmargin=0
set encoding=utf-8
set shellslash

" Shows whitespaces and tabs when using list.
set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ 
set list

set showbreak=<<
set sessionoptions-=options
set sessionoptions+=folds

"Disables bug with bg using putty
set t_ut=

syntax on
" ------------------------------------
" ---- [2] Bindings ------------------
" ---- [2.0] Normal-bindings ---------
" I keep pressing << >> in the wrong order. HL are good for directions.
nnoremap H <<
nnoremap L >>

nnoremap <C-J> :call SmartJump()<CR>
nnoremap <C-K> :call SmartJumpBack()<CR>

" Wanted a easier bind for $
nnoremap + $

" Do last recording. (Removes exmode which I never use.)
nnoremap Q @@

"Not vi-compatible but more logical. Y yanks to end of line.
nnoremap Y y$

" Close everything except current fold.
nnoremap zV zMzv

nnoremap ä :call Explorer(["line"])<CR>
nnoremap ö :call Explorer(["buffer", "mru"])<CR>
nnoremap Ö :call Explorer(["dir", "file"])<CR>

"Switches repeat f/F, feels more logical on swedish keyboard.
nnoremap , ;
nnoremap ; ,

"Linux arrowkeys
map OD <left>
map OC <right>
map OA <up>
map OB <down>

" Select pasted text.
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" Reverse local and global marks and bind create mark to M (except for g)
" and goto mark ` to m.
nnoremap M m
nnoremap m `
nnoremap M! :delmarks A-Z<CR>
nnoremap m! :delmarks A-Z<CR>
function! BindMark(uMap)
	let lMap = tolower(a:uMap)
	execute "nnoremap M" . lMap . " m" . a:uMap
	execute "nnoremap M" . a:uMap . " m" . lMap
	execute "nnoremap m" . lMap . " `" . a:uMap
	execute "nnoremap m" . a:uMap . " `" . lMap
endfunction
let g:marks = split("A B C D E F H I J K L M N O P Q R S T U V W X Y Z")
function! StartBind()
	for i in range(len(g:marks))
		call BindMark(g:marks[i])	
	endfor
endfunction
call StartBind()
" ------------------------------------
" ---- [2.1] Insert-bindings ---------
" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap  <C-W>
inoremap <C-Del> <C-O>de
inoremap [3;5~ <C-O>de

" Shift-Enter acts like O in normal
inoremap <S-CR> <C-O>O

" Autocomplete spelling
inoremap <C-S> <C-X><C-S>

" Tab completion
inoremap <TAB> <C-R>=CustomTab()<CR>
inoremap <S-TAB> <C-P>

inoremap <C-J> <C-R>=SmartJump()<CR>
inoremap <C-K> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <C-O>A
inoremap <C-B> <left>
inoremap <C-F> <right>
inoremap <C-H> <Backspace>

" Enter works even when completionmenu is up.
inoremap <expr> <CR> pumvisible() ? '<C-E><CR>' : "\<CR>"
" ------------------------------------
" ---- [2.2] Visual-bindings ---------
" I keep pressing << >> in the wrong order. HL are good for directions.
" Also reselects after action.
vnoremap H <gv
vnoremap L >gv

"Switches repeat f/F, feels more logical on swedish keyboard.
vnoremap , ;
vnoremap ; ,

xnoremap + $

xnoremap å c<C-R>=PythonMath()<CR>
" ------------------------------------
" ---- [2.3] Leader-bindings ---------
let g:mapleader="\<space>"

" A
" B
" C - Compile
" D - Delete buffer
map <leader>d :bd<CR>
map <leader>D :bd!<CR>
" E - Start external
autocmd Filetype tex map <leader>e :Spawn! -dir=~ .vim\tmp\tmp\main.pdf <cr>
" F
" G - Git
map <leader>gc :!git -C %:h commit<CR>
map <leader>gd :!git -C %:h diff<CR>
map <leader>gf :!git -C %:h fetch<CR>
map <leader>gF :!git -C %:h pull<CR>
map <leader>gg :!git -C %:h status<CR>
map <leader>gp :!git -C %:h push<CR>
map <leader>gP :!git -C %:h push --force<CR>
" Opens a interactive menu that lets you pick what commits to use/squash.
map <leader>gr :!git -C %:h rebase -i HEAD~

"HardReset
function! ResetGit()
	if confirm("Reset git to remote?", "y\nn") == 1
		echo system("git -C " . expand("%:p:h") . " reset --hard origin/HEAD")
	endif
endfunction
map <leader>gR :call ResetGit()<CR>

map <leader>g? :call ShowVimSection(2,3)<CR>
" H - Help, show binds.
map <leader>hn :call ShowVimSection(2,0)<CR>
map <leader>hi :call ShowVimSection(2,1)<CR>
map <leader>hv :call ShowVimSection(2,2)<CR>
map <leader>hl :call ShowVimSection(2,3)<CR>
map <leader>hh :call ShowVimSection(2,3)<CR>
map <leader>hc :call ShowVimSection(2,5)<CR>
" I - Information, notes on helpful things.
map <leader>i :call Explorer(["notes"])<CR>
" J - Format json file.
" K
" L
" M - Make
autocmd Filetype c map <buffer><silent> <leader>m :w <bar> !./%:r <cr>
autocmd Filetype cpp map <buffer><silent> <leader>m :w <bar> ! main <cr>
autocmd Filetype cs map <buffer><silent> <leader>m :w <bar> ! main <cr>
autocmd Filetype vim map <leader>m :so % <cr>
autocmd Filetype python map <buffer><silent> <leader>m :w <bar> ! python % <cr>
" N - Next buffer
map <leader>n :bn <CR>
" O - Open file explorer
" P - Previour buffer
map <leader>p :bp <CR>
" Q - Quickfix commands
map <leader>qn :cn <CR>
map <leader>qp :cp <CR>
map <leader>qo :copen <CR>
" R - Run file or project / Stop file or project
" S - Spellcheck
map <leader>se :call EnglishSpellCheck() <CR>
map <leader>ss :call SwedishSpellCheck() <CR>
map <leader>so :call NoSpellCheck() <CR>
map <leader>sc :call NoSpellCheck() <CR>
map <leader>sd :call NoSpellCheck() <CR>
" T - Tabs, temp and tabformat
map <leader>tt :call OpenTempFile() <CR>
function! OpenTempFile()
	let fe = expand("%:e")	
	if len(fe) > 0
		e ~/.vim/tmp/tmp/temp.%:e
	else
		e ~/.vim/tmp/tmp/temp
	endif
endfunction
map <leader>td :execute("e " . expand(g:todofile))<CR>
map <leader>ta :call TodoAdd()<CR>
" Show/Hide tabs
map <leader>ts :set listchars=tab:>\ ,trail:#,extends:>,precedes:<,nbsp:+ <CR>
map <leader>tS :set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ <CR>
map <leader>tc :tabclose <CR>
map <leader>tn :tabnew <CR>
" U - Ultisnips
" V - .vimrc
map <leader>vr :e ~/git/vim/README.md<CR>
map <leader>vv :e ~/git/vim/base.vim<CR>
map <leader>vb :e ~/git/vim/base.vim<CR>
map <leader>vf :e ~/git/vim/folding.vim<CR>
map <leader>vd :vert diffsplit
" W
" X
" Y
" Z - Z(S)essions
" ?
map <leader>? :call ShowVimSection(2,3)<CR>
" ------------------------------------
" ---- [2.4] Omap-bindings -----------
"This adds $$ as textobjects.	
onoremap a$ :<c-u>normal! F$vf$<cr>
onoremap i$ :<c-u>normal! T$vt$<cr>
onoremap am :<c-u>normal! F$vf$<cr>
onoremap im :<c-u>normal! T$vt$<cr>

" Wanted binds like cib ciB but for [] and <> "" ''
onoremap ad a[
onoremap aD a<
onoremap aq a"
onoremap at a'

onoremap id i[
onoremap iD i<
onoremap iq i"
onoremap it i'
" ------------------------------------
" ---- [2.5] Command-bindings --------
cnoremap <C-BS> <C-W>

" Readline bindings.
cnoremap <C-A> <home>
cnoremap <C-E> <end>
cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
cnoremap <C-B> <left>
cnoremap <C-F> <right>

cnoremap <expr> h<space> getcmdtype() == ":" && getcmdline() == "" ? "tab help " : "h "
cnoremap <expr> n getcmdtype() == ":" && getcmdline() == "t" ? 'abnew' : "n"
cnoremap <expr> c getcmdtype() == ":" && getcmdline() == "t" ? 'abc' : "c"

cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>!git" : "t"

"tt filename opens opens a file with filename in a tmp folder.
cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "t" ? "\<bs>Tt" : "t"
command -nargs=1 Tt :e ~\.vim\tmp\tmp\<args>

" Maps :W to :w. To prevent errors when I sometimes hold shift too long during save.
command W :w

" Show the my normal and insert bindings.
cnoremap <expr> ? getcmdtype() == ":" && getcmdline() == "g" ? 
			\ "\<bs>" . 'call ShowVimSection(2,5)<CR>' : '?'
" ------------------------------------
" ---- [2.6] Temp-bindings -----------
function! TempBufferBinds()
	nnoremap <buffer> <ESC> :execute("bd")<CR>
endfunction
autocmd FileType tempbuffer call TempBufferBinds()
" ------------------------------------
" ---- [2.7] Todo-bindings -----------
function! TodoBindings()
	nnoremap <buffer> <ESC> :execute("bd")<CR>
	nmap <buffer> - :call TodoToggle()<CR>
	nmap <buffer> e :call TodoE()<CR>
endfunction
" ------------------------------------
" ---- [2.8] Explorer-bindings -------
function! ExplorerBindings()
	nnoremap <buffer> <ESC> :execute("bd")<CR>
	nnoremap <buffer> <CR> :call ExplorerOpen()<CR>
	inoremap <buffer> <CR> <ESC>:call ExplorerOpen()<CR>
	inoremap <buffer> <TAB> <ESC>:call ExplorerTab()<CR>
endfunction
" ------------------------------------
" ------------------------------------
" ---- [3] Filetype ------------------
" ---- [3.0] All-filetype ------------
autocmd FileType * setlocal formatoptions-=cro
" ------------------------------------
" ---- [3.1] Java-filetype -----------
function! JavaSettings()
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

autocmd Filetype java call JavaSettings()
" ------------------------------------
" ---- [3.2] Cs-filetype -------------
function! CSSettings()
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

autocmd Filetype cs call CSSettings()
" ------------------------------------
" ---- [3.3] C-filetype --------------
function! CSettings()
	setlocal foldexpr=BraceFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype c,cpp call CSettings()
" ------------------------------------
" ---- [3.4] Vim-filetype ------------
function! VimSettings()
	setlocal foldexpr=VimrcFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Pentadactyl file is a vim file.
autocmd BufRead .pentadactylrc set filetype=vim
autocmd Filetype vim call VimSettings()
" ------------------------------------
" ---- [3.5] Snippet-filetype --------
function! SnippetSettings()
	setlocal foldexpr=SnippetFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	setlocal foldmethod=expr
endfunction

autocmd Filetype snippets call SnippetSettings()
" ------------------------------------
" ---- [3.6] Todo-filetype -----------
function! TODOSettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	syntax match TodoSettings /\S\zs\t[^\t]*$/ conceal
endfunction

function! TODOStart()
	setlocal filetype=todo
	call TodoView()
endfunction

" Files that end with .td are now todofiles.
autocmd BufEnter *.todo call TODOStart()
autocmd Filetype todo call TODOSettings()
" ------------------------------------
" ---- [3.7] Python-filetype ---------
function! PythonSettings()
	setlocal omnifunc=
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=PythonFoldText()
endfunction

autocmd Filetype python call PythonSettings()
" ------------------------------------
" ---- [3.8] Lua-filetype ------------
function! LUASettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype lua call LUASettings()
" ------------------------------------
" ---- [3.9] Make-filetype -----------
function! MAKESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype make call MAKESettings()
" ------------------------------------
" ---- [3.10] Pass-filetype ----------
function! PASSSettings()
	setlocal foldexpr=PassFolding(v:lnum)
	setlocal foldtext=PassFoldText()
	setlocal foldminlines=0
endfunction

function! GenPass(...)
let l:passLen = (a:0 > 0 ? a:1 : 8)
let l:password = ""
if l:passLen > 0
python << endpy
import random, string, vim, sys
characters = string.ascii_letters + string.digits + '@&-_=+?!'
passLen = int(vim.eval("l:passLen"))
password = "".join(random.choice(characters) for x in range(0,passLen))
vim.command("let l:password = '" + str(password) + "'")
endpy
endif
execute "normal a" . l:password
endfunction

" Files that end with .pass are now password files.
autocmd BufNewFile,BufRead *.pass set filetype=pass

autocmd Filetype pass call PASSSettings()
" ------------------------------------
" ---- [3.11] Japanese-filetype ------
function! JAPANESESettings()
	set guifont=MS_Gothic:h16:w8
	set fileencoding=utf-8
endfunction

" Files that end with .jp are now japanese files.
autocmd BufNewFile,BufRead *.jp set filetype=jp

autocmd Filetype jp call JAPANESESettings()
" ------------------------------------
" ---- [3.12] Latex-filetype ---------
function! TEXSettings()
	setlocal foldexpr=TexFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd Filetype tex,plaintex call TEXSettings()
" ------------------------------------
" ---- [3.13] Gitcommit-filetype -----
function! GITCSettings()
	let &foldlevel = 99
	call EnglishSpellCheck()
endfunction

autocmd FileType gitcommit call GITCSettings()
" ------------------------------------
" ---- [3.14] Markdown-filetype ------
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd FileType markdown call MDSettings()
" ------------------------------------
" ---- [3.15] Help-filetype ----------
function! HelpIfHelp()
	if getbufline("%", "1")[0] =~ '^\*\S*\*\s*'
		setlocal filetype=help
	endif	
endfunction

autocmd BufRead *.txt call HelpIfHelp()
autocmd BufWritePost */git/info/notes/* helptags ~/git/info
" ------------------------------------
" ------------------------------------
" ---- [4] Statusline ----------------
set laststatus=2
set statusline=%<\[%f\]\ %y\ \ %m%=%-14.(%l-%c%)\ %P
" ------------------------------------
" ---- [5] Colorsettings -------------
" ---- [5.0] Default-colorsettings ---
colorscheme desert

" Change to better colors when using a terminal
" http://misc.flogisoft.com/_media/bash/colors_format/256_colors_bg.png
if has("terminfo")
	if !has("gui_running")
		let &t_Co=256
		set background=light
	endif
endif

hi Normal ctermbg=236 ctermfg=15 cterm=bold
hi Identifier ctermfg=120 cterm=bold
hi Title ctermfg=203 cterm=bold
hi SpecialKey ctermfg=8 cterm=bold guifg=grey40
hi NonText ctermfg=7 ctermbg=8
hi IncSearch ctermfg=191 ctermbg=8
hi Search ctermfg=15 ctermbg=172
hi MoreMsg ctermfg=22
hi Visual ctermbg=228 ctermfg=64
hi Folded ctermbg=239 ctermfg=11 cterm=bold
hi FoldColumn ctermbg=8 ctermfg=178
hi Constant ctermfg=174 cterm=bold
hi Statement ctermfg=228 cterm=bold
hi PreProc ctermfg=9 cterm=bold
hi Type ctermfg=185 cterm=bold
hi Todo ctermfg=9 cterm=bold
hi Special ctermfg=229 cterm=bold
hi Normal ctermfg=15
hi SpellBad ctermbg=NONE cterm=underline ctermfg=NONE gui=underline
hi SpellCap ctermbg=NONE cterm=underline ctermfg=NONE gui=underline
hi SpellLocal ctermbg=NONE cterm=underline ctermfg=NONE gui=underline
hi SpellRare ctermbg=NONE cterm=underline ctermfg=NONE gui=underline
hi Comment ctermfg=123 cterm=bold
hi TabLineFill cterm=underline gui=underline guibg=grey30 ctermbg=239
hi TabLine cterm=underline gui=underline guibg=grey30 ctermbg=239 ctermfg=NONE
hi TabLineSel cterm=none gui=none ctermbg=NONE
hi MoreMsg cterm=bold ctermfg=10 guifg=springgreen
hi LineNr cterm=bold
hi CursorLineNr cterm=bold
hi Ignore cterm=bold ctermfg=236
hi Directory cterm=bold
hi Pmenu ctermfg=15 ctermbg=13 cterm=bold
hi PmenuSel ctermfg=15 cterm=bold
hi PmenuSbar ctermfg=NONE ctermbg=13
hi PmenuThumb ctermfg=NONE ctermbg=13
hi StatusLineNC ctermbg=239 ctermfg=15 cterm=bold guibg=grey40 guifg=NONE
hi StatusLine gui=underline guibg=NONE guifg=NONE cterm=underline
hi SignColumn guibg=NONE ctermbg=NONE
hi ColorColumn guibg=grey30 ctermbg=239
hi DiffAdd guibg=#002211 guifg=NONE ctermbg=22 ctermfg=NONE
hi DiffChange guibg=#000066 guifg=NONE ctermbg=17 ctermfg=NONE
hi DiffDelete guibg=#660000 guifg=red ctermbg=52 ctermfg=211
hi DiffText guibg=dodgerblue4 guifg=NONE ctermbg=23 ctermfg=NONE

autocmd InsertEnter * hi StatusLine gui=reverse cterm=reverse
autocmd InsertLeave * hi StatusLine guibg=NONE gui=underline cterm=underline
" ------------------------------------
" ---- [5.1] Todo-colorsettings ------
hi Todo0 ctermbg=236 ctermfg=15 cterm=bold guifg=white
hi Todo1 ctermbg=236 ctermfg=123 cterm=bold guifg=cyan
hi Todo2 ctermbg=236 ctermfg=45 cterm=bold guifg=springgreen1
hi Todo3 ctermbg=236 ctermfg=48 cterm=bold guifg=green3
hi Todo4 ctermbg=236 ctermfg=40 cterm=bold guifg=greenyellow
hi Todo5 ctermbg=236 ctermfg=154 cterm=bold guifg=olivedrab1
hi Todo6 ctermbg=236 ctermfg=226 cterm=bold guifg=yellow
hi Todo7 ctermbg=236 ctermfg=214 cterm=bold guifg=orange
hi Todo8 ctermbg=236 ctermfg=208 cterm=bold guifg=darkorange3
hi Todo9 ctermbg=236 ctermfg=202 cterm=bold guifg=indianred
hi Todo10 ctermbg=236 ctermfg=196 cterm=bold guifg=red
hi TodoRemove ctermbg=236 ctermfg=244 cterm=bold guifg=gray50
hi TodoSettings cterm=bold
" ------------------------------------
" ------------------------------------
" ---- [6] Autocmd -------------------
autocmd BufReadPost * call UpdateFileMRU()
" ------------------------------------
" ---- [7] Functions -----------------
" ---- [7.0] Tabcompletion-functions -
let s:CompletionCommand = "\<C-X>\<C-N>"
function! CustomTab()
	if getline(".")[col('.') - 2] =~ '\w'
		return (pumvisible() ? "\<C-E>" : "") . s:CompletionCommand
	else
		return "\<TAB>"
	endif
endfunction
" ------------------------------------
" ---- [7.1] Jump-functions ----------
" Jumps you to the next/previous ultisnips location if exists.
" Else it jumps to the next/previous delimiter.
" Else jumps to $/^
" To change default delimiters just change g:smartJumpElements
if !exists('g:smartJumpElements')
	let g:smartJumpElements = "[]'\"(){}<>\[\$]"
endif
function! SmartJump()
	pclose
	let cursorPos = getpos('.')
	let pos = match(getline('.'), g:smartJumpElements, cursorPos[2] - 1)
	if pos == -1
		normal $
	else
		let cursorPos[2] = pos + 1
		call setpos('.', cursorPos)
	endif
	call feedkeys("\<right>",'i')
	return ""
endfunction
function! SmartJumpBack()
	pclose
	let cursorPos = getpos('.')
	let newPos = match(getline('.'), g:smartJumpElements)
	let pos = newPos
	let matchCount = 1
	if pos == -1 || pos > cursorPos[2] + 1
		normal ^
		return ""
	endif
	while newPos < cursorPos[2] - 1
		if newPos == -1
			break
		endif
		let pos = newPos
		let newPos = match(getline('.'), g:smartJumpElements, 0, matchCount)
		let matchCount += 1
	endwhile
	if cursorPos[2] == pos + 1
		normal ^
	else
		let cursorPos[2] = pos + 1
		call setpos('.', cursorPos)
	endif
	return ""
endfunction
" ------------------------------------
" ---- [7.2] Temp-functions ----------
function! TempBuffer()
	if bufexists("[TempBuffer]")
		b TempBuffer
	else
		e [TempBuffer]
	endif
	execute "0,$d_"
	setlocal nobuflisted
	setlocal filetype=tempbuffer
	setlocal buftype=nofile
endfunction
function! AddVimSectionCall(section, subsection, filename)
	let vimfile = readfile(expand(a:filename))
	let sectionStart = 0
	for line in vimfile
		if line =~ '^" ----------------' && sectionStart
			break
		endif
		if sectionStart == 1
			put = line
		endif
		if a:subsection == -1
			if line =~ '^" ---- \[' . a:section . '\]'
				let sectionStart = 1	
			endif
		else
			if line =~ '^" ---- \[' . a:section . '\.' . a:subsection .'\]'
				let sectionStart = 1	
			endif
		endif
	endfor
endfunction
function! AddVimSection(section, subsection)
	call AddVimSectionCall(a:section, a:subsection, "~/git/vim/base.vim")
endfunction
function! ShowVimSection(section, subsection)
	call TempBuffer()
       	setlocal syntax=vim
	call AddVimSection(a:section, a:subsection)
	normal gg
endfunction
" ------------------------------------
" ---- [7.3] Spellcheck-functions ----
function! EnglishSpellCheck()
	setlocal spell spelllang=en_us
endfunction

function! SwedishSpellCheck()
	setlocal spell spelllang=sv
endfunction

function! NoSpellCheck()
	setlocal nospell
endfunction
" ------------------------------------
" ---- [7.4] Todo-functions ------

"Check for todofile. If you have a local one, use that. If you have
"the global one, use that. Else create a new local one.
if filereadable(expand("~/todo.todo"))
	let g:todofile = "~/todo.todo"
elseif filereadable(expand("~/git/info/todo.todo"))
	let g:todofile = "~/git/info/todo.todo"
else
	let g:todofile = "~/todo.todo"
	call writefile(([]), expand(g:todofile))
endif

function! TodoView()
	execute "0,$d_"
	setlocal nobuflisted
	setlocal nowrap
	setlocal buftype=acwrite
	call TodoBindings()
	autocmd BufWriteCmd <buffer> call TodoWrite() | setlocal nomodified
	autocmd BufLeave <buffer> call clearmatches()
	set filetype=todo
	setlocal conceallevel=2
	call TodoLoad()
	execute "0d_"
	call Todos()
	call TodoUpdate()
	normal gg
	setlocal nomodified
endfunction

"Reads todofile into buffer.
function! TodoLoad()
	for line in readfile(expand("%:p"))
		put = line
	endfor
endfunction

"Read buffer and turn all lines into todos.
function! Todos(...)
	let todos = []
	let lines = getbufline("%", 1, "$")
	if a:0 > 0
		let lines = a:1
	endif
	for line in lines
		let ftabs = len(split(line, "^\\t", "1")) - 1
		let todo = {
			\ 'line' : line,
			\ 'priority' : -1,
			\ 'remove' : 0,
			\ 'textOnly' : 0,
			\ 'textTodo' : 0,
			\ 'tabs' : ftabs,
			\ 'file' : ""}
		if len(matchstr(line, "^\\s*\\[-\\]")) > 0
			let todo.remove = 1
		endif
		let noiline = substitute(line, "^\\s*\\[\.\\] ", "", "")
		let info = split(noiline, "\t")
		let name = ""
		let settings = ""
		if len(info) > 0
			let name = info[0]
			if len(info) > 1
				let settings = info[1]
				let opts = split(settings, ",")
				while len(opts) > 0
					let opt = split(opts[0], "=")
					let type = opt[0]
					let opts = opts[1:]
					if type == "p"
						let todo.priority = str2nr(opt[1])
					elseif type == "f"
						let todo.file = opt[1]
					elseif type == "-"
						let todo.textTodo = 1
					endif
				endwhile
			endif
		endif
		let todo.name = name
		let indent = repeat("\t", todo.tabs)
		let todo.line = indent . "[ ] " . name . "\t" . settings

		call add(todos, todo)
	endfor
	"Go through all todos again updating all priorities.
	let index = 0
	while index < len(todos)
		let todo = todos[index]
		"This todo needs a priority
		if todo.priority == -1
			let prio = -1
			let index2 = index + 1
			while index2 < len(todos)
				let todo2 = todos[index2]
				if todo2.tabs <= todo.tabs
					break
				endif
				if todo.textTodo
					let todo2.textOnly = todo.textTodo
				endif
				if todo2.priority > prio
					let prio = todo2.priority
				endif
				let index2 += 1
			endwhile
			let todo.priority = prio
		"This todo has a priority
		else
			let index2 = index + 1
			while index2 < len(todos)
				let todo2 = todos[index2]
				if todo2.tabs <= todo.tabs
					break
				endif
				if todo.textTodo
					let todo2.textOnly = todo.textTodo
					let todo2.remove = todo.remove
				endif
				if todo2.priority == -1
					let todo2.priority = todo.priority
				endif
				let index2 += 1
			endwhile
		endif
		let index += 1
	endwhile
	let b:todos = todos
	call TodoUpdateBox()
endfunction

"Updates box before a todo into the right value.
function! TodoUpdateBox()
	for todo in b:todos
		if todo.textOnly
			let box = ""
		elseif todo.remove
			let box = "[-] "
		elseif todo.file != ""
			let box = "[f] "
		else
			let box = "[ ] "
		endif
		let todo.line = substitute(todo.line, "\\[\.\\] ", box, "")
	endfor
endfunction

"Colors each todo the right way.
function! TodoColor()
	let index = 1
	for todo in b:todos
		let prio = todo.priority
		let color = prio/10
		if color > 9
			let color = 10
		endif
		if color < 0
			let color = 0
		endif
		if todo.remove
			let color = "Remove"
		endif
		call matchaddpos("Todo" . color, [index])
		let index += 1
	endfor
endfunction

"Sorts all currently loaded todos.
function! TodoSort()
	"Pick a todo. Go down until you find the next todo with the same tabs.
	"Find the end of that todo.
	"Switch place with that todo if you have lower priority.
	"If you switched place, start over from the start.
	"If you didn't switch place and you reaced the end of the file or a 
	"tab that is smaller then yours then go pick the next todo.
	
	let todos = b:todos
	let index = 0
	while index < len(todos)
		let switched = 0
		let todo = todos[index]
		let index2 = index + 1
		"Find where the next todo starts.
		while index2 < len(todos)
			let todo2 = todos[index2]
			if todo2.tabs < todo.tabs
				break
			elseif todo2.tabs == todo.tabs
				let todostart = index
				let todoend = index2
				let todo2start = index2
				if todo2.priority > todo.priority
					let index3 = index2 + 1
					"Find end of next todoblock.
					while index3 < len(todos)
						let todo3 = todos[index3]
						if todo3.tabs <= todo2.tabs
							break
						endif
						let index3 += 1
					endwhile
					let todo2end = index3
					let sortedTodos = []
					let addindex = 0
					while addindex < todostart
						call add(sortedTodos, todos[addindex])
						let addindex += 1
					endwhile
					let addindex = todo2start
					while addindex < todo2end
						call add(sortedTodos, todos[addindex])
						let addindex += 1
					endwhile
					let addindex = todostart
					while addindex < todoend
						call add(sortedTodos, todos[addindex])
						let addindex += 1
					endwhile
					let addindex = todo2end
					while addindex < len(todos)
						call add(sortedTodos, todos[addindex])
						let addindex += 1
					endwhile
					let todos = sortedTodos
					let switched = 1
					break
				endif
			endif
			let index2 += 1
			if switched
				break
			endif
		endwhile
		let index += 1
		if switched
			let index = 0
		endif
	endwhile
	let b:todos = todos
endfunction

function! TodoUpdate()
	let curs = getpos('.')
	execute "0,$d_"
	for todo in b:todos
		put = todo.line
	endfor		
	execute "0d_"
	call TodoColor()
	call setpos('.', curs)
endfunction

function! TodoWrite()
	call Todos()
	let todos = []
	for todo in b:todos
		if !todo.remove
			call add(todos, todo)
		endif
	endfor
	let b:todos = todos
	call TodoUpdate()
	call Todos()
	call TodoSort()
	call TodoUpdate()
	let lines = getbufline("%", 1, "$")
	call writefile(getbufline("%", 1, "$"), expand("%:p"))
endfunction

function! TodoToggle()
	call Todos()
	let index = getcurpos()[1] - 1
	let todo = b:todos[index]
	if !todo.textOnly
		let todo.remove = !todo.remove
		let index += 1
		while index < len(b:todos)
			let todo2 = b:todos[index]
			if todo.tabs < todo2.tabs
				let todo2.remove = todo.remove
			else
				break	
			endif
			let index += 1
		endwhile
		call TodoUpdateBox()
	endif
	call TodoUpdate()	
endfunction

function! TodoAdd()
	let lines = readfile(expand(g:todofile))
	call Todos(lines)
	let lines = []
	let found = 0
	let newline = input("Input todo: ")
	let priority = input("Input priority: ")
	if priority != ""
		let newline = newline . "	p=" . priority
	endif
	for todo in b:todos
		call add(lines, todo.line)
		if todo.file == expand("%:p") && !found && expand("%:p") != ""
			call add(lines, repeat("	", todo.tabs + 1)
		       				\ . newline)
			let found = 1
		endif
	endfor
	if !found
		if expand("%:p") != ""
			call add(lines, expand("%:t") . "	f=" . expand("%:p"))
		endif
		call add(lines, "	" . newline)
	endif
	call writefile(lines, expand(g:todofile))
	unlet b:todos
endfunction

function! TodoE()
	call Todos()
	let index = getcurpos()[1] - 1
	let todo = b:todos[index]
	if todo.file != ""
		execute "e " . todo.file
	endif
endfunction

function! PreP()
	for todo in b:todos
		echo todo.priority . " - " . todo.line
	endfor
endfunction
" ------------------------------------
" ---- [7.5] Explorer-functions ------
"Open tagview.
function! Explorer(sources, ...)
	let tagfile = expand("%:p")
	let ftype = ""
	if a:0 > 0
		if index(a:sources, "dir") >= 0 || index(a:sources, "file") >= 0
			let g:explorerpath = a:1
		endif
		if index(a:sources, "line") >= 0
			let tagfile = a:1
		endif
	endif
	if index(a:sources, "line") >= 0 && tagfile != ""
		execute "e " . tagfile
		let ftype = &filetype
		execute "bd"
	endif
	if bufexists("[TagBuffer]")
		b ExplorerBuffer
	else
		e [ExplorerBuffer]
	endif
	execute "0,$d_"
	setlocal nobuflisted
	setlocal buftype=nofile
	call ExplorerBindings()
	autocmd TextChangedI <buffer> call ExplorerUpdate()
	autocmd BufLeave <buffer> call clearmatches()
	set filetype=tag

	let b:sources = a:sources
	let b:tagfile = tagfile
	if index(a:sources, "line") >= 0
		execute "set syntax=" . ftype
		setlocal norelativenumber
	endif

	put =' '
	if index(b:sources, "dir") >= 0 || index(b:sources, "file") >= 0
		call setline(1, g:explorerpath)
	endif

	call ExplorerTags()
	call ExplorerUpdate()
	normal gg
	startinsert
	call cursor(0, 100000)

   	syntax match Statement "\[mru\]"
   	syntax match Statement "\[dir\]"
   	syntax match Function "\[buffer\]"
   	syntax match Function "\[file\]"
   	syntax match SpecialKey "| \S*$"
endfunction

function! ExplorerTags()
	let tags = []
	let bufline = getbufline("%", 1)[0]
	for source in b:sources
		if source == "mru" || source == "notes"
			if source == "mru"
				let tagfile = g:mrufile
			elseif source == "notes"
				let tagfile = "~/git/info/tags"
			endif
			for line in readfile(expand(tagfile))
				let info = split(line, "\t")
				let tagname = info[0]
				let filename = info[1]
				let tagsearch = info[2]
				let tag = {
					\ 'name' : info[0],
					\ 'file' : info[1],
					\ 'tag' : info[2],
					\ 'alias' : "[" . source . "] " . info[0] . " | " . info[1],
					\ 'source' : source}
				call add(tags, tag)
			endfor
		elseif source == "buffer"
			let bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
			for buf in bufs
				let tag = {
					\ 'name' : fnamemodify(bufname(buf), ":t"),
					\ 'file' : bufname(buf),
					\ 'tag' : buf,
					\ 'source' : source}
				call add(tags, tag)
			endfor
		elseif source == "dir"
			call extend(tags, ExplorerFilesDirs(bufline . "*", source))
		elseif source == "file"
			call extend(tags, ExplorerFilesDirs(bufline . "*", source))
		elseif source == "line"
			let tagfile = b:tagfile
			let index = 1
			if tagfile != ""
				for line in readfile(expand(tagfile))
					if line != ""
						let tag = {
							\ 'name' : line,
							\ 'file' : b:tagfile,
							\ 'tag' : line,
							\ 'alias' : index . " " . line,
							\ 'lnum' : index,
							\ 'source' : source}
						call add(tags, tag)
					endif
					let index += 1
				endfor
			endif
		endif
	endfor
	let b:tags = tags
endfunction

function! ExplorerUpdate()
	let tags = []
	let search = split(getbufline("%", 1)[0], " ")
	let bufline = getbufline("%", 1)[0]
	if (index(b:sources, "dir") >= 0) || (index(b:sources, "file") >= 0)
		if bufline =~ "/$"
			let g:explorerpath = bufline
		else
			let g:explorerpath = fnamemodify(bufline, ":h") . "/"
		endif
		call ExplorerTags()
		let tags = b:tags
	else
		for tag in b:tags
			let found = 1
			for searcht in search
				if tag.name =~ searcht
				else
					let found = 0
					break
				endif
			endfor	
			if found
				call add(tags,tag)
			endif
		endfor
	endif
	let b:currentTags = tags
	call ExplorerDraw()
endfunction

function! ExplorerDraw()
	call clearmatches()
	let search = split(getbufline("%", 1)[0], " ")
	if index(b:sources, "dir") >= 0 || index(b:sources, "file") >= 0
		let search = split(getbufline("%", 1)[0], g:explorerpath)
	endif
	for searcht in search
		call matchadd("Constant", "\\c" . searcht)
	endfor
	let curs = getpos('.')
	if len(getbufline('%', 1, '$')) > 1
		execute "2,$d_"
	endif
	for tag in b:currentTags
		let line = "[" . tag.source . "] " . tag.name
		if has_key(tag, "alias") > 0
			let line = tag.alias
		endif
		put = line
	endfor
	call setpos('.', curs)
endfunction

function! ExplorerOpen()
	let tagindex = getpos('.')[1] - 2
	if tagindex < 0
		let tagindex = 0
	endif
	let tag = b:currentTags[tagindex]
	if tag.source == "mru"
		execute "e " . tag.file
	elseif tag.source == "notes"
		execute "e +" . tag.tag . " ~/git/info/" . tag.file
	elseif tag.source == "buffer"
		execute "b " . tag.tag
	elseif tag.source == "file"
		execute "e " . tag.file
	elseif tag.source == "line"
		execute "e +" . tag.lnum . " " . tag.file
	elseif tag.source == "dir"
		call ExplorerTab()
	endif
endfunction

function! ExplorerFilesDirs(path, source)
	let tags = []
	let stuff = split(glob(a:path), "\n")
	let bufline = getbufline("%", 1)[0]
	for line in stuff
		let tag = {
			\ 'name' : line,
			\ 'file' : line,
			\ 'tag' : line,
			\ 'alias' : "[" . a:source . "] " . fnamemodify(line, ":t"),
			\ 'source' : a:source}
		if isdirectory(line)
			if a:source == "dir"
				call add(tags, tag)
			endif
		else
			if a:source == "file"
				call add(tags, tag)
			endif
		endif
	endfor
	return tags
endfunction

function! ExplorerTab()
	let name = ""
	let bufline = getbufline("%", 1)[0]
	let longestList = []
	for tag in b:currentTags
		if tag.name =~ "^" . bufline
			call add(longestList, tag)
		endif
	endfor
	if len(longestList) > 0
		if len(longestList) == 1
			let name = longestList[0].name
			if longestList[0].source == "dir"
				let name .= "/"
			endif
		else
			let longest = ""
			let index = 0
			while 1
				let allowed = 1
				let char = longestList[0].name[index]
				for tags in longestList
					if tags.name[index] != char
						let allowed = 0
						break
					endif
				endfor
				if !allowed
					break
				endif
				let longest .= char
				let index += 1
			endwhile
			let name = longest
		endif
		call setline(1, name)
	endif
	call ExplorerUpdate()
	startinsert
	call cursor(0, 100000)
endfunction
" ------------------------------------
" ---- [7.6] Filemru-functions -------
function! UpdateFileMRU()
	let tags = readfile(g:mrufile)
	let correctTags = []
	let newtag = expand("%:t") . "\t" . expand("%:p") . "\t" . "0"
	call add(correctTags, newtag)
	for tag in tags
		if tag != newtag
			call add(correctTags, tag)
		endif
	endfor
	call writefile(correctTags, g:mrufile)
endfunction
" ------------------------------------
" ------------------------------------
" ---- [8] Tabline -------------------
function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tab = i + 1
		let bufname = ''
		for buf in tabpagebuflist(tab)
			let bufname .= (bufname != '' ? ' | ' : '')
			let bufname .= fnamemodify(bufname(buf), ':t') . 
					\ (getbufvar(buf, "&mod") ? "[+]" : "")
		endfor
		let s .= '%' . tab . 'T' . (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
		let s .= ' ' . tab . ' ' . (bufname != '' ? bufname . ' ' : '- ')
	endfor
	let s .= '%#TabLineFill#'
	return s
endfunction

set tabline=%!Tabline()
" ------------------------------------
" ---- [9] OS specific ---------------
" ---- [9.0] Windows -----------------
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" ------------------------------------
" ---- [9.1] Linux -------------------
if has('unix')
	if has("gui")
		set timeout
		set timeoutlen=1000
		set ttimeoutlen=0
	endif
endif
" ------------------------------------
" ------------------------------------
