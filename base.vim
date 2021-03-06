"       BASE VIM
" ---- [0] Init ----------------------
if !exists("g:customVimHome")
	let g:customVimHome = expand("~")
endif
let requiredFolders = [
		\ g:customVimHome . "/.vim",
		\ g:customVimHome . "/.vim/tmp",
		\ g:customVimHome . "/.vim/swapfiles"]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
	endif
endfor
let g:mrufile = g:customVimHome . "/.vim/mru"
let g:explorerpath = g:customVimHome . "/"
if !filereadable(g:mrufile)
	call writefile(([]), g:mrufile)
endif
execute "set rtp+=" . g:customVimHome . "/git/vim/scripts/"
" ------------------------------------
" ---- [1] Vimsettings ---------------
autocmd!
set nocompatible
set modelines=0
set relativenumber
set guioptions=c
set incsearch
set ruler
set completeopt=menu
set tabpagemax=100
set notimeout
set guifont=Inconsolata\ bold\ 14
	" If you need to change this on another computer just use 
	" set guifont=*
	" Pick the font and size you want. Then type
	" set guifont?
	" To get the value you want to set guifont too. Then add that to your
	" local .vimrc.
set wildmode=longest:full,list
execute "set directory=" . g:customVimHome . "/.vim/swapfiles//"
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
set colorcolumn=79
set textwidth=0
set wrapmargin=0
set encoding=utf-8
set shellslash
set autoindent
set showcmd

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

" +/- maps made no sense locationwise, swapped them.
nnoremap - _

" Easier bind for jump to definition
nnoremap <C-M> <C-]>

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

" Free bindings.
" CTRL-N (same as j)
" CTRL-P (same as k)
" s (same as cl)
" S (same as cc)
" + (same as j-)
" _ (same as -)
" ------------------------------------
" ---- [2.1] Insert-bindings ---------
" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-H> <C-W>
inoremap <C-Del> <C-O>de
inoremap [3;5~ <C-O>de

" Shift-Enter acts like O in normal
inoremap <S-CR> <C-O>O

" Autocomplete spelling
inoremap <C-S> <C-X><C-S>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <C-O>A
inoremap <C-B> <left>
inoremap <C-F> <right>
inoremap <C-K> <C-O>C
" ------------------------------------
" ---- [2.2] Visual-bindings ---------
" I keep pressing << >> in the wrong order. HL are good for directions.
" Also reselects after action.
vnoremap H <gv
vnoremap L >gv

"Switches repeat f/F, feels more logical on swedish keyboard.
vnoremap , ;
vnoremap ; ,

xnoremap å c<C-R>=PythonMath()<CR>
" ------------------------------------
" ---- [2.3] Leader-bindings ---------
let g:mapleader="\<space>"


" A
" B - (Last) Buffer
map <leader>b :b# <CR>
" C - Close
map <leader>c <C-W>c
" D - Delete buffer
map <leader>d :bd <CR>
map <leader>D :bd! <CR>
" E
" F - (Current) File
map <leader>fd :call CustomDelete("%", 1)<CR>
map <leader>fr :call CustomRename("%", 1)<CR>
map <leader>fm :call CustomMkdir(expand("%:h"))<CR>
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
" J - Snippets
map <leader>j :call Explorer(["snippet"])<CR>
" K
" L
" M - Make
" Requires a make file with a run line that compiles and runs the program.
autocmd Filetype c map <buffer><silent> <leader>m :w <bar> make run <cr>
autocmd Filetype cpp map <buffer><silent> <leader>m :w <bar> ! main <cr>
autocmd Filetype cs map <buffer><silent> <leader>m :w <bar> ! main <cr>
autocmd Filetype vim map <leader>m :so % <cr>
autocmd Filetype python map <buffer><silent> <leader>m :w <bar> ! python % <cr>
" N - Next buffer
map <leader>n :bn <CR>
" O - Open file explorer
" P - Previous buffer
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
		execute "e " . g:customVimHome . "/.vim/tmp/temp.%:e"
	else
		execute "e " . g:customVimHome . "/.vim/tmp/temp"
	endif
endfunction
" Show/Hide tabs
map <leader>ts :set listchars=tab:>\ ,trail:#,extends:>,precedes:<,nbsp:+ <CR>
map <leader>tS :set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ <CR>
map <leader>tc :tabclose <CR>
map <leader>tn :tabnew <CR>
" U - Ultisnips
" V - .vimrc
map <leader>vr :execute "e " . g:customVimHome . "/git/vim/README.md"<CR>
map <leader>vh :execute "e " . g:customVimHome . "/git/vim/heavy.vim"<CR>
map <leader>vb :execute "e " . g:customVimHome . "/git/vim/base.vim"<CR>
map <leader>vv :execute "e " . g:customVimHome . "/git/vim/base.vim"<CR>
map <leader>vf :execute "e " . g:customVimHome . "/git/vim/folding.vim"<CR>
map <leader>vd :vert diffsplit
" W
" X
map <leader>x @@
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
execute "command -nargs=1 Tt :e " . g:customVimHome . " \.vim\tmp\<args>"

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
" ---- [2.7] Explorer-bindings -------
function! ExplorerBindings()
	nnoremap <buffer> i :call cursor(1, 100000)<CR>a
	nnoremap <buffer> a :call cursor(1, 100000)<CR>a
	nnoremap <buffer> <ESC> :execute("bd")<CR>
	nnoremap <buffer> <CR> :call ExplorerDo("open")<CR>
	nnoremap <buffer> r :call ExplorerDo("rename")<CR>
	nnoremap <buffer> m :call ExplorerDo("mkdir")<CR>
	nnoremap <buffer> d :call ExplorerDo("delete")<CR>
	inoremap <buffer> <CR> <ESC>:call ExplorerDo("open")<CR>
	inoremap <buffer> <TAB> <ESC>:call ExplorerTab()<CR>
endfunction
" ------------------------------------
" ---- [2.8] Note-bindings -------
function! NoteBindings()
	nnoremap <buffer> <C-M> :call DirectHelp()<CR>
	nnoremap <buffer> <C-]> :call DirectHelp()<CR>
