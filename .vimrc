" ---- [0] FRESH INSTALL ----
if !isdirectory(expand('~') . "/.vim/tmp")
" If that folder doesn't exists then this is the first time running vim
	call mkdir(expand('~') . "/.vim/tmp")
	call mkdir(expand('~') . "/.vim/tags")
	call mkdir(expand('~') . "/.cache/unite/session")

	let g:disablePlugins = 1
	let g:disableExternal = 1
endif
" --------------------
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

" Shows whitespaces and tabs when using list.
set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ 
set list

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

	" Unite and unite plugins.
	Plugin 'Shougo/neomru.vim'
	Plugin 'Shougo/unite.vim'
	Plugin 'Shougo/unite-session'
	Plugin 'Shougo/unite-build'
	Plugin 'tsukkee/unite-tag'

	" Snippets
	Plugin 'SirVer/ultisnips'

	" Code-completion
if has('lua') && !exists('g:minimalMode')
	Plugin 'Shougo/neocomplete.vim'
	Plugin 'tosc/neocomplete-spell'
	Plugin 'tosc/neocomplete-ultisnips'
else
	Plugin 'Shougo/neocomplcache'
	Plugin 'JazzCore/neocomplcache-ultisnips'
endif
	" Omnicomplete engines.
	Plugin 'davidhalter/jedi-vim'
	Plugin 'Rip-Rip/clang_complete'
	Plugin 'OmniSharp/omnisharp-vim'

	" Async external commands
	Plugin 'tpope/vim-dispatch'
	Plugin 'Shougo/vimproc.vim'

	" Syntax checker and syntax engines.
	Plugin 'scrooloose/syntastic'
	Plugin 'syngan/vim-vimlint'
	Plugin 'ynkdir/vim-vimlparser'

	" Div
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'Konfekt/FastFold'
	Plugin 'majutsushi/tagbar'
	Plugin 'xolox/vim-easytags'
	Plugin 'xolox/vim-misc'

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
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_update_time = 300
let g:unite_cursor_line_highlight = 'TabLine'

let s:bufferaction = {'description' : 'verbose', 'is_selectable' : 1,}

