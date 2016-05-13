"          HEAVY VIM
" ---- [0] INITIALIZATION ----
let requiredFolders = [
		\ "~/.vim/tmp/swapfiles",
		\ "~/.vim/tmp/gitstatusline",
		\ "~/.vim/tmp/compilefiles",
		\ "~/.cache",
		\ "~/.cache/unite" ]
for rawfolder in requiredFolders
	let folder = fnamemodify(rawfolder, ":p")
	if !isdirectory(folder)
		call mkdir(folder)
		let setup = 1
	endif
endfor
if !exists('g:startedExternal')
	let g:startedExternal = 0
endif
if !exists('g:timeoutVH')
	let g:timeoutVH = 5
endif
if !exists('g:disableVimHelper')
	let g:disableVimHelper = 0
endif
set rtp+=~/git/vim/scripts/
set tags+=~/git/vim/scripts/UltiSnips/tags/python.tags
" --------------------
" ---- [1] PLUGINS ----
" ---- [1.0] VUNDLE ----
" Required by vundle
filetype off
set rtp+=~/git/vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Unite and unite plugins.
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'

" Snippets
Plugin 'SirVer/ultisnips'

" Code-completion
Plugin 'Valloric/YouCompleteMe'

" Async external commands
Plugin 'tpope/vim-dispatch'
Plugin 'Shougo/vimproc.vim'

" Div
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Konfekt/FastFold'

" Required by vundle
call vundle#end()
filetype plugin indent on
" --------------------
" ---- [1.1] ULTISNIPS ----
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
" --------------------
" ---- [1.2] YOUCOMPLETEME ----
" --------------------
" ---- [1.3] UNITE ----
let g:unite_force_overwrite_statusline = 0

call unite#custom#default_action('buffer', 'goto')
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {
			\ 'start_insert' : 1,
			\ 'smartcase' : 1,
			\ 'ignorecase' : 1,
			\ 'no_split' : 1,
			\ 'no_resize' : 1,
			\ 'update_time' : 300,
			\ 'cursor_line_highlight' : 'TabLine'
			\ })

function! UniteFixPath(path)
	if has('unix')
		let path = a:path
		return substitute(path, '//', '/', 'g')
	elseif has('win32')
		return substitute(a:path, '\', '/', 'g')
	endif
endfunction
function! UniteTags(filetype)
	let filepath = UniteFixPath(fnamemodify("~/git/info/", ':p')) . a:filetype
	if !isdirectory(filepath) && a:filetype != ""
		if confirm("About to create folders:\n\t" .
					\ filepath . "\n\t" .
					\ filepath . "/notes\n\t" .
					\ filepath . "/documentation",
				\ "&Yes\n&No\n&Cancel") == 1
			execute 'call mkdir("". "' . filepath . '")'
			execute 'call mkdir("". "' . filepath . "/notes" . '")'
			execute 'call mkdir("". "' . filepath . "/documentation" . '")'
			UniteClose
		endif
	else
		call unite#start_temporary([
		\ ['tags', a:filetype]],
		\ {'prompt' : 'tags>'})
	endif
endfunction
function! UniteExplorer(folder)
	call unite#start([['file'], ['filn'], ['dirn']], {'input' : UniteFixPath(a:folder) . "/"})
endfunction

function! UniteOpen()
	call unite#start([['buffer'], ['file_mru']])
endfunction

let my_dir = {
      \ 'description' : 'yank word or text',
      \ 'is_selectable' : 1,
      \ }
function! my_dir.func(candidates)
	let text = join(map(copy(a:candidates),
		\ "get(v:val, 'action__text', v:val.word)"), "\n")
	if isdirectory(text)
		let text = text . "/"
	endif
	call unite#start([['file'], ['filn'], ['dirn']], {'input' : text})
