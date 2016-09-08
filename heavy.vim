"       HEAVY VIM
" ---- [0] INIT -------------
let requiredFolders = [
		\ "~/.vim/tmp/gitstatusline",
		\ "~/.vim/tmp/compilefiles"]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
		let setup = 1
	endif
endfor
set rtp+=~/git/vim/scripts/
set tags+=~/git/vim/scripts/UltiSnips/tags/python.tags
" ---------------------------
" ---- [1] PLUGINS ----------
" ---- [1.0] VUNDLE ---------
" Required by vundle
filetype off
set rtp+=~/git/vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Snippets
Plugin 'SirVer/ultisnips'

" Code-completion
Plugin 'Valloric/YouCompleteMe'

" Div
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Konfekt/FastFold'

" Required by vundle
call vundle#end()
filetype plugin indent on
" ---------------------------
" ---- [1.1] ULTISNIPS ------
let g:ulti_expand_res = 0
let g:ulti_jump_forwards_res = 0
let g:ulti_jump_backwards_res = 0
let g:ulti_expand_or_jump_res = 0

" Remove default ultisnips bindings.
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsListSnippets ="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<Nop>"
let g:UltiSnipsJumpBackwardTrigger="<Nop>"

let g:UltiSnipsSnippetsDir = "~/git/vim/scripts/UltiSnips"
" ---------------------------
" ---- [1.2] YCM ------------
" ---------------------------
" ---------------------------
" ---- [2] BINDINGS ---------
" ---- [2.0] NORMAL ---------
" ---------------------------
" ---- [2.1] INSERT ---------
inoremap <C-J> <C-R>=USOrSmartJump()<CR>
inoremap <C-K> <C-R>=USOrSmartJumpBack()<CR>

let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" ---------------------------
" ---- [2.2] VISUAL ---------
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

xmap s S
xmap sd s]
xmap sD s>
xmap sq s"
xmap st s'
xmap sm s$
xmap s( s)
xmap s{ s}
" ---------------------------
" ---- [2.3] LEADER ---------

" A
" B
" C - Compile
" D - Delete buffer
" E - Start external
" F
" G - Git
map <leader>gD :exec ":Gvdiff " input(""
	\ . "HEAD            .git/HEAD"
	\ . "\nmaster          .git/refs/heads/master"
	\ . "\nHEAD^{}         The commit referenced by HEAD"
	\ . "\nHEAD^           The parent of the commit referenced by HEAD"
	\ . "\nHEAD:           The tree referenced by HEAD"
	\ . "\n/HEAD           The file named HEAD in the work tree"
	\ . "\nMakefile        The file named Makefile in the work tree"
	\ . "\nHEAD^:Makefile  The file named Makefile in the parent of HEAD"
	\ . "\n:Makefile       The file named Makefile in the index (writable)"
	\ . "\n-               The current file in HEAD"
	\ . "\n^               The current file in the previous commit"
	\ . "\n~3              The current file 3 commits ago"
	\ . "\n:               .git/index (Same as :Gstatus)"
	\ . "\n:0              The current file in the index"
	\ . "\n:1              The current file's common ancestor during a conflict"
	\ . "\n:2              The current file in the target branch during a conflict"
	\ . "\n:3              The current file in the merged branch during a conflict"
	\ . "\n:/foo           The most recent commit with \"foo\" in the message\n"
	\ )<CR>

map <leader>gc :Gcommit<CR>
map <leader>gd :Gvdiff<CR>
map <leader>gg :Gstatus<CR>
map <leader>gl :Glog --<CR>
" H - Help, show binds.
" I - Information, notes on helpful things.
" J - Format json file.
map <leader>j :%!python -m json.tool<CR>
" K
" L
" M - Make
" N - Next buffer
" O - Open file explorer
" P - Quickfix commands
" Q - Quickfix commands
" R - Run file or project / Stop file or project
map <leader>r :call VimHelperCompile() <cr>
map <leader>R :call VimHelperCompileStop() <cr>
" S - Spellcheck
" T - Tabs, temp and tabformat
" U - Ultisnips
map <leader>ue :UltiSnipsEdit <CR>
map <leader>uu :call Explorer(["dir", "file"], expand("~/git/vim/scripts/UltiSnips/")) <CR>
" V - .vimrc
map <leader>vR :call VimHelperRestart()<CR>
map <leader>vh :e ~/git/vim/scripts/VimHelper.py<CR>
map <leader>vr :e ~/git/vim/README.md<CR>
map <leader>vv :e ~/git/vim/heavy.vim<CR>
map <leader>vb :e ~/git/vim/vim-base/base.vim<CR>
map <leader>vf :e ~/git/vim/vim-base/folding.vim<CR>
" W
" X
" Y
" Z - Z(S)essions
" ?
" ---------------------------
" ---- [2.4] OMAP -----------
" ---------------------------
" ---- [2.5] COMMAND --------
cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>Git" : "t"
" ---------------------------
" ---- [2.6] FUGITIVE -------
function! FugitiveBindings()
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
	nmap <buffer> gd D
	nmap <buffer> <esc> :bd<cr>
endfunction
" ---------------------------
" ---------------------------
" ---- [3] FILETYPE ---------
" ---- [3.0] All ------------
autocmd FileType * setlocal formatoptions-=cro
" ---------------------------
" ---- [3.1] JAVA -----------
" ---------------------------
" ---- [3.2] C# -------------
" ---------------------------
" ---- [3.3] C --------------
" ---------------------------
" ---- [3.4] VIMRC ----------
" ---------------------------
" ---- [3.5] SNIPPET --------
" ---------------------------
" ---- [3.6] TODO -----------
" ---------------------------
" ---- [3.7] PYTHON ---------
" ---------------------------
" ---- [3.8] LUA ------------
" ---------------------------
" ---- [3.9] MAKE -----------
" ---------------------------
" ---- [3.10] PASS ----------
" ---------------------------
" ---- [3.11] JAPANESE ------
" ---------------------------
" ---- [3.12] LATEX ---------
" ---------------------------
" ---- [3.13] GITCOMMIT -----
function! GITCSettings()
	let &foldlevel = 99
	call FugitiveBindings()
	call EnglishSpellCheck()
