"       HEAVY VIM
" ---- [0] Init ----------------------
let requiredFolders = ["~/.vim/tmp/compilefiles"]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
		let setup = 1
	endif
endfor
set rtp+=~/git/vim/scripts/
set tags+=~/git/vim/scripts/UltiSnips/tags/python.tags
set packpath+=~/git/vim/
" ------------------------------------
" ---- [1] Plugins -------------------
" ---- [1.1] Ultisnips-plugin ---------------
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
" ------------------------------------
" ------------------------------------
" ---- [2] Bindings ------------------
" ---- [2.0] Normal-bindings ---------
" ------------------------------------
" ---- [2.1] Insert-bindings ---------
inoremap <C-J> <C-R>=USOrSmartJump()<CR>
inoremap <C-K> <C-R>=USOrSmartJumpBack()<CR>

let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" ------------------------------------
" ---- [2.2] Visual-bindings ---------
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

xmap s S
xmap sd s]
xmap sD s>
xmap sq s"
xmap st s'
xmap sm s$
xmap s( s)
xmap s{ s}
" ------------------------------------
" ---- [2.3] Leader-bindings ---------

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
map <leader>vr :e ~/git/vim/README.md<CR>
map <leader>vv :e ~/git/vim/heavy.vim<CR>
map <leader>vb :e ~/git/vim/base.vim<CR>
map <leader>vf :e ~/git/vim/folding.vim<CR>
" W
" X
" Y
" Z - Z(S)essions
" ?
" ------------------------------------
" ---- [2.4] Omap-bindings -----------
" ------------------------------------
" ---- [2.5] Command-bindings --------
cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>Git" : "t"
" ------------------------------------
" ---- [2.6] Fugitive-bindings -------
function! FugitiveBindings()
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
	nmap <buffer> gd D
	nmap <buffer> <esc> :bd<cr>
endfunction
" ------------------------------------
" ------------------------------------
" ---- [3] Filetype ------------------
" ---- [3.0] All-filetype ------------
autocmd FileType * setlocal formatoptions-=cro
" ------------------------------------
" ---- [3.1] Gitcommit-filetype ------
autocmd FileType gitcommit call FugitiveBindings()
" ------------------------------------
" ------------------------------------
" ---- [4] Statusline ----------------
set statusline=%<\[%f\]\ %y\ %{MyStatusLine()}\ %m%=%-14.(%l-%c%)\ %P

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	if !exists('b:gitFilesStatusLine')
			let b:gitFilesStatusLine = ""
	endif
	if !exists('b:gitRowsStatusLine')
			let b:gitRowsStatusLine = ""
	endif
	return b:gitFilesStatusLine . b:gitRowsStatusLine
endfunction
" ------------------------------------
" ---- [5] Colorsettings -------------
" ------------------------------------
" ---- [6] Autocmd -------------------
autocmd BufWritePost * call UpdateGitInfo()
autocmd BufEnter * call UpdateGitInfo()
autocmd TextChanged,TextChangedI * call CreateTempFile()
autocmd FocusGained * call UpdateGitInfo()

let g:compiling = 0
function! CreateTempFile()
	if expand('%') != '' && g:compiling == 1
		call writefile(getline(1,'$'), expand("~/.vim/tmp/compilefiles/") . expand("%:t"))
	endif
endfunction
" ------------------------------------
" ---- [7] Functions -----------------
" ---- [7.0] Tabcompletion-functions -
function! CustomTab()
	if pumvisible()
		return "\<C-N>"
	else
	return "\<TAB>"
endfunction
" ------------------------------------
" ---- [7.1] Jump-functions ----------
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
" ------------------------------------
" ---- [7.2] Eval-math-functions -----
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
" ------------------------------------
" ---- [7.3] Git-info-functions ------
let g:gitUpdating = 0

function! GitStatusBuffer()
	let currentBuf = bufnr('%')
	let g:makeBufNum = bufnr('gitStatusBuffer', 1)
	exec g:makeBufNum . 'bufdo %d'
	exec 'b '. currentBuf
endfunction
function! UpdateGitInfo()
	if g:gitUpdating == 0
		let g:gitUpdating = 2
		let g:gitRowsJob = job_start(
			\ ["git", "-C", expand("%:h"), "diff", "--numstat"], {
			\ 'close_cb': 'UpdateGitRows',
			\ 'out_io': 'file',
			\ 'out_name': expand("~/.vim/tmp/tmp/gitRowStatus")})
		let g:gitFilesJob = job_start(
			\ ["git", "-C", expand("%:h"), "status", "-b", "-s"], {
			\ 'close_cb': 'UpdateGitFiles',
			\ 'out_io': 'file',
			\ 'out_name': expand("~/.vim/tmp/tmp/gitFileStatus")})
	endif
endfunction

" Adds information about git branch to statusline in the form of:
" [master->origin/master]
function! UpdateGitFiles(channel)
	if !exists('b:gitFilesStatusLine')
			let b:gitFilesStatusLine = ""
	endif
	let statusLine = ""
	let filesRaw = readfile(expand("~/.vim/tmp/tmp/gitFileStatus"))
	if len(filesRaw) > 0
		" [master->origin/master]
		let fileRaw = substitute(filesRaw[0], "#", "", "g")
		let fileRaw = substitute(fileRaw, "\\.\\.\\.", "->", "")
		let fileRaw = substitute(fileRaw, " ", "", "")
		let statusLine = "[" . fileRaw . "]"

		" [m 3]
		let filesChanged = len(filesRaw) - 1
		if filesChanged > 0
			let statusLine .= " [m " . filesChanged . "]"
		endif

		if statusLine != ""
			let b:gitFilesStatusLine = statusLine
		endif
	endif
	let g:gitUpdating -= 1
endfunction

" Changed rows from git.
" [+3 -2]
let g:testG = []
function! UpdateGitRows(channel)
	if !exists('b:gitRowsStatusLine')
			let b:gitRowsStatusLine = ""
	endif
	let statusLine = ""
	let rowsRaw = readfile(expand("~/.vim/tmp/tmp/gitRowStatus"))
	let currentFile = expand("%:t")
	for row in rowsRaw
		if row =~ currentFile && currentFile != ""
			let changedRows = split(row, "\t")
			let statusLine .= " [+" . changedRows[0] . " -" . changedRows[1] . "]"
		endif
	endfor
	if statusLine != ""
		let b:gitRowsStatusLine = statusLine
	endif
	let g:gitUpdating -= 1
endfunction
" ------------------------------------
" ---- [7.4] Temp-functions ----------
function! AddVimSection(section, subsection)
	put = '\" Base'
	put = '\" -------------------------------------'
	call AddVimSectionCall(a:section, a:subsection, "~/git/vim/base.vim")
	put = ''
	put = '\" Heavy'
	put = '\" -------------------------------------'
	call AddVimSectionCall(a:section, a:subsection, "~/git/vim/heavy.vim")
endfunction
" ------------------------------------
" ------------------------------------
" ---- [8] After vimrc ---------------
" ------------------------------------
