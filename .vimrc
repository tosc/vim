" ---- [1] VIMSETTINGS ----
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

set sessionoptions-=options
set sessionoptions+=folds

syntax on
" ---------
" ---- [2] PLUGINS ----
" ---- [2.0] VUNDLE ----
if !exists("g:reload") && !exists("g:disablePlugins")
	" Required by vundle
	filetype off
	set rtp+=~/.vim/bundle/Vundle.vim/
	call vundle#begin()
	Plugin 'gmarik/Vundle.vim'

	" Vundle addons"
	Plugin 'Shougo/neomru.vim'
	Plugin 'Shougo/unite.vim'
	Plugin 'Shougo/unite-session'
	Bundle 'Shougo/unite-build'
	Plugin 'tsukkee/unite-tag'
	Plugin 'skeept/ultisnips-unite'
	Plugin 'Shougo/neocomplcache'
	Plugin 'JazzCore/neocomplcache-ultisnips'
	Plugin 'SirVer/ultisnips'
	Plugin 'OmniSharp/omnisharp-vim'
	Plugin 'tpope/vim-dispatch'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'Rip-Rip/clang_complete'
	Plugin 'majutsushi/tagbar'
	Plugin 'xolox/vim-easytags'
	Plugin 'xolox/vim-misc'
	Plugin 'Konfekt/FastFold'
	Plugin 'Shougo/vimfiler.vim'
	Bundle 'Shougo/vimproc.vim'

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
" --------
" ---- [2.2] ECLIM ----
" Sets eclims completionmethod to omnifunc
let g:EclimCompletionMethod = 'omnifunc'
" -----
" ---- [2.3] OMNISHARP (C# OMNICOMPLETE) ---- 
let g:OmniSharp_typeLookupInPreview = 1
" Sets the sln file to the first file avaliable
let g:OmniSharp_sln_list_index = 1
" If omnisharp server is running never stop it.
let g:Omnisharp_stop_server = 0
" -------
" ---- [2.4] UNITE ----
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_update_time = 300
let g:unite_cursor_line_highlight = 'TabLine'

let s:bufferaction = {'description' : 'verbose', 'is_selectable' : 1,}

if !exists("g:disablePlugins")
	call unite#custom#default_action('buffer', 'goto')
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#filters#sorter_default#use(['sorter_rank'])
endif
" --------------------
" ---- [2.5] NEOCOMPLCACHE ----
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
" --------------------
" ---- [2.6] VIMFILER ----
let g:vimfiler_expand_jump_to_first_child = 0
" --------------------
" ---- [2.7] EASYTAGS ----
let g:easytags_updatetime_warn = 0
let g:easytags_by_filetype = '~/.vim/tags/'
" --------------------
" ---- [2.8] FASTFOLD ----
let g:fastfold_savehook = 1
let g:fastfold_togglehook = 0
let g:fastfold_map = 1
" --------------------
" --------------------
" ---- [3] BINDINGS ----
" ---- [3.0] NORMAL ----
" Show the my normal and insert bindings.
noremap g? :enew <bar> r ~/git/vim/.vimrc <bar> set buftype=help <bar> set filetype=help<CR> /\[3.0\]<CR> :0,.-1d<CR>/\[3.2\]<CR> :.,$d<CR>gg 

" Do last recording. (Removes exmode which I never use.)
noremap Q @@

"Not vi-compatible but more logical. Y yanks to end of line.
noremap Y y$

" Close everything except current fold.
noremap zV zMzv

" perform math on cursor
noremap � viw"xc<C-R>=getreg('x')

if !exists("g:disablePlugins")
	" Search file using unite.
	noremap � :Unite -no-split line -auto-preview -no-resize -custom-line-enable-highlight<CR>

	" Open files using unite. Shows all current buffers and a history of latest files.
	noremap � :Unite -no-split buffer file_mru<CR>

	" Filebrowser.
	noremap � :VimFiler<CR>
else
	noremap � /
	noremap � :e 
	noremap � :e 
endif

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter. 
noremap <S-Space> :call SmartJump()<CR>
noremap <S-BS> :call SmartJumpBack()<CR>

"Switches repeat f/F, feels more logical on swedish keyboard.
noremap , ;
noremap ; ,

" I've always found $ hard to hit, � easier with swedish layout.
noremap � $

" Jump to tag. C-T to jump back.
noremap <C-J> <C-]>


" Good avaliable binds
" �
" Enter
" Backspace
" Shift enter
" �
" �
" H (doesn't do anything since cursor always in middle for me)
" M (doesn't do anything since cursor always in middle for me)
" L (doesn't do anything since cursor always in middle for me)
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

" Autocomplete line.
inoremap <C-L> <C-X><C-L>