endfunction

autocmd FileType gitcommit call GITCSettings()
" ---------------------------
" ---- [3.14] MARKDOWN ------
" ---------------------------
" ---- [3.15] NOTE ----------
autocmd BufWritePost *.note call VimHelperMessage("tags", "")
" ---------------------------
" ---- [3.16] HELP ----------
" ---------------------------
" ---------------------------
" ---- [4] STATUSLINE -------
set statusline=%<\[%f\]\ %y\ %{MyStatusLine()}\ %m%=%-14.(%l-%c%)\ %P

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	let b:statusLineVar = ""
	let gitStatusLineFile = expand("~/.vim/tmp/gitstatusline/") .  substitute(expand("%:p"), "[\\:/]", "-", "g")
	if filereadable(gitStatusLineFile)
		let statusInfo = readfile(gitStatusLineFile)
		if len(statusInfo) > 0
			let b:statusLineVar = statusInfo[0]
		endif
	endif

	return b:statusLineVar
endfunction
" ---------------------------
" ---- [5] COLORSETTINGS ----
" ---------------------------
" ---- [6] AUTOCMD ----------
autocmd BufWritePost * call UpdateGitInfo()
autocmd BufEnter * call UpdateGitInfo()
autocmd TextChanged,TextChangedI * call CreateTempFile()
autocmd FocusGained * call UpdateGitInfo()

autocmd VimLeave * call OnExit()
autocmd VimEnter * call AfterInit()

function! CreateTempFile()
	if expand('%') != '' && g:compilingVH == 1
		call writefile(getline(1,'$'), expand("~/.vim/tmp/compilefiles/") . expand("%:t"))
	endif
endfunction
" ---------------------------
" ---- [7] FUNCTIONS --------
" ---- [7.0] TABCOMPLETION --
function! CustomTab()
	if pumvisible()
		return "\<C-N>"
	else
	return "\<TAB>"
endfunction
" ---------------------------
" ---- [7.1] JUMP -----------
function! USOrSmartJump()
	call UltiSnips#ExpandSnippetOrJump()
	if g:ulti_expand_or_jump_res == 1
		return ""
	endif
	return SmartJump()
endfunction
function! USOrSmartJumpBack()
	call UltiSnips#JumpBackwards()
	if g:ulti_jump_backwards_res == 1
		return ""
	endif
	return SmartJumpBack()
endfunction
" ---------------------------
" ---- [7.2] EVAL MATH ------
function! PythonMath()
let l:vimMath = getreg('"')
if l:vimMath == ''
	return ''
endif
let l:pythonMath = ''
python << endpy
math = eval(vim.eval("l:vimMath"))
vim.command("let l:pythonMath = '" + str(math) + "'")
endpy
return l:pythonMath
endfunction
" ---------------------------
" ---- [7.3] GIT INFO -------
function! UpdateGitInfo()
	let b:statusLineVar = ""
	call VimHelperMessage("path", expand("%:p"))
endfunction
" ---------------------------
" ---- [7.4] ON EXIT --------
function! OnExit()
	call VimHelperMessage("client", "-1")
endfunction
" ---------------------------
" ---- [7.5] AFTER INIT -----
function! AfterInit()
	if !g:startedExternal
		call VimHelperMessage("client", "1")
	endif
endfunction
" ---------------------------
" ---- [7.6] VIMHELPER ------
let g:startedExternal = 0
let g:timeoutVH = 5
let g:disableVimHelper = 0
let g:compilingVH = 0
function! VimHelperMessage(type, message)
if !g:disableVimHelper && g:timeoutVH > 0
python << endpy
import socket
import vim
try:
	s = socket.socket()
	s.connect(("localhost", 51351))

	s.send(vim.eval("a:type") + "\t" + vim.eval("a:message"))
	vim.command("let g:timeoutVH = 5")
except:
	vim.command("call VimHelperStart()")
	vim.command("let g:timeoutVH -= 1")
endpy
endif
endfunction

function! VimHelperRestart()
	call VimHelperMessage("client", "0")	
	call VimHelperStart()
endfunction
function! VimHelperStart()
	"Spawn! -dir=~ python git\vim\scripts\VimHelper.py
	let g:startedExternal = 1
endfunction

function! VimHelperCompile()
	call VimHelperMessage("compile", expand("%:p"))
	let args = input("Arguments? : ")
	call VimHelperMessage("compileargs", args)
	let g:compilingVH = 1
endfunction
function! VimHelperCompileStop()
	call VimHelperMessage("compile", "")
	let g:compilingVH = 0
endfunction
" ---------------------------
" ---- [7.7] TEMPBUFFER -----
function! AddVimSection(section, subsection)
	put = '\" Base'
	put = '\" ----------------------------'
	call AddVimSectionCall(a:section, a:subsection, "~/git/vim/vim-base/base.vim")
	put = ''
	put = '\" Heavy'
	put = '\" ----------------------------'
	call AddVimSectionCall(a:section, a:subsection, "~/git/vim/heavy.vim")
endfunction
" ---------------------------
" ---------------------------
" ---- [8] AFTER VIMRC ------
if exists('setup')
	autocmd VimEnter * BundleInstall
endif
" ---------------------------
