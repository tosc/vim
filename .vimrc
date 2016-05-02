" ---- [0] INITIALIZATION ----
let requiredFolders = [
		\ "~/.vim",
		\ "~/.vim/tmp",
		\ "~/.vim/tmp/tmp",
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
		let g:disablePlugins = 1
		let g:disableExternal = 1
	endif
endfor

if !exists('g:disablePlugins')
	let g:disablePlugins = 0
endif
if !exists('g:minimalMode')
	let g:minimalMode = 0
endif
if !exists('g:disableExternal')
	let g:disableExternal = 0
endif
if !exists('g:startExternal')
	let g:startedExternal = 0
endif
if !exists('g:disableVimHelper')
	let g:disableVimHelper = 0
endif
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
" Ignore message from exisiting swap
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
set formatoptions-=cro
set updatetime=1000
set backspace=indent,eol,start
let $LANG = 'en'
set colorcolumn=78
set textwidth=0
set wrapmargin=0

" Shows whitespaces and tabs when using list.
set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ 
set list

" Shows marks on autowrapped lines
set showbreak=<<

set sessionoptions-=options
set sessionoptions+=folds

set rtp+=~/git/vim/scripts/

"Disables bug with bg using putty
set t_ut=

syntax on
" ---------
" ---- [2] PLUGINS ----
" ---- [2.0] VUNDLE ----
if exists('setup') || (!exists("g:reload") && !g:disablePlugins)
	" Required by vundle
	filetype off
	set rtp+=~/git/vim/bundle/Vundle.vim/
	call vundle#begin()
	Plugin 'gmarik/Vundle.vim'

	" Unite and unite plugins.
	Plugin 'Shougo/unite.vim'
	Plugin 'Shougo/neomru.vim'
	Plugin 'Shougo/unite-build'
	Plugin 'Shougo/unite-help'

	" Snippets
	Plugin 'SirVer/ultisnips'

	" Code-completion
if has('lua') && !g:minimalMode
	Plugin 'Shougo/neocomplete.vim'
endif
	" Omnicomplete engines.
	Plugin 'Rip-Rip/clang_complete'
	Plugin 'OmniSharp/omnisharp-vim'

	" Async external commands
	Plugin 'tpope/vim-dispatch'
	Plugin 'Shougo/vimproc.vim'

	" Syntax checker and syntax engines.
	Plugin 'scrooloose/syntastic'

	" Div
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'Konfekt/FastFold'

	" Required by vundle
	call vundle#end()
	filetype plugin indent on
endif
" ----------
" ---- [2.1] ULTISNIPS ----
" Needed for checking if a ultisnips action has happened.
let g:ulti_expand_res = 0
let g:ulti_jump_forwards_res = 0
let g:ulti_jump_backwards_res = 0

" Remove default ultisnips bindings.
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsListSnippets ="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<Nop>"
let g:UltiSnipsJumpBackwardTrigger="<Nop>"

let g:UltiSnipsSnippetsDir = "~/git/vim/scripts/UltiSnips"
" --------
" ---- [2.2] ECLIM ----
" Sets eclims completionmethod to omnifunc
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimFileTypeValidate = 0
" -----
" ---- [2.3] OMNISHARP (C# OMNICOMPLETE) ----
let g:OmniSharp_typeLookupInPreview = 1
" Sets the sln file to the first file avaliable
let g:OmniSharp_sln_list_index = 1
" If omnisharp server is running never stop it.
let g:Omnisharp_stop_server = 0
" -------
" ---- [2.4] UNITE ----
let g:unite_force_overwrite_statusline = 0

if !g:disablePlugins
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
endif

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
" ---- [2.5] NEOCOMPLETE ----
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#skip_auto_completion_time = ''
let g:neocomplete#auto_completion_start_length = 2

if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns.default = '\h\w*\|[^.\t]\.\w*'
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.cs = '.*'
let g:neocomplete#sources#omni#input_patterns.java = '.*'

if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.objc =
	\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp =
	\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

if !exists('g:neocomplete#sources')
	let g:neocomplete#sources = {}
endif
let g:neocomplete#sources._ = ['us']
let g:neocomplete#sources.vim = ['_']
let g:neocomplete#sources.python = ['us', 'jedi']
let g:neocomplete#sources.cs = ['us', 'omni']

let g:neocomplete#enable_smart_case = 0
let g:neocomplete#enable_camel_case_completion = 0
let g:neocomplete#enable_ignore_case = 0
let g:neocomplete#sources#syntax#min_keyword_length = 1
let g:neocomplete#min_keyword_length = 1
let g:neocomplete#enable_auto_close_preview = 0
let g:neocomplete#enable_fuzzy_completion = 0

let g:clang_complete_auto = 0
let g:clang_auto_select = 0
" --------------------
" ---- [2.6] SYNTASTIC ----
let g:syntastic_mode_map = { "mode": "active",
			   \ "active_filetypes": [],
			   \ "passive_filetypes": ["vim"] }
let g:syntastic_auto_loc_list = 1
" --------------------
" --------------------
" ---- [3] BINDINGS ----
" ---- [3.0] NORMAL ----
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

if !g:disablePlugins
	" Search file using unite.
	nnoremap ä :Unite line -custom-line-enable-highlight<CR>

	nnoremap ö :Unite buffer file_mru<CR>
	nnoremap Ö :call UniteExplorer(expand("%:p:h"))<CR>
else
	nnoremap ä /
	nnoremap ö :e
	nnoremap Ö :e
endif

"SmartJump
nnoremap <C-E> :call SmartJump()<CR>
nnoremap <C-B> :call SmartJumpBack()<CR>

"Switches repeat f/F, feels more logical on swedish keyboard.
nnoremap , ;
nnoremap ; ,

" Jump to tag. C-T to jump back.
nnoremap <C-J> <C-]>

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
" ---- [3.1] INSERT ----
" Ctrl + del and Ctrl + bs like normal editors in insert
inoremap <C-BS> <C-W>
inoremap <C-Del> <C-O>de