endfunction
call unite#custom_action('directory', 'my_dir', my_dir)
call unite#custom#default_action('directory', 'my_dir')
" --------------------
" --------------------
" ---- [2] BINDINGS ----
" ---- [2.0] NORMAL ----
nnoremap ö :call UniteOpen()<CR>
nnoremap Ö :call UniteExplorer(expand("%:p:h"))<CR>
nnoremap M! :delmarks A-Z<CR>:call UpdateMarks()<CR>
nnoremap m! :delmarks A-Z<CR>:call UpdateMarks()<CR>
function! BindMark(uMap)
	let lMap = tolower(a:uMap)
	execute "nnoremap M" . lMap . " m" . a:uMap . ":call UpdateMarks()<CR>"
	execute "nnoremap M" . a:uMap . " m" . lMap . ":call UpdateMarks()<CR>"
endfunction
call StartBind()
" --------------------
" ---- [2.1] INSERT ----
inoremap <TAB> <C-R>=NeoTab()<CR>
inoremap <S-TAB> <C-P>

inoremap <C-J> <C-R>=USOrSmartJump()<CR>
inoremap <C-K> <C-R>=USOrSmartJumpBack()<CR>

let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" --------------------
" ---- [2.2] VISUAL ----
xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs

xmap s S
xmap sd s]
xmap sD s>
xmap sq s"
xmap st s'
xmap sm s$
xmap s( s)
xmap s{ s}
" --------------------
" ---- [2.3] LEADER ----

" A
" B - Bookmark
map <leader>b :Unite -prompt=bookmark> bmark<CR>
" C - Compile
" D - Delete buffer
" E - Start external
" F
noremap <leader>f :Unite line -custom-line-enable-highlight<CR>
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
map <leader>hu :Unite us <CR>
" I - Information, notes on helpful things.
map <leader>ii :call UniteTags(&l:filetype)<CR>
map <leader>iI :Unite tagfolders:~/git/info/ <CR>
map <leader>ia :Unite tagfolders:~/git/info/ <CR>
map <leader>in :Unite notes:~/git/info/ <CR>
map <leader>if :Unite notes:~/git/info/ <CR>
map <leader>ir :call VimHelperMessage("tags", "") <CR>
" J - Format json file.
map <leader>j :%!python -m json.tool<CR>
" K
" L
" M - Make
" N - Next buffer
" O - Open file explorer
map <leader>o :call UniteOpen()<CR>
map <leader>O :call UniteExplorer(expand("%:p:h"))<CR>
" P - Quickfix commands
" Q - Quickfix commands
" R - Run file or project / Stop file or project
map <leader>r :call VimHelperCompile() <cr>
map <leader>R :call VimHelperMessage("compile", "") <cr>
" S - Spellcheck
" T - Tabs, temp and tabformat
" U - Ultisnips
map <leader>ue :UltiSnipsEdit <CR>
map <leader>uu :Unite file:~/git/vim/scripts/Ultisnips/ <CR>
map <leader>ua :Unite us <CR>
map <leader>uh :Unite us <CR>
map <leader>ul :Unite us <CR>
map <leader>us :Unite us <CR>
" V - .vimrc
map <leader>vR :call VimHelperRestart()<CR>
map <leader>vh :e ~/git/vim/scripts/VimHelper.py<CR>
map <leader>vr :e ~/git/vim/README.md<CR>
map <leader>vv :e ~/git/vim/heavy.vim<CR>
map <leader>vh :e ~/git/vim/heavy.vim<CR>
map <leader>vb :e ~/git/vim/vim-base/base.vim<CR>
map <leader>vf :e ~/git/vim/vim-base/folding.vim<CR>
" W
" X
" Y
" Z - Z(S)essions
" ?
" --------------------
" ---- [2.4] OMAP ----
" --------------------
" ---- [2.5] COMMAND ----
cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>Git" : "t"
" --------------------
" ---- [2.6] UNITE ----
function! UniteBinds()
	nmap <buffer> b :Unite -prompt=bookmark> bmark<CR>
	nmap <buffer> <ESC> :execute "normal \<Plug>(unite_all_exit)"<CR>
	nmap <buffer> <S-Space> <Plug>(unite_redraw)
	nmap <buffer> <BS> <Plug>(unite_insert_enter)
	nmap <buffer> <space> V<space>
	xmap <buffer> <TAB> <space><Plug>(unite_choose_action)
	nnoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	imap <buffer> <TAB> <Plug>(unite_select_next_line)
	imap <buffer> <S-TAB> <Plug>(unite_select_previous_line)
	imap <buffer> <S-Space> <Plug>(unite_redraw)
	inoremap <buffer> <BS> <BS>
	inoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