let g:unite_path = ''
if !exists("g:disablePlugins")
	call unite#custom#default_action('buffer', 'goto')
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#filters#sorter_default#use(['sorter_rank'])

	let custom_open = {
	      \ 'description' : 'open files or open directory',
	      \ 'is_quit' : 0,
	      \ 'is_start' : 1,
	      \ }
	" Open a directory.
	function! custom_open.func(candidate)
		if a:candidate.word =~ '\.\.$' 
			if g:unite_path =~ '^[A-Z]:$'
				let g:unite_path = ''
			else

				let folders = split(g:unite_path, '/')
				let folders = folders[:-2]
				let newpath = (has('unix') ? '/' : '') . join(folders, '/')
				let g:unite_path = newpath
			endif
		else
			let folders = split(a:candidate.word, '/')
			let g:unite_path .= (a:candidate.word =~ '^[A-Z]:$' && has('win32') ? '' : '/') . folders[-1]
		endif

		call unite#start_temporary([['directory'], ['file'], ['file/new'], ['directory/new']],
		\ {'path' : g:unite_path, 'prompt' : g:unite_path . '>'})
	endfunction
	call unite#custom#action('directory', 'custom-open', custom_open)
	call unite#custom#default_action('directory', 'custom-open')

	let dir_matcher = {
	      \ 'name' : 'dir_matcher',
	      \ 'description' : 'matches dirs',
	      \}
	" Highlight as you type
	function! dir_matcher.pattern(input)
		let filter = unite#get_filters('matcher_fuzzy')
		return filter.pattern(a:input)
	endfunction
	" Filter directories.
	function! dir_matcher.filter(candidates, context)
		let folders = a:candidates
		if has('win32')
			" Add ../ as an option if you are in the root of a drive.
			if g:unite_path =~ '^[A-Z]:$'
				call add(folders, {'word' : '..', 'abbr' : '../', 'action__path' : ''})
			" If you are in the root of computer add drives as options.
			elseif g:unite_path == '' 
				let folders = []
				let abc = "A B C D E F G H I J K L M N O P Q R S T U V X Y Z"
				let drives = split(abc, '\s')
				for drive in drives
					if isdirectory(drive . ':')
						call add(folders, {'word' : drive . ':', 'abbr' : drive . ':/', 'action__path' : drive . ':'})
					endif
				endfor
			endif
		endif
		" Show only the folder and not absolute path to folder.
		for candidate in folders
			let splitWord = split(candidate.word, '/')
			let folder = splitWord[-1]
			let candidate.abbr = folder
		endfor
		" Filter directories using fuzzy matcher.
		let filter = unite#get_filters('matcher_fuzzy')
		if !empty(filter)
			let candidates = filter.filter(folders, a:context)
		endif
		return candidates
	endfunction
	call unite#define_filter(dir_matcher)
	call unite#custom#source('directory', 'matchers', ['dir_matcher'])

	let file_matcher = {
	      \ 'name' : 'file_matcher',
	      \ 'description' : 'matches files only',
	      \}
	" Highlight as you type
	function! file_matcher.pattern(input)
		let filter = unite#get_filters('matcher_fuzzy')
		return filter.pattern(a:input)
	endfunction
	" Filter files
	function! file_matcher.filter(candidates, context)
		let files = []
		let lines = []
		" ls to get files
		if g:unite_path != ''
			let lsoutput = system('ls -a ' . g:unite_path)
			let lines = split(lsoutput, '\n')
		endif
		" Add all non-directories as a file
		for candidate in lines
			let path = g:unite_path . '/' . candidate
			if !isdirectory(path)
				let splitWord = split(candidate, '/')
				let file = splitWord[-1]
				call add(files, {'word' : path . " ", 'action__path' : path, 'abbr' : path})
			endif
		endfor
		" Filer files using fuzzy mather.
		let filter = unite#get_filters('matcher_fuzzy')
		if !empty(filter)
			let candidates = filter.filter(files, a:context)
		endif
		return candidates
	endfunction
	call unite#define_filter(file_matcher)
	call unite#custom#source('file', 'matchers', ['file_matcher'])


	let g:teet = {}
	let custom_edit = {
	      \ 'description' : 'open files or open directory',
	      \ 'is_quit' : 0,
	      \ 'is_start' : 1,
	      \ }
	" Open a directory.
	function! custom_edit.func(candidate)
		let filepath = a:candidate.action__path
		execute 'e' . filepath
	endfunction
	call unite#custom#action('file', 'custom-edit', custom_edit)
	call unite#custom#default_action('file', 'custom-edit')
endif


function! UniteExplorer()
	" Needed for file and directory filtering.
	let g:unite_path = substitute(getcwd(), '\', '/', 'g')

	execute "Unite -no-split -no-resize -prompt=" . g:unite_path . "> -path=" . g:unite_path . " directory file file/new directory/new"
endfunction
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
" ---- [2.6] EASYTAGS ----
let g:easytags_updatetime_warn = 0
let g:easytags_by_filetype = '~/.vim/tags/'
" --------------------
" ---- [2.7] FASTFOLD ----
let g:fastfold_savehook = 1
let g:fastfold_togglehook = 0
let g:fastfold_map = 1
" --------------------
" ---- [2.8] NEOCOMPLETE ----
let g:neocomplete#enable_at_startup = 1

if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.cs = '.*'
let g:neocomplete#sources#omni#input_patterns.java = '.*'

if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^.\t]\.\w*'
let g:neocomplete#force_omni_input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.objc =
	\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp =
	\ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

let g:neocomplete#enable_smart_case = 0
let g:neocomplete#enable_camel_case_completion = 0
let g:neocomplete#enable_ignore_case = 0
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_auto_close_preview = 0
let g:neocomplete#enable_fuzzy_completion = 0