endfunction
" ------------------------------------
" ---- [2.9] Help-bindings -------
function! HelpBindings()
endfunction
" ------------------------------------
" ------------------------------------
" ---- [3] Filetype ------------------
" ---- [3.0] All-filetype ------------
autocmd FileType * call AllSettings()
function! AllSettings()
	setlocal formatoptions-=cro
	let b:writeCompiler = {
			\ 'compiler' : [],
			\ 'runner' : []}
	let b:updateCompiler = {
			\ 'compiler' : [],
			\ 'runner' : []}
	let b:uCompilerRunning = 0
endfunction
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
	let b:updateCompiler.runner = ["make", "run", "-C", expand("%:h")]
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
autocmd BufRead .vimperatorrc set filetype=vim
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
" ---- [3.6] Python-filetype ---------
function! PythonSettings()
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=PythonFoldText()
	let b:updateCompiler.runner = ["python", g:customVimHome . "/.vim/compilefiles/temp.py"]
	let b:writeCompiler.runner = ["python", expand("%:p")]
endfunction

autocmd Filetype python call PythonSettings()
" ------------------------------------
" ---- [3.7] Lua-filetype ------------
function! LUASettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype lua call LUASettings()
" ------------------------------------
" ---- [3.8] Make-filetype -----------
function! MAKESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype make call MAKESettings()
" ------------------------------------
" ---- [3.9] Pass-filetype ----------
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
" ---- [3.10] Japanese-filetype ------
function! JAPANESESettings()
	set guifont=Inconsolata\ 18
	set fileencoding=utf-8
endfunction

" Files that end with .jp are now japanese files.
autocmd BufNewFile,BufRead *.jp set filetype=jp

autocmd Filetype jp call JAPANESESettings()
" ------------------------------------
" ---- [3.11] Latex-filetype ---------
function! TEXSettings()
	setlocal foldexpr=TexFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
	let b:updateCompiler.compiler = ["pdflatex", g:customVimHome . "/.vim/compilefiles/temp.tex"]
endfunction