if !exists("g:disablePlugins")
	" Run my tabcompletion.
	inoremap <TAB> <C-R>=NeoTab()<CR>
	" Force manual completion.
	inoremap <expr><C-M>  neocomplcache#start_manual_complete()
else
	" Simple tabcompletion.
	inoremap <expr><TAB> getline('.') =~ '\S' ? '<C-X><C-N>' : '<TAB>'
	inoremap <C-M> <C-X><C-N>
endif

" Pressing enter chooses completion if completion window is up, else normal enter.
inoremap <expr> <CR> pumvisible() ? '<C-e><CR>' : '<CR>'

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter. 
inoremap <S-Space> <C-R>=SmartJump()<CR>
inoremap <S-BS> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <end>
inoremap <C-K> <C-O>D

" Matching delimiters
function! BindDelim(kMap)
	execute 'inoremap ' . a:kMap . ' ' . a:kMap . '<left>' 
	execute 'inoremap ' . a:kMap . '<CR> ' . a:kMap . '<CR>' 
	execute 'inoremap ' . a:kMap . '<Space> ' . a:kMap . '<Space>' 
endfunction
call BindDelim('""')
call BindDelim('()')
call BindDelim('{}')
call BindDelim("''")
call BindDelim('[]')
call BindDelim('<>')
inoremap {{ {<cr><cr>}<up><TAB>
" --------------------
" ---- [3.2] LEADER ----
let mapleader="\<space>"

" A
" B
" C
map <leader>c :cd %:h<CR>
" D
map <leader>d :b #<bar>bd #<CR>
" E
" F
" G
if !exists("g:disablePlugins")
	map <leader>gg :Gstatus<CR>
	map <leader>gc :Gcommit<CR>
	map <leader>gp :Git push<CR> :call SlowStatusLine()<CR>
	map <leader>gP :Git push --force<CR> :call SlowStatusLine()<CR>
	map <leader>gd :Gdiff<CR>
else
	map <leader>gg :!git -C %:h status<CR>
	map <leader>gc :!git -C %:h commit<CR>
	map <leader>gp :!git -C %:h push<CR> :call SlowStatusLine()<CR>
	map <leader>gP :!git -C %:h push --force<CR> :call SlowStatusLine()<CR>
	map <leader>gd :!git -C %:h diff<CR>
endif

map <leader>g? :enew <bar> r ~/git/vim/.vimrc <bar> set buftype=help <bar> set filetype=help<CR> /\[3.2\]<CR> :0,.+2d<CR>/\[3.3\]<CR> :.-1,$d<CR>gg 
" H
" I
" J
" K
" L
" I
" M
if !exists("g:disablePlugins")
	map <leader>m :cd %:h<CR>:Unite -no-split -auto-preview -no-start-insert build:make<CR>
else
	map <leader>m :!make<CR>
endif
" N 
map <leader>n :bn <CR>
" O
" P 
map <leader>p :bp <CR>
" Q
map <leader>q :call QFix()<CR>
" R 
autocmd Filetype python map <buffer><silent> <leader>r :w <bar> ! python % <cr>
autocmd Filetype c map <buffer><silent> <leader>r :w <bar> !./%:r <cr>
autocmd Filetype cpp map <buffer><silent> <leader>r :w <bar> ! main <cr>
autocmd Filetype cs map <buffer><silent> <leader>r :w <bar> ! main <cr>
" S
map <leader>se :setlocal spell spelllang=en_us <CR>
map <leader>ss :setlocal spell spelllang=sv <CR>
map <leader>so :setlocal nospell <CR>
map <leader>sn :setlocal nospell <CR>
map <leader>sc :setlocal nospell <CR>
map <leader>sd :setlocal nospell <CR>
if !exists("g:disablePlugins")
	map <leader>S :Unite -no-split ultisnips <CR>
endif
" T
if !exists("g:disablePlugins")
	map <leader>t :TagbarToggle <CR>
endif
" U
if !exists("g:disablePlugins")
	map <leader>ue :UltiSnipsEdit <CR>
	map <leader>uu :Unite -no-split file:~/vimfiles/Ultisnips <CR>
	map <leader>us :Unite -no-split ultisnips <CR>
	map <leader>ur :Unite -no-split register<CR>
	map <leader>ut :Unite -no-split tag<CR>
endif
" V
map <leader>v :e ~/git/vim/.vimrc<CR>
" W
" X
" Y
" Z
if !exists("g:disablePlugins")
	map <leader>z :Unite -no-split session<CR>
endif
" !
" ?
" -
" /
" --------------------
" ---- [3.3] VISUAL ----
" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter. 
snoremap <S-Space> <ESC>:call SmartJump()<CR>
snoremap <S-BS> <ESC>:call SmartJumpBack()<CR>

if !exists("g:disablePlugins")
	" When you press TAB and have something selected in visual mode, it saves it for
	" ultisnips and then removes it.
	xnoremap <silent><TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
endif

if !exists("g:disablePlugins")
	" Remapped s to vim-surround.
	xmap s S
endif
" --------------------
" ---- [3.4] COMMAND ----
cnoremap <C-BS> <C-W>

" Readline bindings.
cnoremap <C-A> <home>
cnoremap <C-E> <end>
cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" Open help in current window.
cnoreabbrev h enew <bar> :set buftype=help <bar> :h

if !exists("g:disablePlugins")
	" I tend to write :git instead of :Git
	cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "Git" : "git"
else
	cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "!git" : "git"
	cnoreabbrev <expr> Git getcmdtype() == ":" && getcmdline() == "Git" ? "!git" : "Git"
endif
" --------------------
" ---- [3.5] UNITE ----
function! UniteBinds()
	nmap <buffer> <S-Space> <Plug>(unite_redraw)
	nmap <buffer> <ESC> <Plug>(unite_all_exit)
	nnoremap <buffer> <BS> <Plug>()
	nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	nnoremap <silent><buffer><expr> <C-t> unite#do_action('tab')
	nnoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	nnoremap <silent><buffer><expr> <C-c> unite#do_action('cd')
	imap <buffer> <TAB> <Plug>(unite_select_next_line)
	imap <buffer> <S-TAB> <Plug>(unite_select_previous_line)
	inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
	inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	inoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	inoremap <silent><buffer><expr> <C-c> unite#do_action('cd') |
endfunction
autocmd FileType unite call UniteBinds()
" --------------------
" ---- [3.6] VIMFILER ----
function! VimFilerBinds()
	nmap <buffer> za t
	nmap <buffer> <ESC> <Plug>(vimfiler_exit)
endfunction
autocmd FileType vimfiler call VimFilerBinds()
" --------------------
" ---- [3.7] FUGITIVE ----
function! FugitiveBindings()
	" Fast movement for :GStatus
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
endfunction
" --------------------
" ---- [3.8] HELP ----
function! HelpBinds()
	nmap <buffer> <ESC> :b #<bar>bd! #<CR>
endfunction
autocmd FileType help call HelpBinds()
" --------------------
" --------------------
" ---- [4] FILETYPE SPECIFIC ----
" ---- [4.0] All ----
" :set filetype? To know current loaded filetype
" for specific startfolding - let &foldlevel=nr
" --------
" ---- [4.1] JAVA ----
function! JavaSettings()
	setlocal omnifunc=JavaOmni
	setlocal foldexpr=OneIndentBraceFolding(v:lnum)
	setlocal foldtext=SpecialBraceFoldText()
	if !exists("g:disablePlugins")
		let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
		let g:neocomplcache_omni_patterns.java = '.*'
	endif
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
	if !exists("g:disablePlugins")
		let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
		let g:neocomplcache_omni_patterns.cs = '.*'
	endif
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
	let words = UltiSnips#SnippetsInCurrentScope()
	return FilterOmni(words, a:findstart, a:base)
endfunction

autocmd Filetype c,cpp call CSettings()
" --------------------
" ---- [4.4] VIMRC ----
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
" ---- [4.5] SNIPPET ----
function! SNIPPETSSettings()
	setlocal foldexpr=SnippetFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd Filetype snippets call SNIPPETSSettings()
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
	setlocal omnifunc=PythonOmni
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	if !exists("g:disablePlugins")
		let g:neocomplcache_omni_patterns.python = '.*'
		let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
	endif
endfunction

function! PythonOmni(findstart, base)
	let words = eclim#python#complete#CodeComplete(a:findstart, a:base)
	return FilterOmni(words, a:findstart, a:base)
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
	setlocal spell spelllang=en_us
	if !exists("g:minimalMode") && !exists("g:disableExternal")
		call StartTexBuilder()
	endif
	
endfunction

if !exists("g:minimalMode") && !exists("g:disableExternal")
	autocmd TextChanged,TextChangedI *.tex write
else
	" Compile latex to a pdf when you save
	autocmd BufWritePre *.tex call vimproc#system("rm -f " . expand('%:r') . ".aux")
	autocmd BufWritePost *.tex call vimproc#system("pdflatex -halt-on-error -output-directory=" . expand('%:h') . " " . expand('%'))
endif

function! StartTexBuilder()
	cd ~\git\vim
	Start python texbuilder.py %:h %
	cd %:h
endfunction

autocmd Filetype tex call TEXSettings()
" --------------------
" ---- [4.13] GITCOMMIT ----
function! GITCSettings()
	" Don't fold gitstuff.
	let &foldlevel = 99
	call FugitiveBindings()
endfunction

autocmd FileType gitcommit call GITCSettings()
" --------------------
" ---- [4.14] MARKDOWN ----
function! MDSettings()
	setlocal foldexpr=MDFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
endfunction

autocmd FileType markdown call MDSettings()
" --------------------
" --------------------
" ---- [5] FOLDING ----
" ---- [5.0] FOLDSETTINGS ----
set foldmethod=expr
set foldnestmax=2
set foldopen=
set foldlevelstart=0
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
	let lastline = getline(a:lnum-1)
	if lnum == 1
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
					return '1'
					let g:InsideVar = 1
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
					return '1'
					let g:InsideVar = 1
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
	if line =~ '^\" ---- '
		return 'a1'
	elseif line =~ '^\" -----'
		return 's1'
	else
		return '='
	endif
endfunction
" --------------------
" ---- [5.1.4] SNIPPETS ----
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
	elseif indent(a:lnum)/8 < indent(a:lnum-1)/8 && (line =~ '^\s*\\end' || line =~ '^\s*\\]')
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
	let indent = repeat(' ', indent_level)
	if line =~ 'import'
	       let line = "import"	
	endif
	return indent . line
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
set statusline=%<\[%f\]\ %{MyStatusLine()}\ %y\ %m%=%-14.(%l-%c%)\ %P

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	if !exists("b:statusLineVar")
		call SlowStatusLine()
	endif
	return b:statusLineVar
endfunction

" Updates gitinfo for the statusline. 
" m - Nr of [m]odified [f]iles.
" +/- - Nr of rows added / deleted.
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
" ---- [7] TABLINE ----
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
" ---- [8] MINIMALMODE ----
if exists("g:minimalMode")
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
endif
" --------------------
" ---- [9] COLORSETTINGS ----
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
" ---- [10] AUTOCMD ----
autocmd BufWritePost * call SaveSession() | call SlowStatusLine()
autocmd BufEnter * call SlowStatusLine() 

autocmd InsertEnter * hi StatusLine gui=reverse
autocmd InsertLeave * hi StatusLine guibg=NONE gui=underline

" To make FastFold calculate the folds when you open a file.
autocmd BufReadPost * let &foldlevel=0

function! KillAllExternal()
	if exists("g:EclimdRunning")
		ShutdownEclim
	endif
	call OmniSharp#StopServer()
endfunction
if !exists("g:disableExternal")
	autocmd VimLeave * call KillAllExternal()
endif
" --------------------
" ---- [11] FUNCTIONS ----
" ---- [11.0] TABCOMPLETION ----
function! NeoTab()
	if getline('.') =~ '\S'
		call UltiSnips#ExpandSnippet()
		if g:ulti_expand_res == 1
			return ""
		endif
		let longestCommon = neocomplcache#complete_common_string()
		if longestCommon == ""
			return pumvisible() ? "" : "\<TAB>"
		endif
		return longestCommon
	endif
	return "\<TAB>"
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
" --------------------
" ---- [11.1] SESSION ----
function! SaveSession()
	let sessionName = getcwd()
	let sessionName = substitute(sessionName, "\\", "-", "g")
	let sessionName = substitute(sessionName, ":", "-", "g")
	let sessionName = substitute(sessionName, "/", "-", "g")
	let sessionName = "~/.cache/unite/session/" . sessionName . ".vim"
	exe "mksession! " . sessionName
endfunction
" --------------------
" ---- [11.2] QUICKFIX TOGGLE ----
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
" ---- [11.3] JUMP ----
" Jumps you to the next/previous ultisnips location if exists.
" Else it jumps to the next/previous delimiter.
" Default delimiters: "'(){}[]
" To change default delimiters just change b:smartJumpElements
function! SmartJump()
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[]"
	endif
	if !exists("g:disablePlugins")
		call UltiSnips#JumpForwards()
		if g:ulti_jump_forwards_res == 1
			return ""
		endif
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
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[]"
	endif
	if !exists("g:disablePlugins")
		call UltiSnips#JumpBackwards()
		if g:ulti_jump_backwards_res == 1
			return ""
		endif
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
" --------------------
" ---- [12] OS SPECIFIC ----
" ---- [12.0] Windows ----
if(has("win32"))
	au GUIEnter * simalt ~x
endif
" --------------------
" ---- [12.1] Linux ----
" --------------------
" --------------------
" ---- [13] AFTER VIMRC ----
if !exists("g:reload")
	let g:reload = 1
endif

if !exists("g:EclimdRunning") && !exists("g:disableExternal")
	let g:EclimdRunning = 1
	call vimproc#system_bg('eclimd')
endif
" --------------------