let g:clang_complete_auto = 0
let g:clang_auto_select = 0
" --------------------
" ---- [2.9] JEDI ----
"let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#popup_select_first = 0
let g:jedi#usages_command = "<NOP>"
let g:jedi#rename_command = "<NOP>"
let g:jedi#documentation_command = "<NOP>"
let g:jedi#goto_definitions_command = "<NOP>"
let g:jedi#goto_assignments_command = "<NOP>"
" --------------------
" ---- [2.10] SYNTASTIC ----
let g:syntastic_mode_map = { "mode": "active",
			   \ "active_filetypes": [],
			   \ "passive_filetypes": ["vim"] }
let g:syntastic_auto_loc_list = 1
" --------------------
" --------------------
" ---- [3] BINDINGS ----
" ---- [3.0] NORMAL ----
" Show the my normal and insert bindings.
noremap g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <bar> /\[3.0\]<CR> :0,.-1d<CR>/\[3.2\]<CR> :.,$d<CR>gg

" Do last recording. (Removes exmode which I never use.)
noremap Q @@

"Not vi-compatible but more logical. Y yanks to end of line.
noremap Y y$

" Close everything except current fold.
noremap zV zMzv

if !exists("g:disablePlugins")
	" Search file using unite.
	noremap ä :Unite -no-split line -auto-preview -no-resize -custom-line-enable-highlight<CR>

	" Open files using unite. Shows all current buffers and a history of latest files.
	noremap ö :Unite -no-split -no-resize buffer file_mru<CR>

	" Filebrowser.
	noremap Ö :call UniteExplorer()<CR>
else
	noremap ä /
	noremap ö :e
	noremap Ö :e
endif

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter.
noremap <S-Space> :call SmartJump()<CR>
noremap <S-BS> :call SmartJumpBack()<CR>

"Switches repeat f/F, feels more logical on swedish keyboard.
noremap , ;
noremap ; ,

" I've always found $ hard to hit, § easier with swedish layout.
noremap § $

" Jump to tag. C-T to jump back.
noremap <C-J> <C-]>

" Good avaliable binds
" ´
" Enter
" Backspace
" Shift enter
" Ä
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
inoremap <pageup> <C-R>=SmartJump()<CR>
inoremap <pagedown> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <end>
inoremap <C-K> <C-O>D