autocmd Filetype tex,plaintex call TEXSettings()
" ------------------------------------
" ---- [3.12] Gitcommit-filetype -----
function! GITCSettings()
	let &foldlevel = 99
	call EnglishSpellCheck()
endfunction

autocmd FileType gitcommit call GITCSettings()
" ------------------------------------
" ---- [3.13] Markdown-filetype ------
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd FileType markdown call MDSettings()
" ------------------------------------
" ---- [3.14] Vnote-filetype ----------
function! VnoteSettings()
	setlocal filetype=note
	call NoteBindings()
endfunction

" Default location of notes
if !exists("g:noteLocations")
	let g:noteLocations = []
endif
call add(g:noteLocations, g:customVimHome . "/git/info/notes/tags-vn")

autocmd BufNewFile,BufRead *.vnx set filetype=vnotes
autocmd Filetype vnotes call VnoteSettings()
autocmd BufWritePost *.vnx helptags %:h
" ------------------------------------
" ---- [3.15] Netrw-filetype ---------
function! NetrwSettings()
	call NetrwBindings()
endfunction

autocmd FileType netrw call NetrwSettings()
" ------------------------------------
" ---- [3.16] Help-filetype ----------
function! HelpSettings()
	call HelpBindings()
endfunction

autocmd FileType help call HelpSettings()
" ------------------------------------
" ---- [3.17] Vimperator-filetype ----
function! VimperatorFieldSettings()
	startinsert
	call cursor(100000, 100000)
	nnoremap <buffer> <ESC> :wq<CR>
	call EnglishSpellCheck()
endfunction

autocmd BufRead *vimperator-* set filetype=vimperatorfield
autocmd FileType vimperatorfield call VimperatorFieldSettings()
" ------------------------------------
" ---- [3.18] LFS-filetype ----
function! LFSSettings()
	setlocal foldexpr=IndentFolding(v:lnum)
endfunction

autocmd BufRead *.lfs set filetype=lfs
autocmd FileType lfs call LFSSettings()
" ------------------------------------
" ---- [3.19] Todo ----------
function! TDFTSettings()
endfunction

autocmd BufRead *.tdft set filetype=tdft
autocmd FileType tdft call TDFTSettings()
" ------------------------------------
" ------------------------------------
" ---- [4] Statusline ----------------
set laststatus=2
set statusline=%<\[%f\]\ %y\ \ %m%=%-14.(%l-%c%)\ %P-%L
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
autocmd TextChanged,TextChangedI * call CreateTempFile()
" ------------------------------------
" ---- [7] Functions -----------------
" ---- [7.0] Temp-functions ----------
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
	call AddVimSectionCall(a:section, a:subsection, g:customVimHome . "/git/vim/base.vim")
endfunction
function! ShowVimSection(section, subsection)
	call TempBuffer()
       	setlocal syntax=vim
	call AddVimSection(a:section, a:subsection)
	normal gg
endfunction
" ------------------------------------
" ---- [7.1] Spellcheck-functions ----
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
" ---- [7.2] Explorer-functions ------
" Custom tags for notes
if !exists("g:extraNoteTags")
	let g:extraNoteTags = []
endif
let extraTag = {
	\ 'name' : 'pwdf-pass-password-file-passfile',
	\ 'file' : 'pass.pass',
	\ 'path' : g:customVimHome . '/git/info/pass.pass',
	\ 'tag' : '0',
	\ 'alias' : "[notes] " . "pwdf-pass-password-file-passfile | pass.pass",
	\ 'source' : "notes"}
call add(g:extraNoteTags, extraTag)