" Shift-Enter acts like O in normal
inoremap <S-CR> <C-O>O

" Autocomplete filename.
inoremap <C-F> <C-X><C-F>

" Autocomplete spelling
inoremap <C-S> <C-X><C-S>

if !g:disablePlugins
	" Run my tabcompletion.
	inoremap <TAB> <C-R>=NeoTab()<CR>
else
	" Simple tabcompletion.
	inoremap <expr><TAB> getline(".")[col('.') - 2] =~ '\w' ? '<C-X><C-N>' : SpecialDelim("\<TAB>")
endif

" Jump to next(previous) ultisnips location if one exists, 
" else jump to next(previous) delimiter.
inoremap <pageup> <C-R>=SmartJump()<CR>
inoremap <pagedown> <C-R>=SmartJumpBack()<CR>
inoremap <C-E> <C-R>=SmartJump()<CR>
inoremap <C-B> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-K> <C-O>D

" Pressing enter chooses completion if completion window is up.
inoremap <expr> <CR> pumvisible() ? '<C-e><CR>' : SpecialDelim("\<CR>")

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
" ---- [3.2] VISUAL ----
" I keep pressing << >> in the wrong order. HL are good for directions.
" Also reselects after action.
vnoremap H <gv
vnoremap L >gv

"Switches repeat f/F, feels more logical on swedish keyboard.
vnoremap , ;
vnoremap ; ,

xnoremap + $

xnoremap å c<C-R>=PythonMath()<CR>

" Jump to next(previous) ultisnips location if one exists,
" else jump to next(previous) delimiter.
snoremap <pageup> <ESC>:call SmartJump()<CR>
snoremap <pagedown> <ESC>:call SmartJumpBack()<CR>
snoremap <C-E> <ESC>:call SmartJump()<CR>
snoremap <C-B> <ESC>:call SmartJumpBack()<CR>

if !g:disablePlugins
	xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
endif

" Remapped vim surround to s since all it does normaly is cl.
if !g:disablePlugins
	xmap s S
	xmap sd s]
	xmap sD s>
	xmap sq s"
	xmap st s'
	xmap sm s$
	xmap s( s)
	xmap s{ s}
endif
" --------------------
" ---- [3.3] LEADER ----
let g:mapleader="\<space>"

" A
" B - Bookmark
map <leader>b :Unite -prompt=bookmark> bmark<CR>
" C - Compile
map <leader>co :Errors<CR>
map <leader>cc :SyntasticCheck<CR>
map <leader>ce :SyntasticCheck<CR>
" D - Delete buffer
map <leader>d :bd<CR>
map <leader>D :bd!<CR>
" E - Start external
autocmd Filetype tex map <leader>e :Spawn! -dir=~ .vim\tmp\tmp\main.pdf <cr>
" F
noremap <leader>f :Unite line -custom-line-enable-highlight<CR>
" G - Git
map <leader>gc :!git -C %:h commit<CR>
map <leader>gd :!git -C %:h diff<CR>
map <leader>gD :!git -C %:h diff<CR>
map <leader>gf :!git -C %:h fetch<CR> :call UpdateGitInfo()<CR>
map <leader>gF :!git -C %:h pull<CR> :call UpdateGitInfo()<CR>
map <leader>gg :!git -C %:h status<CR>
map <leader>gp :!git -C %:h push<CR> :call UpdateGitInfo()<CR>
map <leader>gP :!git -C %:h push --force<CR> :call UpdateGitInfo()<CR>
" Opens a interactive menu that lets you pick what commits to use/squash.
map <leader>gr :!git -C %:h rebase -i HEAD~