" Easier delimiters.
inoremap {{ {<cr><cr>}<up><TAB>

" Matching delimiters
function! BindDelim(kMap)
	execute 'inoremap ' . a:kMap . ' ' . a:kMap . '<left>'
	execute 'inoremap ' . a:kMap . '<CR> ' . a:kMap . '<CR>'
	execute 'inoremap ' . a:kMap . '<Space> ' . a:kMap . '<Space>'
	execute 'inoremap ' . a:kMap . '<left> ' . a:kMap . '<left>'
	execute 'inoremap ' . a:kMap . '<bs> ' . a:kMap . '<bs>'
	execute 'inoremap ' . a:kMap . '. ' . a:kMap . '.'

	execute 'cnoremap ' . a:kMap . ' ' . a:kMap . '<left>'
	execute 'cnoremap ' . a:kMap . '<CR> ' . a:kMap . '<CR>'
	execute 'cnoremap ' . a:kMap . '<Space> ' . a:kMap . '<Space>'
	execute 'cnoremap ' . a:kMap . '<left> ' . a:kMap . '<left>'
	execute 'cnoremap ' . a:kMap . '<bs> ' . a:kMap . '<bs>'
	execute 'cnoremap ' . a:kMap . '. ' . a:kMap . '.'
endfunction
call BindDelim('""')
call BindDelim('()')
call BindDelim('{}')
call BindDelim("''")
call BindDelim('[]')
call BindDelim('<>')
" --------------------
" ---- [3.2] LEADER ----
let g:mapleader="\<space>"

" A
" B
map <leader>b :b #<CR>
" C
map <leader>co :Errors<CR>
map <leader>cc :SyntasticCheck<CR>
map <leader>ce :SyntasticCheck<CR>
" D
map <leader>d :bd<CR>
map <leader>D :bd!<CR>
" E
autocmd Filetype tex map <buffer><leader>e :call StartTexBuilder() <cr>
" F
" G
map <leader>gg :!git -C %:h status<CR>
map <leader>gc :!git -C %:h commit<CR>
map <leader>gp :!git -C %:h push<CR> :call SlowStatusLine()<CR>
map <leader>gP :!git -C %:h push --force<CR> :call SlowStatusLine()<CR>
map <leader>gd :!git -C %:h diff<CR>
map <leader>gD :!git -C %:h diff<CR>
map <leader>gf :!git -C %:h fetch<CR> :call SlowStatusLine()<CR>
map <leader>gF :!git -C %:h pull<CR> :call SlowStatusLine()<CR>
" Opens a interactive menu that lets you pick what commits to use/squash.
map <leader>gr :!git -C %:h rebase -i HEAD~
map <leader>g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <bar> /\[3.2\]<CR> :0,.+2d<CR>/\[3.3\]<CR> :.-1,$d<CR>gg

if !exists("g:disablePlugins")
	map <leader>gg :Gstatus<CR>
	map <leader>gc :Gcommit<CR>
	map <leader>gd :Gdiff<CR>
endif
" H
" I
" J
" K
" L
" I
" M
map <leader>m :!make<CR>
if !exists("g:disablePlugins")
	map <leader>m :cd %:h<CR>:Unite -no-split -auto-preview -no-start-insert -no-resize build:make<CR>
endif
" N
map <leader>n :bn <CR>
" O
map <leader>o :Unite -no-split -no-resize buffer file_mru<CR>
map <leader>O :call UniteExplorer()<CR>
" P
map <leader>p :bp <CR>
" Q
map <leader>q :call QFix()<CR>
" R
autocmd Filetype python map <buffer><silent> <leader>r :w <bar> ! python % <cr>
autocmd Filetype c map <buffer><silent> <leader>r :w <bar> !./%:r <cr>
autocmd Filetype cpp map <buffer><silent> <leader>r :w <bar> ! main <cr>
autocmd Filetype cs map <buffer><silent> <leader>r :w <bar> ! main <cr>
autocmd Filetype vim map <leader>r :so % <cr>
" S
map <leader>se :call EnglishSpellCheck() <CR>
map <leader>ss :call SwedishSpellCheck() <CR>
map <leader>so :call NoSpellCheck() <CR>
map <leader>sc :call NoSpellCheck() <CR>
map <leader>sd :call NoSpellCheck() <CR>
if !exists("g:disablePlugins")
	map <leader>S :Unite -no-split ultisnips <CR>
endif
" T
map <leader>te :set expandtab <CR>
map <leader>tt :set noexpandtab <CR>
map <leader>t4 :set tabstop=4 <CR> :set shiftwidth=4 <CR>
map <leader>t8 :set tabstop=8 <CR> :set shiftwidth=8 <CR>
map <leader>ts :set listchars=tab:>\ ,trail:#,extends:>,precedes:<,nbsp:+ <CR>
map <leader>th :set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ <CR>
map <leader>tc :tabclose <CR>
map <leader>tn :tabnew <CR>
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
map <leader>w :w <CR>
" X
" Y
" Z
if !exists("g:disablePlugins")
	map <leader>z :Unite -no-split session<CR>
endif
" --------------------
" ---- [3.3] VISUAL ----
xnoremap å c<C-R>=PythonMath()<CR>

" Jump to next(previous) ultisnips location if one exists, else jump to next(previous) delimiter.
snoremap <S-Space> <ESC>:call SmartJump()<CR>
snoremap <S-BS> <ESC>:call SmartJumpBack()<CR>
snoremap <pageup> <ESC>:call SmartJump()<CR>
snoremap <pagedown> <ESC>:call SmartJumpBack()<CR>

if !exists("g:disablePlugins")
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

cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == "h" ? 'call FullScreenHelp(" ")<left><left><left>' : "h"
cnoreabbrev <expr> tn getcmdtype() == ":" && getcmdline() == "tn" ? 'tabnew' : "tn"
cnoreabbrev <expr> tc getcmdtype() == ":" && getcmdline() == "tc" ? 'tabc' : "tc"

if !exists("g:disablePlugins")
	" I tend to write :git instead of :Git
	cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "Git" : "git"
else
	cnoreabbrev <expr> git getcmdtype() == ":" && getcmdline() == "git" ? "!git" : "git"
	cnoreabbrev <expr> Git getcmdtype() == ":" && getcmdline() == "Git" ? "!git" : "Git"
endif

" See insert for delimiterbindings.
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
" ---- [3.6] FUGITIVE ----
function! FugitiveBindings()
	" Fast movement for :GStatus
	nmap <buffer> j <C-N>
	nmap <buffer> k <C-P>
endfunction
" --------------------
" ---- [3.7] OPOHBUFFER ----
function! OpohBinds()
	nmap <buffer> <ESC> :execute("b " . g:bufferBeforeOpoh)<CR>
endfunction
autocmd FileType opoh call OpohBinds()
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
		if !has('lua')
			let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
			let g:neocomplcache_omni_patterns.java = '.*'
		endif
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
		if !has('lua')
			let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
			let g:neocomplcache_omni_patterns.cs = '.*'
		endif
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
	setlocal omnifunc=PythonOmni
	setlocal foldexpr=PythonFolding(v:lnum)
	setlocal foldtext=NormalFoldText()
	if !exists("g:disablePlugins")
		if !has('lua')
			let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
			let g:neocomplcache_omni_patterns.python = '.*'
		endif
	endif
endfunction

function! PythonOmni(findstart, base)
	call jedi#complete_string(0)
	let words = jedi#completions(a:findstart, a:base)
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

if !exists("g:minimalMode") && !exists("g:disableExternal")
	autocmd TextChanged,TextChangedI *.tex silent! call SaveIfPossible()
else
	" Compile latex to a pdf when you save
	autocmd BufWritePre *.tex call vimproc#system("rm -f " . expand('%:r') . ".aux")
	autocmd BufWritePost *.tex call vimproc#system("pdflatex -halt-on-error -output-directory=" . expand('%:h') . " " . expand('%'))
endif

autocmd Filetype tex call TEXSettings()

function! SaveIfPossible()
	write
endfunction
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
	if a:lnum == 1
		let g:InsideBrace = 0
	endif
	let line = getline(a:lnum)
	if line =~ '^# ' && !g:InsideBrace
		return '>1'
	elseif line =~ '^snippet'
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
	if line =~ '^snippet'
		let indent_level = &l:tabstop
	endif
	let indent = repeat(' ', indent_level)
	if line =~ '^import'
	       let line = "import"	
	endif
	let endText = v:foldend - v:foldstart
	return indent . line . repeat(" ", winwidth(0)-strlen(indent . line . endText) - 5) . endText . " "
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
if !exists("g:disablePlugins")
	set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
endif

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	if !exists("b:statusLineVar")
		call SlowStatusLine()
	endif
	if !exists("g:disablePlugins") && SyntasticStatuslineFlag() == ""
		hi StatusLine guibg=NONE
	else
		hi StatusLine guibg=red
	endif

	return b:statusLineVar
endfunction

" Updates gitinfo for the statusline.
" m - Nr of [m]odified [f]iles.
" +/- - Nr of rows added / deleted.
function! SlowStatusLine()
	call DrawGit()
	let SlowStatusLineVar = ""
	if &modifiable
		let currentFolder = substitute(expand('%:h'), "\\", "/", "g")
		if exists("*vimproc#system")
			let gitTemp = vimproc#system("git -C " . currentFolder . " status -b -s")
			let rowsTemp = split(vimproc#system("git -C " . currentFolder . " diff --numstat"), "\n")
		else
			let rowsTemp = split(system("git -C " . currentFolder . " diff --numstat"), "\n")
			let gitTemp = system("git -C " . currentFolder . " status -b -s")
		endif
		if gitTemp !~ "fatal"
		let gitTemp = substitute(gitTemp[2:], "\\.\\.\\.", '->', '')
			let gitList = split(gitTemp, "\n")
			if len(gitList) > 0
				let SlowStatusLineVar .= "[" . substitute(gitList[0], " ", "", "g") . "]"
			endif
			if len(gitList) > 1
				let SlowStatusLineVar .= " [m " . (len(gitList) -1) . "]"
			endif
			let changedRows = []
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
		let bufname = ''
		for buf in tabpagebuflist(tab)
			let bufname .= (bufname != '' ? ' | ' : '')
			let bufname .= fnamemodify(bufname(buf), ':t') . (getbufvar(buf, "&mod") ? "[+]" : "")
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
if exists("g:minimalMode")
	let s:CompletionCommand = "\<C-X>\<C-U>"
	let g:neocomplcache_disable_auto_complete = 1
	inoremap <TAB> <C-R>=MinimalTab()<CR>
	let g:syntastic_mode_map = { "mode": "passive",
				   \ "active_filetypes": [],
				   \ "passive_filetypes": [] }
endif
" --------------------
" ---- [9] COLORSETTINGS ----
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
hi SpellBad ctermbg=NONE cterm=underline ctermfg=NONE
hi SpellCap ctermbg=NONE cterm=underline ctermfg=NONE
hi SpellLocal ctermbg=NONE cterm=underline ctermfg=NONE
hi SpellRare ctermbg=NONE cterm=underline ctermfg=NONE
hi Comment ctermfg=123 cterm=bold
hi TabLineFill cterm=underline gui=underline guibg=grey30 ctermbg=239
hi TabLine cterm=underline gui=underline guibg=grey30 ctermbg=239 ctermfg=NONE
hi TabLineSel cterm=none gui=none ctermbg=NONE
hi MoreMsg cterm=bold ctermfg=41
hi ModeMsg cterm=bold
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

hi GitAdd guibg=#002211 guifg=green ctermbg=22 ctermfg=10
hi GitRem guibg=#660000 guifg=red ctermbg=52 ctermfg=211
hi GitCng guibg=#000066 guifg=#00DDFF ctermbg=17 ctermfg=51

autocmd InsertEnter * hi StatusLine gui=reverse cterm=reverse
autocmd InsertLeave * hi StatusLine guibg=NONE gui=underline cterm=underline
" --------------------
" ---- [10] AUTOCMD ----
autocmd BufWritePost * call SaveSession()
autocmd BufWritePost * call SlowStatusLine()

autocmd BufEnter * call SlowStatusLine()

" To make FastFold calculate the folds when you open a file.
autocmd BufReadPost * let &foldlevel=0

autocmd TextChanged,TextChangedI * call clearmatches()

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
		if has('lua')
			let longestCommon = NeoLongestCommon()
		else
			let longestCommon = neocomplcache#complete_common_string()
		endif
		if longestCommon == ""
			return pumvisible() ? "" : "\<TAB>"
		endif
		return longestCommon
	endif
	return "\<TAB>"
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
	if getline(".")[col('.') - 2] =~ '\S'
		call UltiSnips#ExpandSnippet()
		if g:ulti_expand_res
			return ""
		else
			return (pumvisible() ? "\<C-E>" : "") . s:CompletionCommand
		endif
	else
		return "\<TAB>"
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
" --------------------
" ---- [11.1] SESSION ----
function! SaveSession()
	let sessionName = substitute(getcwd(), "[\\:/]", "-", "g")
	exe "mksession! ~/.cache/unite/session/" . sessionName . ".vim"
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
	if !exists("g:disablePlugins")
		call UltiSnips#JumpForwards()
		if g:ulti_jump_forwards_res == 1
			return ""
		endif
	endif
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[]"
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
	if !exists("g:disablePlugins")
		call UltiSnips#JumpBackwards()
		if g:ulti_jump_backwards_res == 1
			return ""
		endif
	endif
	if !exists("b:smartJumpElements")
		let b:smartJumpElements = "[]'\"(){}<>\[]"
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
" ---- [11.4] TEMPBUFFER ----
let g:bufferBeforeOpoh = ""
function! OpohBuffer()
	let g:bufferBeforeOpoh = expand('%')
	if bufexists("[Opoh]")
		b Opoh
	else
		e [Opoh]
		setlocal nobuflisted
		setlocal filetype=opoh
		setlocal buftype=nofile
	endif
	execute("0,$d")
endfunction

function! FullScreenHelp(search)
	let curPath = expand('%')
	execute("keepalt h " . a:search)
	let helpPath = expand('%')
	if curPath != helpPath
		let curPos = getpos('.')
		keepalt close
		call OpohBuffer()
		execute("keepalt r " . helpPath)
		call setpos(".",curPos)
		setlocal syntax=help
		setlocal nobuflisted
	endif
endfunction
" --------------------
" ---- [11.5] EVALUATE MATH ----
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
" ---- [11.6] START EXTERNAL ----
function! StartEclim()
	let g:EclimdRunning = 1
	call vimproc#system_bg('eclimd')
endfunction

function! StartTexBuilder()
	if !exists("g:minimalMode") && !exists("g:disableExternal")
		cd ~\git\vim
		Start python texbuilder.py %:h %
		cd %:h
	endif
endfunction
" --------------------
" ---- [11.7] SPELLCHECK ----
function! EnglishSpellCheck()
	setlocal spell spelllang=en_us
	if !exists("g:disablePlugins") && has('lua')
		let b:neocomplete_spell_file = 'american-english'
	endif
endfunction

function! SwedishSpellCheck()
	setlocal spell spelllang=sv
	if !exists("g:disablePlugins") && has('lua')
		let b:neocomplete_spell_file = 'swedish'
	endif
endfunction

function! NoSpellCheck()
	setlocal nospell
	if !exists("g:disablePlugins") && has('lua')
		let b:neocomplete_spell_file = ''
	endif
endfunction
" --------------------
" ---- [11.8] DRAW GIT ----
function! DrawGit()
	call clearmatches()
	let pattern = '^\(\t\|[^\t]\{,' . &l:tabstop . '}\)'
	let currentFolder = substitute(expand('%:h'), "\\", "/", "g")
	let currentFile = expand('%:t')
	if exists("*vimproc#system")
		let gitTemp = vimproc#system("git -C " . currentFolder . " diff -U0 " . currentFile)
	else
		let gitTemp = system("git -C " . currentFolder . " diff -U0 " . currentFile)
	endif
	if gitTemp =~ '@@'
		let gitList = split(gitTemp, "\n")[4:]
		let addCommand = ''
		let remCommand = ''
		let cngCommand = ''
		for line in gitList
			if line =~ '^@@ '
				let al = split(substitute(substitute(line, '^[^+]*+', '', ''), ' .*', '', ''), ',')
				let rl = split(substitute(substitute(line, '^[^-]*-', '', ''), ' .*', '', ''), ',')
				let add = (len(al) > 1 ? al[1] : '1')
				let rem = (len(rl) > 1 ? rl[1] : '1')				
				if rem == '0'
					let addCommand .= (addCommand != '' ? '\|' : '')
					let addCommand .= pattern . '\%>' . (al[0]-1) . 'l\%<' . (al[0] + add) . 'l'
				elseif add == '0'
					let remCommand .= (remCommand != '' ? '\|' : '')
					let remCommand .= pattern . '\%' . (al[0] + 1) . 'l'
				else
					let cngCommand .= (cngCommand != '' ? '\|' : '')
					let cngCommand .= pattern . '\%>' . (al[0]-1) . 'l\%<' . (al[0] + add) . 'l'
				endif
			endif	
		endfor
		if addCommand != ''
			call matchadd('GitAdd', addCommand)
		endif
		if cngCommand != ''
			call matchadd('GitCng', cngCommand)
		endif
		if remCommand != ''
			call matchadd('GitRem', remCommand)
		endif
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
" --------------------