"Open tagview.
function! Explorer(sources, ...)
	let tagfile = expand("%:p")
	let ftype = ""
	if a:0 > 0
		if index(a:sources, "dir") >= 0 || index(a:sources, "file") >= 0
			let g:explorerpath = a:1
		endif
		if index(a:sources, "line") >= 0 || index(a:sources, "checklist") >= 0
			let tagfile = a:1
		endif
	endif
	if index(a:sources, "line") >= 0 && tagfile != ""
		execute "e " . tagfile
		let ftype = &filetype
		execute "bd"
	endif
	if bufexists("[ExplorerBuffer]")
		b ExplorerBuffer
	else
		e [ExplorerBuffer]
	endif
	execute "0,$d_"
	setlocal nobuflisted
	setlocal buftype=acwrite
	call ExplorerBindings()
	autocmd TextChangedI <buffer> call ExplorerUpdate()
	autocmd BufLeave <buffer> call clearmatches()
	set filetype=tag
	autocmd BufWriteCmd <buffer> call ExplorerWrite() | setlocal nomodified

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
   	syntax match Constant "\[notes\]"
   	syntax match Constant "\[snippet\]"
   	syntax match Function "\[buffer\]"
   	syntax match Function "\[file\]"
   	syntax match SpecialKey "| \S*$"
   	syntax match SpecialKey "\[x\] .*"
endfunction

function! ExplorerTags()
	let tags = []
	let bufline = getbufline("%", 1)[0]
	for source in b:sources
		if source == "mru" || source == "notes" || source == "snippet"
			if source == "mru"
				call UpdateFileMRU()
				let tagfile = g:mrufile
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
			elseif source == "notes" || source == "snippet"
				for noteLocation in g:noteLocations
					let lines = readfile(expand(noteLocation))
					for line in lines
						let info = split(line, "\t")
						let tagname = info[0]
						let filename = info[1]
						let tagsearch = info[2]
						let tag = {
							\ 'name' : info[0],
							\ 'file' : info[1],
							\ 'tag' : info[2],
							\ 'path' : fnamemodify(noteLocation, ":h") . "/" . info[1],
							\ 'alias' : "[" . source . "] " . info[0] . " | " . info[1],
							\ 'source' : source}
						call add(tags, tag)
					endfor
				endfor
				for tag in g:extraNoteTags
					call add(tags, tag)
				endfor
			endif
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
							\ 'file' : tagfile,
							\ 'tag' : line,
							\ 'alias' : index . " " . line,
							\ 'lnum' : index,
							\ 'source' : source}
						call add(tags, tag)
					endif
					let index += 1
				endfor
			endif
		elseif source == "checklist"
			let tagfile = b:tagfile
			for line in readfile(expand(tagfile))
				let tag = {
					\ 'name' : line,
					\ 'file' : tagfile,
					\ 'tag' : line,
					\ 'alias' : "[-] " . line,
					\ 'del' : 0,
					\ 'source' : source}
				call add(tags, tag)
			endfor
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
	setlocal nomodified
	if index(b:sources, "checklist") >= 0
		for tag in b:tags
			if tag.del
				setlocal modified
				break
			endif
		endfor
	endif
endfunction

function! ExplorerDraw()
	call clearmatches()
	let search = split(getbufline("%", 1)[0], " ")
	if index(b:sources, "dir") >= 0 || index(b:sources, "file") >= 0
		let search = split(getbufline("%", 1)[0], g:explorerpath)
	endif
	for searcht in search
		let highlightPattern = "\\[.*\\].*\\zs\\c" . searcht
		if index(b:sources, "mru") >= 0 || index(b:sources, "notes") >= 0
			let highlightPattern .= "\\ze.*|.*"
		endif
		call matchadd("Constant",highlightPattern)
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
		if len(line) > 80
			let line = line[:75] . "..."
		endif
		put = line
	endfor
	call setpos('.', curs)
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