"HardReset
function! ResetGit()
	if confirm("Reset git to remote?", "y\nn") == 1
		echo system("git -C " . expand("%:p:h") . " reset --hard origin/HEAD")
	endif
endfunction
map <leader>gR :call ResetGit()<CR>

map <leader>gh :call HighlightDrawDisable()<CR>
map <leader>g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" H -<CR> :0,.-1d<CR>/^" I -<CR> :.,$d<CR>gg

if !g:disablePlugins
	map <leader>gc :Gcommit<CR>
	map <leader>gd :Gdiff<CR>
	map <leader>gg :Gstatus<CR>
endif
" H - Help, show binds.
map <leader>hn :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.0\]<CR> :0,.-1d<CR>/^" ---- \[3.1\]<CR> :.,$d<CR>gg
map <leader>hi :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.1\]<CR> :0,.-1d<CR>/^" ---- \[3.2\]<CR> :.,$d<CR>gg
map <leader>hv :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.2\]<CR> :0,.-1d<CR>/^" ---- \[3.3\]<CR> :.,$d<CR>gg
map <leader>hl :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.3\]<CR> :0,.-1d<CR>/^" ---- \[3.4\]<CR> :.,$d<CR>gg
map <leader>hh :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.3\]<CR> :0,.-1d<CR>/^" ---- \[3.4\]<CR> :.,$d<CR>gg
map <leader>hc :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.5\]<CR> :0,.-1d<CR>/^" ---- \[3.6\]<CR> :.,$d<CR>gg
map <leader>hu :Unite us <CR>
map <leader>hm :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r
	\ ~/git/vim/.vimrc <CR> /^" ---- \[9.2\]<CR>j :0,.-1d<CR>/^" --------<CR>
	\ :.,$d<CR>:call HelpMarkColor()<CR>
" I - Information, notes on helpful things.
map <leader>ii :call UniteTags(&l:filetype)<CR>
map <leader>iI :Unite tagfolders:~/git/info/ <CR>
map <leader>ia :Unite tagfolders:~/git/info/ <CR>
map <leader>in :Unite notes:~/git/info/ <CR>
map <leader>if :Unite notes:~/git/info/ <CR>
map <leader>ir :execute "! python " . fnamemodify("~/git/vim/TagGenerator.py", ':p') <CR>
" J - Format json file.
map <leader>j :%!python -m json.tool<CR>
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
map <leader>o :Unite buffer file_mru<CR>
map <leader>O :call UniteExplorer(expand("%:p:h"))<CR>
map <leader>p :bp <CR>
" Q - Quit window (not used?)
map <leader>q :q <CR>
" R - Run file or project / Stop file or project
map <leader>r :call MessageVimHelper("compile", expand("%:p")) <cr>
map <leader>R :call MessageVimHelper("compile", "") <cr>
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
if !g:disablePlugins
	map <leader>ue :UltiSnipsEdit <CR>
	map <leader>uu :Unite file:~/git/vim/scripts/Ultisnips/ <CR>
	map <leader>ua :Unite us <CR>
	map <leader>uh :Unite us <CR>
	map <leader>ul :Unite us <CR>
	map <leader>us :Unite us <CR>
endif
" V - .vimrc
map <leader>vr :e ~/git/vim/README.md<CR>
map <leader>vh :e ~/git/vim/VimHelper.py<CR>
map <leader>vv :e ~/git/vim/.vimrc<CR>
map <leader>vd :w !diff % -<CR>
" W
" X
" Y
" Z - Z(S)essions
" ?
map <leader>? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /^" H -<CR> :0,.-1d<CR>/^" I -<CR> :.,$d<CR>gg
" --------------------
" ---- [3.4] OMAP ----
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
" ---- [3.5] COMMAND ----
cnoremap <C-BS> <C-W>

" Readline bindings.
cnoremap <C-A> <home>
cnoremap <C-E> <end>
cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

