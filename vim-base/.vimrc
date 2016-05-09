" ---- [0] INITIALIZATION ----
let requiredFolders = [
		\ "~/.vim",
		\ "~/.vim/tmp",
		\ "~/.vim/tmp/tmp"]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
	endif
endfor
" --------------------
" ---- [1] VIMSETTINGS ----
autocmd!
set nocompatible
set relativenumber
set guioptions=c
set incsearch
set ruler
set completeopt=menu,longest
set tabpagemax=100
set notimeout
if &guifont
	set guifont=Inconsolata\ bold\ 10
	" If you need to change this on another computer just use 
	" set guifont=*
	" Pick the font and size you want. Then type
	" set guifont?
	" To get the value you want to set guifont too. Then add that to your
	" local .vimrc.
endif
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

" Shows whitespaces and tabs when using list.
set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ 
set list

set showbreak=<<
set sessionoptions-=options
set sessionoptions+=folds

"Disables bug with bg using putty
set t_ut=

syntax on
" ---------
" ---- [2] BINDINGS ----
" ---- [2.0] NORMAL ----
" I keep pressing << >> in the wrong order. HL are good for directions.
nnoremap H <<
nnoremap L >>

" Wanted a easier bind for $
nnoremap + $

" Do last recording. (Removes exmode which I never use.)
nnoremap Q @@

"Not vi-compatible but more logical. Y yanks to end of line.
nnoremap Y y$

" Close everything except current fold.
nnoremap zV zMzv

nnoremap ä /
nnoremap ö :e 
nnoremap Ö :e 

"Switches repeat f/F, feels more logical on swedish keyboard.
nnoremap , ;
nnoremap ; ,