function! ExplorerDo(command, ...)
	let tagindex = 0
	if a:0 > 0
		let tagindex = a:1
	else
		let tagindex = getpos('.')[1] - 2
		if tagindex < 0
			let tagindex = 0
		endif
	endif
	let bufline = getbufline("%", 1)[0]
	if len(b:currentTags) > 0
		let tag = b:currentTags[tagindex]
		if a:command == "open"
			if tag.source == "mru"
				execute "e " . tag.file
			elseif tag.source == "notes"
				execute "e +" . escape(escape(tag.tag, "*"), "*") . 
					\ " " . tag.path
			elseif tag.source == "snippet"
				let snipp = ""
				let inSnip = 0
				for line in readfile(expand(tag.path))
					if inSnip
						if line =~ "^\s*$"
							let inSnip = 0
							call setreg("", snipp)						
							break
						endif
						let snipp .= substitute(substitute(line, "^\\S", "", ""), "^\t", "", "") . "\n"
					endif
					if line =~ tag.tag
						let inSnip = 1
					endif
				endfor
				execute "bd"
				normal p
			elseif tag.source == "buffer"
				execute "b " . tag.tag
			elseif tag.source == "file"
				execute "e " . tag.file
			elseif tag.source == "line"
				execute "e +" . tag.lnum . " " . tag.file
			elseif tag.source == "dir"
				call ExplorerTab()
			elseif tag.source == "checklist"
				let tag.del = !tag.del
				if tag.del
					let tag.alias = "[x] " . tag.name
				else
					let tag.alias = "[-] " . tag.name
				endif
				normal dd
				normal O
				startinsert
				call cursor(0, 100000)
				call ExplorerUpdate()	
			endif
		elseif a:command == "rename"
			if tag.source == "file"
				call CustomRename(tag.file)
			elseif tag.source == "dir"
				call CustomRename(tag.file)
			elseif tag.source == "mru"
				call CustomRename(tag.file)
				call ExplorerTags()
			endif
			call ExplorerUpdate()	
		elseif a:command == "delete"
			if tag.source == "file"
				call CustomDelete(tag.file)
			elseif tag.source == "dir"
				call CustomDelete(tag.file)
			elseif tag.source == "mru"
				call CustomDelete(tag.file)
				call ExplorerTags()
			endif
			call ExplorerUpdate()	
		endif
	else
		if a:command == "open"
			if index(b:sources, "file") >= 0
				execute "e " . bufline
			endif
		endif
	endif
	if a:command == "mkdir"
		if index(b:sources, "dir") >= 0
			call CustomMkdir(bufline)
		endif
		call ExplorerUpdate()	
	endif
endfunction

function! ExplorerWrite()
	if index(b:sources, "checklist") >= 0
		let tagfile = b:tagfile
		let tags = []
		let lines = []
		for tag in b:tags
			if !tag.del
				call add(lines, tag.name)
				call add(tags, tag)
			endif
		endfor
		let b:tags = tags
		call writefile(lines, expand(tagfile))
		call ExplorerUpdate()	
	endif
endfunction
" ------------------------------------
" ---- [7.3] Filemru-functions -------
function! UpdateFileMRU()
	let tags = readfile(g:mrufile)
	let correctTags = []
	let newtag = ""
	if expand("%") != ""
		let newtag = expand("%:t") . "\t" . expand("%:p") . "\t" . "0"
		call add(correctTags, newtag)
	endif
	for tag in tags
		let info = split(tag, "\t")
		let tagname = info[0]
		let filename = info[1]
		let tagsearch = info[2]
		if filereadable(filename)
			if tag != newtag
				call add(correctTags, tag)
			endif
		endif
	endfor
	call writefile(correctTags, g:mrufile)
endfunction
" ------------------------------------
" ---- [7.4] DirectHelp ----------
" Custom jump to tag command for note files.
function! DirectHelp()
	let helpTag = expand("<cWORD>")
	if helpTag =~ "|.*|"
		" Remove | from the tag.
		let helpTag = helpTag[1:-2]
		" Split the tag by options.
		let tag = split(helpTag, ":")
		let filename = tag[0]
		" If the file is a pdf, open evince at the correct place.
		" |file.pdf| or
		" |file.pdf:pagenr|
		if filename =~ "\.[pP][dD][fF]$"
			let filepath = expand(g:notesLocation . filename)
			let page = "0"
			if len(tag) > 1
				let page = tag[1]
			endif
			call system("evince " . filepath . " --page-label=" . page)
		" If it's a normal note tag, jump to the specified note.
		else
			let b:sources = ["notes"]
			call ExplorerTags()
			let index = -1
			let tmpI = 0
			for tag in b:tags
				if tag.name == helpTag
					let index = tmpI
					break
				endif
				let tmpI += 1
			endfor
			let b:currentTags = b:tags
			if index != -1
				call ExplorerDo("open", index)
			endif
		endif
	endif