cnoremap <expr> h<space> getcmdtype() == ":" && getcmdline() == "" ? "call FullScreenHelp('')\<left>\<left>" : "h "
cnoremap <expr> n getcmdtype() == ":" && getcmdline() == "t" ? 'abnew' : "n"
cnoremap <expr> c getcmdtype() == ":" && getcmdline() == "t" ? 'abc' : "c"

if !g:disablePlugins
	" I tend to write :git instead of :Git
	cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>Git" : "t"
else
	cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>!git" : "t"
endif

"tt filename opens opens a file with filename in a tmp folder.
cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "t" ? "\<bs>Tt" : "t"
command -nargs=1 Tt :e ~\.vim\tmp\tmp\<args>

" Show the my normal and insert bindings.
cnoremap <expr> ? getcmdtype() == ":" && getcmdline() == "g" ? 
			\ "\<bs>" . 'call OpohBuffer() <bar> setlocal syntax=vim <bar>
			\ keepalt r ~/git/vim/.vimrc <CR> /^" ---- \[3.4\]<CR>
			\ :0,.-1d<CR>/^" ---- \[3.5\]<CR> :.,$d<CR>gg' : '?'

" See insert for delimiterbindings.
" --------------------
" ---- [3.6] UNITE ----
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
" ---- [3.7] FUGITIVE ----
function! FugitiveBindings()
	" Fast movement for :GStatus
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
	nmap <buffer> <esc> :bd<cr>
endfunction
" --------------------
" ---- [3.8] OPOHBUFFER ----
function! OpohBinds()
	nnoremap <buffer> <ESC> :execute("b #")<CR>
endfunction
autocmd FileType opoh call OpohBinds()
" --------------------
" --------------------
" ---- [4] FILETYPE SPECIFIC ----
" ---- [4.0] All ----
" :set filetype? To know current loaded filetype
" --------
" ---- [4.1] JAVA ----
function! JavaSettings()
	setlocal omnifunc=JavaOmni
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
endfunction

function! JavaOmni(findstart, base)
	let words = eclim#java#complete#CodeComplete(a:findstart, a:base)
	return FilterOmni(words, a:findstart, a:base)
endfunction

autocmd Filetype java call JavaSettings()
" --------
" ---- [4.2] C# ----
function! CSSettings()
	setlocal omnifunc=CSOmni
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
	let g:unite_builder_make_command = "msbuild"
endfunction

function! CSOmni(findstart, base)
	let words = OmniSharp#Complete(a:findstart, a:base)
	return FilterOmni(words, a:findstart, a:base)
endfunction

" Updates omnisharp to include new methods
autocmd BufWritePost *.cs :OmniSharpReloadSolution

autocmd Filetype cs call CSSettings()
" ----------------
" ---- [4.3] C ----
function! CSettings()
	setlocal omnifunc=COmni
	setlocal foldexpr=BraceFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

function! COmni(findstart, base)
	let words = ccomplete#Complete(a:findstart, a:base)
	return FilterOmni(words, a:findstart, a:base)
endfunction

autocmd Filetype c,cpp call CSettings()
" --------------------
" ---- [4.4] VIMRC ----
function! VimSettings()
	setlocal foldexpr=VimrcFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Pentadactyl file is a vim file.
autocmd BufRead .pentadactylrc set filetype=vim
autocmd Filetype vim call VimSettings()
" -------------
" ---- [4.5] SNIPPET ----
function! SnippetSettings()
	setlocal foldexpr=SnippetFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	setlocal foldmethod=expr
endfunction

function! SnippetUpdate()
	let oldCWD = getcwd()
	cd ~\git\vim
	Start python SnippetComplete.py
	execute 'cd ' . oldCWD
endfunction

autocmd BufWritePost *.snippets call SnippetUpdate()
autocmd Filetype snippets call SnippetSettings()
" --------------------
" ---- [4.6] TODO ----
function! TODOSettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Files that end with .td are now todofiles.
autocmd BufEnter *.td setlocal filetype=todo

autocmd Filetype todo call TODOSettings()
" --------------------
" ---- [4.7] PYTHON ----
function! PythonSettings()
	setlocal omnifunc=
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype python call PythonSettings()
" --------------------
" ---- [4.8] LUA ----
function! LUASettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype lua call LUASettings()
" -------------
" ---- [4.9] MAKE ----
function! MAKESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype make call MAKESettings()
" -------------
" ---- [4.10] PASS ----
function! PASSSettings()
	setlocal foldexpr=PassFolding(v:lnum)
	setlocal foldtext=PassFoldText()
	setlocal foldminlines=0
	FastFoldUpdate
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
" ---- [4.11] JAPANESE ----
function! JAPANESESettings()
	set guifont=MS_Gothic:h16:w8
	set fileencoding=utf-8
	set encoding=utf-8