endfunction
autocmd FileType unite call UniteBinds()
" --------------------
" ---- [2.7] FUGITIVE ----
function! FugitiveBindings()
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
	nmap <buffer> gd D
	nmap <buffer> <esc> :bd<cr>
endfunction
" --------------------
" --------------------
" ---- [3] FILETYPE SPECIFIC ----
" ---- [3.0] All ----
autocmd FileType * setlocal formatoptions-=cro
" --------------------
" ---- [3.1] JAVA ----
" --------------------
" ---- [3.2] C# ----
" --------------------
" ---- [3.3] C ----
" --------------------
" ---- [3.4] VIMRC ----
" --------------------
" ---- [3.5] SNIPPET ----
" --------------------
" ---- [3.6] TODO ----
" --------------------
" ---- [3.7] PYTHON ----
" --------------------
" ---- [3.8] LUA ----
" --------------------
" ---- [3.9] MAKE ----
" --------------------
" ---- [3.10] PASS ----
" --------------------
" ---- [3.11] JAPANESE ----
" --------------------
" ---- [3.12] LATEX ----
" --------------------
" ---- [3.13] GITCOMMIT ----
function! GITCSettings()
	let &foldlevel = 99
	call FugitiveBindings()
	call EnglishSpellCheck()
endfunction

autocmd FileType gitcommit call GITCSettings()
" --------------------
" ---- [3.14] MARKDOWN ----
" --------------------
" ---- [3.15] NOTE ----
" --------------------
" --------------------
" ---- [4] STATUSLINE ----
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
" --------------------
" ---- [5] COLORSETTINGS ----
" ---- [5.0] DEFAULT ----
" --------------------
" ---- [5.1] DRAW ----
hi MarkA guibg=aquamarine guifg=blue ctermbg=123 ctermfg=27
hi MarkB guibg=brown guifg=black ctermbg=130 ctermfg=0
hi MarkC guibg=coral guifg=brown ctermbg=173 ctermfg=130
hi MarkD guibg=black guifg=cyan1 ctermbg=0 ctermfg=14
hi MarkE guibg=black guifg=red ctermbg=0 ctermfg=1
hi MarkF guibg=black guifg=yellow ctermbg=0 ctermfg=11
hi MarkH guibg=lightpink guifg=hotpink ctermbg=211 ctermfg=201
hi MarkI guibg=grey40 guifg=black ctermbg=8 ctermfg=0
hi MarkJ guibg=red guifg=green ctermbg=9 ctermfg=40
hi MarkK guibg=khaki4 guifg=white ctermbg=65 ctermfg=255
hi MarkL guibg=limegreen guifg=darkgreen ctermbg=40 ctermfg=28
hi MarkM guibg=goldenrod2 guifg=orange4 ctermbg=136 ctermfg=94
hi MarkN guibg=#002211 guifg=green ctermbg=0 ctermfg=40
hi MarkO guibg=darkorange2 guifg=darkorange4 ctermbg=208 ctermfg=130
hi MarkP guibg=purple guifg=white ctermbg=129 ctermfg=255
hi MarkQ guibg=darkcyan guifg=black ctermbg=29 ctermfg=17
hi MarkR guibg=red guifg=black ctermbg=1 ctermfg=0
hi MarkS guibg=black guifg=salmon ctermbg=0 ctermfg=167
hi MarkT guibg=tomato guifg=black ctermbg=167 ctermfg=0
hi MarkU guibg=darkblue guifg=yellow1 ctermbg=19 ctermfg=11
hi MarkV guibg=blue1 guifg=white ctermbg=33 ctermfg=255
hi MarkW guibg=white guifg=black ctermbg=255 ctermfg=0
hi MarkX guibg=black guifg=white ctermbg=0 ctermfg=255
hi MarkY guibg=yellow guifg=black ctermbg=11 ctermfg=0
hi MarkZ guibg=lightgreen guifg=black ctermbg=156 ctermfg=0
" --------------------
" ---- [5.2] MARK COLORNAMES ----
"[a]quamarine
"[b]rown
"[c]oral
"[d]iamant
"[e]rror
"[f]lourescent light
"[h]ot pink
"[i]nvisible
"[j]ul
"[k]haki
"[l]ime -
"[m]ustard
"[n]eon green
"[o]range
"[p]urple
"dar[q]cyan
"[r]ed
"[s]almon
"[t]omato
"[u]tomhus
"[v]atten
"[w]hite
"black te[x]t
"[y]ellow
"[z] - weird color, weird letter
" --------------------
" ---- [5.3] UNITE ----
hi uniteSource__Dir gui=NONE cterm=NONE guifg=khaki ctermfg=228
hi link uniteSource__Fil Identifier
hi link uniteCandidateInputKeyword Search
hi default link uniteSource__Fil_Special PreProc
" --------------------
" --------------------
" ---- [6] AUTOCMD ----
autocmd BufWritePost * call UpdateGitInfo()
autocmd BufEnter * call UpdateGitInfo()
autocmd TextChanged,TextChangedI * call CreateTempFile()