endfunction
" ------------------------------------
" ---- [7.5] AutoCompile -------------
function! CreateTempFile()
	if exists('b:uCompilerRunning') && v:version >= 800
		if expand('%') != '' && b:uCompilerRunning == 1
			call writefile(getline(1,'$'),
				\ g:customVimHome . "/.vim/compilefiles/" . expand("%:t"))
		endif
	endif
endfunction

function! CompileBuffer()
	let currentBuf = bufnr('%')
	if bufexists("CompileBuffer")
		b CompileBuffer
	else
		e CompileBuffer
	endif
	setlocal buftype=nofile
	let g:makeBufNum = bufnr('CompileBuffer', 1)
	exec "b " . currentBuf
endfunction

function! WriteCompile()
	if v:version >= 800
		call CompileBuffer()
		let b:compiler = b:writeCompiler
		autocmd BufWritePost <buffer> call CompileOnce()
	endif
endfunction

function! UpdateCompile()
	if v:version >= 800
		call CompileBuffer()
		let b:compiler = b:updateCompiler
		let b:uCompilerRunning = 1
		autocmd TextChanged,TextChangedI <buffer> call CompileOnce()
	endif
endfunction

let g:compiling = 0
let g:queuecompile = 0
function! CompileOnce()
	if g:compiling == 0
		let cursorPos = getpos('.')
		let currentBuf = bufnr('%')
		execute g:makeBufNum . "bufdo 0,$d_"
		exec "b " . currentBuf
		call setpos('.', cursorPos)
		let g:compiling = 1
		if b:compiler.compiler != []
			let g:compileJob = job_start(
				\ b:compiler.compiler, {
				\ 'close_cb': 'RunOnce',
				\ 'out_io': 'buffer',
				\ 'err_io': 'out',
				\ 'out_name': 'CompileBuffer'})
		else
			call RunOnce("")
		endif
	else
		let g:queuecompile = 1
	endif
endfunction
function! RunOnce(channel)
	if b:compiler.runner != []
		let g:compileJob = job_start(
			\ b:compiler.runner, {
			\ 'close_cb': 'RunDone',
			\ 'err_io': 'out',
			\ 'out_io': 'buffer',
			\ 'out_name': 'CompileBuffer'})
	else
		call RunDone("")
	endif
endfunction
function! RunDone(channel)
	let g:compiling = 0
	if g:queuecompile
		let g:queuecompile = 0
		call CompileOnce()
	endif
endfunction
" ------------------------------------
" ---- [7.6] Delete-Rename-functions -
function! CustomRename(file, ...)	
	if expand(a:file) != ""
		let reloadFile = 0
		if a:0 > 0
			let reloadFile = a:1
		endif
		let filename = fnamemodify(expand(a:file), ":p")
		let tstr="Moving file/folder: " . filename . "\nNew location: "
		let newName = input(tstr, fnamemodify(filename, ":h") . "/", "file")
		if(rename(filename, newName))
			echo "\nError: File/folder not moved."
		else
			echo "\nFile/folder moved."
			if reloadFile
				bd
				execute "e " . newName
			endif
		endif
	endif
endfunction
function! CustomMkdir(file)	
	let filename = fnamemodify(expand(a:file), ":p")
	let tstr="New directory name: "
	let newName = input(tstr, filename, "file")
	let tstr="Create new directory: " . newName
	if confirm(tstr, "yes\nno", 2) == 1
		call mkdir(newName)
		echo "Directory created."
	else
		echo "Directory not created."
	endif
endfunction
function! CustomDelete(file, ...)
	if expand(a:file) != ""
		let removeBuffer = 0
		if a:0 > 0
			let removeBuffer = a:1
		endif
		let filename = fnamemodify(expand(a:file), ":p")
		let tstr = "Removing file/folder: " . filename . "\nProceed?"
		if confirm(tstr, "yes\nno", 2) == 1
			if delete(filename, "rf")
				echo "Error: File/folder not removed."
			else
				echo "File/folder removed."
				if removeBuffer
					bd
				endif
			endif
		else
			echo "Error: File/folder not removed."
		endif
	endif
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