endfunction

" Files that end with .jp are now japanese files.
autocmd BufNewFile,BufRead *.jp set filetype=jp

autocmd Filetype jp call JAPANESESettings()
" -------------
" ---- [4.12] LATEX ----
function! TEXSettings()
	setlocal foldexpr=IndentFolding2(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd Filetype tex,plaintex call TEXSettings()
" --------------------
" ---- [4.13] GITCOMMIT ----
function! GITCSettings()
	" Don't fold gitstuff.
	let &foldlevel = 99
	call FugitiveBindings()
	call EnglishSpellCheck()
endfunction

autocmd FileType gitcommit call GITCSettings()
" --------------------
" ---- [4.14] MARKDOWN ----
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	call EnglishSpellCheck()
endfunction

autocmd FileType markdown call MDSettings()
" --------------------
" ---- [4.15] NOTE ----
function! NOTESettings()
	setlocal foldexpr=IndentFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

" Files that end with .pass are now password files.
autocmd BufNewFile,BufRead *.note set filetype=note

autocmd Filetype note call PASSSettings()
autocmd BufWritePost *.note execute "! python " . fnamemodify("~/git/vim/TagGenerator.py", ':p')
" --------------------
" --------------------
" ---- [5] FOLDING ----
" ---- [5.0] FOLDSETTINGS ----
set foldmethod=expr
set foldnestmax=2
set foldopen=
" --------------------
" ---- [5.1] FOLDEXPR ----
" ---- [5.1.0] GLOBAL VARIABLES ----
let g:InsideBrace = 0
let g:InsideVar = 0
let g:InsideComment = 0
" --------------------
" ---- [5.1.1] C# JAVA ----
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
			if line =~ '^\s*}' && indent(a:lnum)/8 == 1
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
			elseif line =~ '{' && indent(a:lnum)/8 == 1
				let g:InsideBrace = 1
				return ">1"
			elseif line =~ '/// <summary>' && indent(a:lnum)/8 == 1
				let g:InsideBrace = 1
				return ">1"
			elseif line =~ '@Override' && indent(a:lnum)/8 == 1
				let g:InsideBrace = 1
				return ">1"
			elseif nextline =~ '^\s*{' && indent(a:lnum + 1)/8 == 1
				let g:InsideBrace = 1
				return ">1"
			elseif indent(a:lnum)/8 >= 1
				return 1
			else
				return 0
			endif
		endif
	endif
endfunction
" --------------------
" ---- [5.1.2] C ----
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
" ---- [5.1.3] VIM ----
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
" ---- [5.1.4] SNIPPETS ----
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
" ---- [5.1.5] TODO LUA MAKE ----
" Includes row before new indent.
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
" --------------------
" ---- [5.1.6] PYTHON ----
function! PythonFolding(lnum)
	let line = getline(a:lnum)
	if line =~ '^import' || line =~ '^from'
		let g:InsideVar = 0
		return 1
	elseif line =~ '\S'
		if line =~ '^\s*def'
			let g:InsideVar = 1
			return ">1"
		elseif line =~ '^\s*class'
			let g:InsideVar = 0
			return 0
		elseif indent(a:lnum)/8 < indent(a:lnum+1)/8 && g:InsideVar == 0
			return ">1"
		else
			if g:InsideVar > indent(a:lnum)/8 || g:InsideVar == 0
				let g:InsideVar = 0
				return indent(a:lnum)/8
			else
				return g:InsideVar
			endif
		endif
	else
		return '='
	endif
endfunction
" --------------------
" ---- [5.1.7] LATEX ----
" Includes row before new indent and row after.
function! IndentFolding2(lnum)
	let line = getline(a:lnum)
	if line =~ "^\s*$"
		return '='
	elseif indent(a:lnum)/8 < indent(a:lnum+1)/8
		return ">" . indent(a:lnum+1)/8
	elseif indent(a:lnum)/8 < indent(a:lnum-1)/8 && 
		\ (line =~ '^\s*\\end' || line =~ '^\s*\\]')
		return "<" . indent(a:lnum-1)/8
	else
		return indent(a:lnum)/8
	endif
endfunction
" --------------------
" ---- [5.1.8] PASS ----
function! PassFolding(lnum)
	let line = getline(a:lnum)
	if line == ""
		return 0
	endif
	return ">1"
endfunction
" --------------------
" ---- [5.1.9] MARKDOWN ----
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
" ---- [5.2] FOLDTEXT ----
" ---- [5.2.0] DEFAULT ----
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
" ---- [5.2.1] CS JAVA ----
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
" ---- [5.2.2] PASS ----
" name pass username
" name -------------
function! PassFoldText()
	let line = getline(v:foldstart)
	let words = split(line, '\t')
	return words[0]
endfunction
" --------------------
" --------------------
" --------------------
" ---- [6] STATUSLINE ----
set laststatus=2
set statusline=%<\[%f\]\ %y\ %{MyStatusLine()}\ %m%=%-14.(%l-%c%)\ %P
if !g:disablePlugins
	set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
endif

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	let b:statusLineVar = ""
	if !g:disablePlugins
		if SyntasticStatuslineFlag() == ""
			hi StatusLine guibg=NONE
		else
			hi StatusLine guibg=red
		endif
	endif
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
" ---- [7] TABLINE ----
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
" ---- [8] MINIMALMODE ----
if g:minimalMode
	let s:CompletionCommand = "\<C-X>\<C-U>"
	inoremap <TAB> <C-R>=MinimalTab()<CR>
	let g:syntastic_mode_map = { "mode": "passive",
				   \ "active_filetypes": [],
				   \ "passive_filetypes": [] }
endif
" --------------------
" ---- [9] COLORSETTINGS ----
" ---- [9.0] DEFAULT ----
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
" ---- [9.1] DRAW ----
function! HighlightGitEnable()
	hi GitAdd guibg=#002211 guifg=green ctermbg=22 ctermfg=10
	hi GitRem guibg=#660000 guifg=red ctermbg=52 ctermfg=211
	hi GitCng guibg=#000066 guifg=#00DDFF ctermbg=17 ctermfg=51
endfunction
function! HighlightMarkEnable()
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
endfunction
function! HighlightDrawEnable()
	call HighlightGitEnable()
	call HighlightMarkEnable()
endfunction

function! HighlightGitDisable()
	hi clear GitAdd		
	hi clear GitRem
	hi clear GitCng		
endfunction
function! HighlightMarkDisable()
	for mark in g:marks
		execute "hi clear Mark" . mark
	endfor
endfunction
function! HighlightDrawDisable()
	call HighlightGitDisable()
	call HighlightMarkDisable()
endfunction
" --------------------
" ---- [9.2] MARK COLORNAMES ----
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
" ---- [9.3] UNITE ----
hi uniteSource__Dir gui=NONE cterm=NONE guifg=khaki ctermfg=228
hi link uniteSource__Fil Identifier
hi link uniteCandidateInputKeyword Search
hi default link uniteSource__Fil_Special PreProc
" --------------------
" --------------------
" ---- [10] AUTOCMD ----
autocmd BufWritePost * call UpdateGitInfo()

autocmd FocusGained * call UpdateGitStatusBar()

autocmd BufEnter * call UpdateGitInfo()

" To make FastFold calculate the folds when you open a file.
autocmd BufReadPost * normal zuz

autocmd TextChanged,TextChangedI * call HighlightGitDisable()
autocmd TextChanged,TextChangedI * call CreateTempFile()
autocmd InsertCharPre * let v:char = Delim(v:char)
autocmd InsertEnter * call HighlightDrawDisable()
autocmd InsertLeave * call HighlightDrawEnable()

autocmd VimLeave * call OnExit()
autocmd VimEnter * call AfterInit()

function! CreateTempFile()
	if expand('%') != ''
		call writefile(getline(1,'$'), expand("~") . "/.vim/tmp/compilefiles/" . expand("%:t"))
	endif
endfunction
" --------------------
" ---- [11] FUNCTIONS ----
" ---- [11.0] TABCOMPLETION ----
function! NeoTab()
	call UltiSnips#ExpandSnippet()
	if g:ulti_expand_res == 1
		return ""
	endif
	if getline(".")[col('.') - 2] =~ '\w'
		let longestCommon = NeoLongestCommon()
		if longestCommon == ""
			return pumvisible() ? "" : SpecialDelim("\<TAB>")
		endif
		return longestCommon
	endif
	return SpecialDelim("\<TAB>")
endfunction

function! NeoLongestCommon()
	let neocomplete = neocomplete#get_current_neocomplete()
	let complete_str = neocomplete#helper#match_word(neocomplete#get_cur_text(1))[1]
	let candidates = neocomplete#filters#matcher_head#define().filter(
		\ { 'candidates' : copy(neocomplete.candidates),
		\ 'complete_str' : complete_str})
	if pumvisible() && len(candidates) == 1
		return "\<C-N>"
	else
		if len(candidates) > 1
			let longestCommon = candidates[0].word
			for keyword in candidates[1:]
				while !neocomplete#head_match(keyword.word,longestCommon)
					let longestCommon = longestCommon[:-2]
				endwhile
			endfor
			if len(longestCommon) > len(complete_str)
				let longestCommon = substitute(longestCommon,complete_str, "", "")
			endif
			if longestCommon == complete_str
				let longestCommon = ""
			endif
		else
			let longestCommon = ""
		endif
	endif
	return longestCommon