autocmd VimLeave * call OnExit()
autocmd VimEnter * call AfterInit()

function! CreateTempFile()
	if expand('%') != ''
		call writefile(getline(1,'$'), expand("~") . "/.vim/tmp/compilefiles/" . expand("%:t"))
	endif
endfunction
" --------------------
" ---- [7] FUNCTIONS ----
" ---- [7.0] TABCOMPLETION ----
function! NeoTab()
	if pumvisible()
		return "\<C-N>"
	else
	return SpecialDelim("\<TAB>")
endfunction
" --------------------
" ---- [7.1] JUMP ----
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
" --------------------
" ---- [7.2] EVALUATE MATH ----
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
" --------------------
" ---- [7.3] START EXTERNAL ----
" --------------------
" ---- [7.4] GIT INFO ----
function! UpdateGitInfo()
	let b:statusLineVar = ""
	call VimHelperMessage("path", expand("%:p"))
endfunction
" --------------------
" ---- [7.5] ON EXIT ----
function! OnExit()
	call VimHelperMessage("client", "-1")
endfunction
" --------------------
" ---- [7.6] AFTER INIT ----
function! AfterInit()
	if !g:startedExternal
		call VimHelperMessage("client", "1")
	endif
endfunction
" --------------------
" ---- [7.7] VIMHELPER ----
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
	let g:startedExternal = 5
	call VimHelperMessage("client", "0")	
	call VimHelperStart()
endfunction
function! VimHelperStart()
	Spawn! -dir=~ python git\vim\scripts\VimHelper.py
	let g:startedExternal = 1
endfunction

function! VimHelperCompile()
	call VimHelperMessage("compile", expand("%:p"))
	let args = input("Arguments? : ")
	call VimHelperMessage("compileargs", args)
endfunction
" --------------------
" ---- [7.8] MARKS ----
function! AddMarkMatches()
	for mark in g:marks
		call matchadd('Mark' . mark, "\\%'" . mark . '.')
	endfor
endfunction
function! HelpMarkColor()
	for i in range(len(g:marks))
		call matchaddpos('Mark' . g:marks[i], [[i+1]])
	endfor
endfunction
function! UpdateMarks()
	call clearmatches()
	call AddMarkMatches()
endfunction
call UpdateMarks()
" --------------------
" --------------------
" ---- [8] AFTER VIMRC ----
if exists('setup')
	autocmd VimEnter * BundleInstall
endif
" --------------------