" Select pasted text.
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" Reverse local and global marks and bind create mark to M (except for g)
" and goto mark ` to m.
nnoremap M m
nnoremap m `
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

" Good avaliable binds
" §
" ´
" Enter
" Backspace
" Shift enter
" Ä
" s (synonym for cl)
" S (synonym for cc)
" --------------------
" ---- [2.1] INSERT ----
" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>de

" Shift-Enter acts like O in normal
inoremap <S-CR> <C-O>O

" Autocomplete spelling
inoremap <C-S> <C-X><C-S>

inoremap <expr><TAB> getline(".")[col('.') - 2] =~ '\w' ? '<C-X><C-N>' : SpecialDelim("\<TAB>")

inoremap <C-J> <C-R>=SmartJump()<CR>
inoremap <C-K> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <C-O>A
inoremap <C-B> <left>
inoremap <C-F> <right>
inoremap <C-H> <Backspace>

inoremap <A-B> <C-O>b
inoremap â <C-O>b
inoremap <A-F> <C-O>w
inoremap æ <C-O>w

" Enter works even when completionmenu is up.
inoremap <expr> <CR> pumvisible() ? '<C-E><CR>' : SpecialDelim("\<CR>")

" Text chains that do special tings in Insert.
let g:keychains = [
	\ [["{"], ["}", "\<left>"], ["opt"]],
	\ [["("], [")", "\<left>"], ["opt"]],
	\ [["<"], [">", "\<left>"], ["opt"]],
	\ [["["], ["]", "\<left>"], ["opt"]],
	\ [['"'], ['"', "\<left>"], ["opt"]],
	\ [["'"], ["'", "\<left>"], ["opt"]],
	\ [["{"], ["{", "\<bs>\<cr>\<cr>}\<up>"]],
	\ [["b"], ["b"], ["b", "\<bs>\<bs>\<bs>()"]],
	\ [["B"], ["B"], ["B", "\<bs>\<bs>\<bs>{}"]],
	\ [["d"], ["d"], ["d", "\<bs>\<bs>\<bs>[]"]],
	\ [["D"], ["D"], ["D", "\<bs>\<bs>\<bs><>"]],
	\ ]

" Special keys must be taken care of by my delim function.
inoremap <expr> <left> SpecialDelim("\<left>")
inoremap <expr> <right> SpecialDelim("\<right>")
inoremap <expr> <up> SpecialDelim("\<up>")
inoremap <expr> <down> SpecialDelim("\<down>")
inoremap <expr> <space> SpecialDelim("\<space>")
inoremap <expr> <bs> SpecialDelim("\<bs>")
" --------------------
" ---- [2.2] VISUAL ----
" I keep pressing << >> in the wrong order. HL are good for directions.
" Also reselects after action.
vnoremap H <gv
vnoremap L >gv

"Switches repeat f/F, feels more logical on swedish keyboard.
vnoremap , ;
vnoremap ; ,

xnoremap + $

xnoremap å c<C-R>=PythonMath()<CR>
" --------------------
" ---- [2.3] LEADER ----
let g:mapleader="\<space>"

" A
" B - Bookmark
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

map <leader>g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" H -<CR> :0,.-1d<CR>/^" I -<CR> :.,$d<CR>gg
" H - Help, show binds.
map <leader>hn :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.0\]<CR> :0,.-1d<CR>/^" ---- \[3.1\]<CR> :.,$d<CR>gg
map <leader>hi :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.1\]<CR> :0,.-1d<CR>/^" ---- \[3.2\]<CR> :.,$d<CR>gg
map <leader>hv :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.2\]<CR> :0,.-1d<CR>/^" ---- \[3.3\]<CR> :.,$d<CR>gg
map <leader>hl :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.3\]<CR> :0,.-1d<CR>/^" ---- \[3.4\]<CR> :.,$d<CR>gg
map <leader>hh :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.3\]<CR> :0,.-1d<CR>/^" ---- \[3.4\]<CR> :.,$d<CR>gg
map <leader>hc :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.5\]<CR> :0,.-1d<CR>/^" ---- \[3.6\]<CR> :.,$d<CR>gg
map <leader>hm :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r
	\ ~/git/vim/.vimrc <CR> /^" ---- \[9.2\]<CR>j :0,.-1d<CR>/^" --------<CR>
	\ :.,$d<CR>:call HelpMarkColor()<CR>
" I - Information, notes on helpful things.
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
" P - Quickfix commands
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
map <leader>te :set expandtab <CR>
map <leader>tE :set noexpandtab <CR>
map <leader>t4 :set tabstop=4 <CR> :set shiftwidth=4 <CR>
map <leader>t8 :set tabstop=8 <CR> :set shiftwidth=8 <CR>
" Show/Hide tabs
map <leader>ts :set listchars=tab:>\ ,trail:#,extends:>,precedes:<,nbsp:+ <CR>
map <leader>tS :set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ <CR>
map <leader>tc :tabclose <CR>
map <leader>tn :tabnew <CR>
" U - Ultisnips
" V - .vimrc
map <leader>vr :e ~/git/vim-base/README.md<CR>
map <leader>vv :e ~/git/vim-base/.vimrc<CR>
map <leader>vd :w !diff % -<CR>
" W
" X
" Y
" Z - Z(S)essions
" ?
map <leader>? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" H -<CR> :0,.-1d<CR>/^" I -<CR> :.,$d<CR>gg
" --------------------
" ---- [2.4] OMAP ----
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
" --------------------
" ---- [2.5] COMMAND ----
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
			\ "\<bs>" . 'call OpohBuffer() <bar> setlocal syntax=vim <bar>
			\ keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.4\]<CR>
			\ :0,.-1d<CR>/^" ---- \[3.5\]<CR> :.,$d<CR>gg' : '?'
" --------------------
" ---- [2.6] OPOHBUFFER ----
function! OpohBinds()
	nnoremap <buffer> <ESC> :execute("b #")<CR>
endfunction
autocmd FileType opoh call OpohBinds()
" --------------------
" --------------------
" ---- [3] FILETYPE SPECIFIC ----
" ---- [3.0] All ----
autocmd FileType * setlocal formatoptions-=cro
" --------
" ---- [3.1] JAVA ----
function! JavaSettings()
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

autocmd Filetype java call JavaSettings()
" --------
" ---- [3.2] C# ----
function! CSSettings()
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

autocmd Filetype cs call CSSettings()
" ----------------
" ---- [3.3] C ----
function! CSettings()
	setlocal foldexpr=BraceFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype c,cpp call CSettings()
" --------------------
" ---- [3.4] VIMRC ----
function! VimSettings()
	setlocal foldexpr=VimrcFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Pentadactyl file is a vim file.
autocmd BufRead .pentadactylrc set filetype=vim
autocmd Filetype vim call VimSettings()
" -------------
" ---- [3.5] SNIPPET ----
function! SnippetSettings()
	setlocal foldexpr=SnippetFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	setlocal foldmethod=expr
endfunction

autocmd Filetype snippets call SnippetSettings()
" --------------------
" ---- [3.6] TODO ----
function! TODOSettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Files that end with .td are now todofiles.
autocmd BufEnter *.td setlocal filetype=todo
autocmd Filetype todo call TODOSettings()
" --------------------
" ---- [3.7] PYTHON ----
function! PythonSettings()
	setlocal omnifunc=
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=PythonFoldText()
endfunction

autocmd Filetype python call PythonSettings()
" --------------------
" ---- [3.8] LUA ----
function! LUASettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype lua call LUASettings()
" -------------
" ---- [3.9] MAKE ----
function! MAKESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype make call MAKESettings()
" -------------
" ---- [3.10] PASS ----
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
" -------------
" ---- [3.11] JAPANESE ----
function! JAPANESESettings()
	set guifont=MS_Gothic:h16:w8
	set fileencoding=utf-8
	set encoding=utf-8
endfunction

" Files that end with .jp are now japanese files.
autocmd BufNewFile,BufRead *.jp set filetype=jp

autocmd Filetype jp call JAPANESESettings()
" -------------
" ---- [3.12] LATEX ----
function! TEXSettings()
	setlocal foldexpr=TexFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd Filetype tex,plaintex call TEXSettings()
" --------------------
" ---- [3.13] GITCOMMIT ----
" --------------------
" ---- [3.14] MARKDOWN ----
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd FileType markdown call MDSettings()
" --------------------
" ---- [3.15] NOTE ----
function! NOTESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Files that end with .pass are now password files.
autocmd BufNewFile,BufRead *.note set filetype=note

autocmd Filetype note call PASSSettings()
autocmd BufWritePost *.note call VimHelperMessage("tags", "")
" --------------------
" --------------------
" ---- [4] STATUSLINE ----
set laststatus=2
set statusline=%<\[%f\]\ %y\ \ %m%=%-14.(%l-%c%)\ %P
" --------------------
" ---- [5] COLORSETTINGS ----
" ---- [5.0] DEFAULT ----
colorscheme desert

" Change to better colors when using a terminal
" http://misc.flogisoft.com/_media/bash/colors_format/256_colors_bg.png
if has("terminfo")
	let &t_Co=256
	set background=light
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
" --------------------
" --------------------
" ---- [6] AUTOCMD ----
autocmd InsertCharPre * let v:char = Delim(v:char)
" --------------------
" ---- [7] FUNCTIONS ----
" ---- [7.0] TABCOMPLETION ----
function! MinimalTab()
	if getline(".")[col('.') - 2] =~ '\w'
		return (pumvisible() ? "\<C-E>" : "") . s:CompletionCommand
	else
		return SpecialDelim("\<TAB>")
	endif
endfunction

" --------------------
" ---- [7.1] JUMP ----
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
" --------------------
" ---- [7.2] TEMPBUFFER ----
function! OpohBuffer()
	if bufexists("[Opoh]")
		b Opoh
	else
		e [Opoh]
	endif
	execute("0,$d")
	setlocal nobuflisted
	setlocal filetype=opoh
	setlocal buftype=nofile
endfunction
" --------------------
" ---- [7.3] SPELLCHECK ----
function! EnglishSpellCheck()
	setlocal spell spelllang=en_us
	let b:neocomplete_spell_file = 'american-english'
endfunction

function! SwedishSpellCheck()
	setlocal spell spelllang=sv
	let b:neocomplete_spell_file = 'swedish'
endfunction

function! NoSpellCheck()
	setlocal nospell
	let b:neocomplete_spell_file = ''
endfunction
" --------------------
" ---- [7.4] AUTODELIMITER ----
"\ [["{"], ["{", "\<bs>\<cr>\<cr>}\<up>"]],
let g:currentchains = []
let g:delimCall = 0
let g:optkeys = ["\<cr>", "\<left>", "\<space>", "\<tab>", "\<bs>"]
function! Delim(key)
	let g:delimCall = 0
	let call = ""
	for chains in g:keychains
		if chains[0][0] ==# a:key
			call add(g:currentchains, chains)
		endif
	endfor	
	let newchains = []
	for chains in g:currentchains
		if chains[0][0] ==# a:key
			if len(chains[0]) > 1
				let call = chains[0][1]			
			endif
			let chains = chains[1:]
			if chains != []
				call add(newchains, chains)
			endif
		endif
		if chains != []
			if chains[0][0] == "opt"
				if a:key == ";"
					let call = "\<bs>\<right>;"
				endif
			endif
		endif
	endfor
	let g:currentchains = newchains
	if call != ""	
		let g:delimCall = 1
		call feedkeys(call)
	endif
	return a:key
endfunction

" Call this for all keys not being registered by InsertCharPre
function! SpecialDelim(key)
	let returnV = a:key
	if g:delimCall == 0
		for chains in g:currentchains
			if chains[0][0] == "opt"
				for key in g:optkeys
					if key == a:key
						let returnV = "\<right>" . a:key
					endif
				endfor			
			endif
		endfor
		let g:currentchains = []
	endif
	let g:delimCall = 0
	return returnV
endfunction
" --------------------
" --------------------
" ---- [8] FOLDING ----
" ---- [8.0] FOLDSETTINGS ----
set foldmethod=expr
set foldnestmax=2
set foldopen=
" --------------------
" ---- [8.1] FOLDEXPR ----
" ---- [8.1.0] GLOBAL VARIABLES ----
let g:InsideBrace = 0
let g:InsideVar = 0
let g:InsideComment = 0
" --------------------
" ---- [8.1.1] C# JAVA ----
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
" --------------------
" ---- [8.1.2] C ----
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
" --------------------
" ---- [8.1.3] VIM ----
function! VimrcFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^\" ---- ' || line =~ '^function'
		return 'a1'
	elseif line =~ '^\" -----' || line =~ '^endfunction'
		return 's1'
	else
		return '='
	endif
endfunction
" --------------------
" ---- [8.1.4] SNIPPETS ----
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
" --------------------
" ---- [8.1.5] TODO LUA MAKE ----
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
" --------------------
" ---- [8.1.6] PYTHON ----
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
" --------------------
" ---- [8.1.7] LATEX ----
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
" --------------------
" ---- [8.1.8] PASS ----
function! PassFolding(lnum)
	let line = getline(a:lnum)
	if line == ""
		return 0
	endif
	return ">1"
endfunction
" --------------------
" ---- [8.1.9] MARKDOWN ----
function! MDFolding(lnum)
	let line = getline(a:lnum)
	if line =~ "#"
		let ind = strlen(substitute(line, "[^#]", "", "g")) - 1
		return '>' . ind
	else
		return '='
	endif

endfunction
" --------------------
" ---------------
" ---- [8.2] FOLDTEXT ----
" ---- [8.2.0] DEFAULT ----
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
" --------------------
" ---- [8.2.1] CS JAVA ----
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
" --------------------
" ---- [8.2.2] PASS ----
" name pass username
" name -------------
function! PassFoldText()
	let line = getline(v:foldstart)
	let words = split(line, '\t')
	return words[0]
endfunction
" --------------------
" ---- [8.2.3] PYTHON ----
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
" --------------------
" --------------------
" --------------------
" ---- [9] TABLINE ----
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
" --------------------
" ---- [10] OS SPECIFIC ----
" ---- [10.0] WINDOWS ----
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" --------------------
" ---- [10.1] LINUX ----
if has('unix')
endif
" --------------------
" --------------------