endfunction
function! MinimalTab()
	if getline(".")[col('.') - 2] =~ '\w'
		call UltiSnips#ExpandSnippet()
		if g:ulti_expand_res
			return ""
		else
			return (pumvisible() ? "\<C-E>" : "") . s:CompletionCommand
		endif
	else
		return SpecialDelim("\<TAB>")
	endif
endfunction

function! FilterOmni(words, findstart, base)
	if a:findstart
		return a:words
	elseif type(a:words) == 0 && a:words < 0
		return a:words
	else
		return filter(a:words, 'match(v:val["word"], a:base)==0')
	endif
endfunction

function! GetSnippetFiletypes()
	let filetypes = []
	if &l:filetype != ''
		let filetypes += [&l:filetype]
		if &l:filetype == 'plaintex'
			let filetypes += ['tex']
		elseif &l:filetype == 'cpp'
			let filetypes += ['c']
		endif
	endif
	let filetypes += ['all']
	return filetypes
endfunction

let g:active_snippets = []
function! GetActiveSnippets()
	let g:active_snippets = []
	let filetypes = s:get_snippet_filetypes()
	let takenTriggers = []
	let suggestions = []
	for filetype in filetypes
		let command = 'cat ~/git/vim/UltiSnips/' . filetype . '.snippets | grep "^snippet"'
		let snippetList = split((exists("*vimproc#system") ? vimproc#system(command) : system(command)), "\n")
		for snippet in snippetList
			let tempList = split(snippet, '"')
			if len(tempList) > 2
				let rawDescription = split(snippet, '"')[-2]
				if rawDescription =~ ':'
					let descriptionList = split(rawDescription, ':')
					let description = descriptionList[0]
					let rawTriggers = descriptionList[1]
					if rawTriggers != '' 
						if rawTriggers =~ '|'
							let triggers = split(rawTriggers, '|')
						else
							let triggers = [rawTriggers]
						endif
						for trigger in triggers
							if index(takenTriggers,	trigger) == -1
								call add(takenTriggers, trigger)
								call add(suggestions, {
								 \ 'word' : trigger,
								 \ 'menu' : self.mark . ' ' . description . ' [' . filetype . ']'
								 \ })
							endif
						endfor
					endif
				endif
			endif
		endfor
	endfor
	return suggestions
endfunction
" --------------------
" ---- [11.1] JUMP ----
" Jumps you to the next/previous ultisnips location if exists.
" Else it jumps to the next/previous delimiter.
" Default delimiters: "'(){}[]
" To change default delimiters just change b:smartJumpElements
function! SmartJump()
	pclose
	if !g:disablePlugins
		call UltiSnips#JumpForwards()
		if g:ulti_jump_forwards_res == 1
			return ""
		endif
	endif
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[\$]"
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
	if !g:disablePlugins
		call UltiSnips#JumpBackwards()
		if g:ulti_jump_backwards_res == 1
			return ""
		endif
	endif
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[\$]"
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
function! DelimMatch(text, start, end)
let b:smartJumpElements = "[]'\"(){}<>\[]"
endfunction
" --------------------
" ---- [11.2] TEMPBUFFER ----
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
" ---- [11.3] EVALUATE MATH ----
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
" ---- [11.4] START EXTERNAL ----
function! StartEclim()
	let g:EclimdRunning = 1
	call vimproc#system_bg('eclimd')
endfunction

function! VimHelperRestart()
	call MessageVimHelper("client", "0")	
	call VimHelperStart()
endfunction
function! VimHelperStart()
	if !g:minimalMode && !g:disableExternal
		Spawn! -dir=~ python git\vim\VimHelper.py
	endif
endfunction
" --------------------
" ---- [11.5] SPELLCHECK ----
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
" ---- [11.6] GIT INFO ----
function! UpdateGitInfo()
	let b:statusLineVar = ""
	call UpdateMatches()
	call UpdateGitStatusBar()
endfunction

function! UpdateGitStatusBar()
	call MessageVimHelper("path", expand("%:p"))
endfunction

" Draws lines added/removed and edited since last commit.
let g:drawEnabled = 1
function! UpdateMatches()
	if g:drawEnabled
		call clearmatches()
		call HighlightDrawEnable()
		call AddGitMatches()
		call AddMarkMatches()
	endif
endfunction
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

function! AddGitMatches()
	" Get gitfolder.
	let currentFolder = substitute(expand('%:h'), "\\", "/", "g")
	let currentFile = expand('%:t')
	" Get info about changed lines from git, use vimproc if avaliable
	if exists("*vimproc#system")
		let gitTemp = vimproc#system("git -C " . currentFolder . " diff -U0 " . currentFile)
	else
		let gitTemp = system("git -C " . currentFolder . " diff -U0 " . currentFile)
	endif
	" lines with @@ denote information about a changed chunk
	if gitTemp =~ '@@'
		let gitList = split(gitTemp, "\n")[4:]
		for line in gitList
			if line =~ '^@@ '
				" Regexmagic to get changes.
				let al = split(substitute(substitute(line, '^[^+]*+', '', ''), ' .*', '', ''), ',')
				let rl = split(substitute(substitute(line, '^[^-]*-', '', ''), ' .*', '', ''), ',')
				let add = (len(al) > 1 ? al[1] : '1')
				let rem = (len(rl) > 1 ? rl[1] : '1')				
				if add == '0'
					let start = al[0] + 1
					if indent(start) == 0
						call matchaddpos('GitRem', [[start, 1, &l:tabstop]])
					else
						call matchaddpos('GitRem', [[start, 1]])
					endif
				else
					let start = al[0]
					let end = al[0] + add - 1
					for line in range(start, end)
						let tabpos = match(getline(line), '\t')
						if tabpos == -1 || tabpos >= 8
							call matchaddpos('Git' . (rem == 0 ? 'Add' : 'Cng'), [[line,1,&l:tabstop]])
						elseif tabpos == 0
							call matchaddpos('Git' . (rem == 0 ? 'Add' : 'Cng'), [[line,1]])
						else
							call matchaddpos('Git' . (rem == 0 ? 'Add' : 'Cng'), [[line,1,tabpos+1]])
						endif
					endfor
				endif
			endif	
		endfor
	endif
endfunction
" --------------------
" ---- [11.7] AUTODELIMITER ----
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
" ---- [11.8] HELP ----
function! FullScreenHelp(search)
	let curPath = expand('%')
	execute("h " . a:search)
	let helpPath = expand('%')
	if curPath != helpPath
		let curPos = getpos('.')
		close
		execute("e " . a:search . " [HELP]")
		execute("r " . helpPath)
		call setpos(".",curPos)
		setlocal syntax=help
		setlocal filetype=help
		setlocal buftype=nowrite
	endif
endfunction
" --------------------
" ---- [11.9] ON EXIT ----
function! OnExit()
	if !g:disableExternal && !g:disablePlugins
		call KillAllExternal()
	endif

	call MessageVimHelper("client", "-1")
endfunction

function! KillAllExternal()
	if exists("g:EclimdRunning")
		ShutdownEclim
	endif
	call OmniSharp#StopServer()
endfunction

" --------------------
" ---- [11.10] AFTER INIT ----
function! AfterInit()
	if !g:startedExternal
		call MessageVimHelper("client", "1")
	endif
endfunction
" --------------------
" ---- [11.11] MESSAGE VIMHELPER ----
function! MessageVimHelper(type, message)
if !g:disableVimHelper
python << endpy
import socket
try:
	s = socket.socket()
	s.connect(("localhost", 51351))

	s.send(vim.eval("a:type") + "\t" + vim.eval("a:message"))
except:
	if vim.eval("g:startedExternal") == "0":
	    	vim.command("call VimHelperStart()")
	vim.command("let g:startedExternal = 1")
endpy
endif
endfunction
" --------------------
" --------------------
" ---- [12] OS SPECIFIC ----
" ---- [12.0] WINDOWS ----
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" --------------------
" ---- [12.1] LINUX ----
if has('unix')
endif
" --------------------
" --------------------
" ---- [13] AFTER VIMRC ----
if !exists("g:reload")
	let g:reload = 1
endif

if exists('setup')
	autocmd VimEnter * BundleInstall
endif
" --------------------
