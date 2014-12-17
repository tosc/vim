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
set guioptions=c
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
set colorcolumn=78

" Shows whitespaces and tabs when using list.
set listchars=tab:\ \ ,trail:#,extends:\ ,precedes:\ ,nbsp:\ 
set list

" Shows marks on autowrapped lines
set showbreak=<<

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
	Plugin 'Shougo/unite-help'
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
	Plugin 'tosc/vim-scripts'
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
if !exists("g:disablePlugins")
	let g:osfiletypes = ["mkv","pdf","mp4","zip"]

	call unite#custom#default_action('buffer', 'goto')
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#filters#sorter_default#use(['sorter_ftime', 'sorter_reverse'])
	call unite#custom#profile('default', 'context', {
				\ 'start_insert' : 1,
				\ 'smartcase' : 1,
				\ 'ignorecase' : 1,
				\ 'no_split' : 1,
				\ 'no_resize' : 1,
				\ 'update_time' : 300,
				\ 'cursor_line_highlight' : 'TabLine'
				\ })

	let custom_open = {
	      \ 'description' : 'open files or open directory',
	      \ 'is_quit' : 0,
	      \ 'is_start' : 1,
	      \ }
	" Open a directory.
	function! custom_open.func(candidate)
		let g:unite_bookmark_source = 0
		let g:unite_path = a:candidate.action__path
		call UniteExplorer()
	endfunction
	" Make bookmarks behave like a directory.
	call unite#custom#action('file', 'custom_open', custom_open)
	call unite#custom#default_action('bookmark', 'custom_open')
endif

function! UniteExplorerStart()
	let g:file_to_move = ''
	hi UniteInputPrompt guibg=NONE guifg=palegreen
	let g:unite_bookmark_source = 0
	if !exists("g:unite_path")
		let g:unite_path = substitute(getcwd(), '\', '/', 'g')
	endif
	call UniteExplorer()
endfunction
function! UniteExplorer()
	call unite#start([
		\ ['move', g:unite_path],
		\ ['dots', g:unite_path],
		\ ['dir', g:unite_path],
		\ ['fil', g:unite_path],
		\ ['fil/n', g:unite_path],
		\ ['dir/n', g:unite_path]],
		\ {'prompt' : g:unite_path . '>'})
	call unite#mappings#narrowing("", 0)
endfunction
function! UniteFileSwitcher()
	execute 'Unite buffer file_mru'
endfunction
let g:unite_bookmark_source = 0
function! OpenBookmarkSource()
	let g:unite_bookmark_source = 1
	execute "Unite -prompt=bookmark> bookmark -default-action=custom_open"
endfunction
function! UniteExit()
	if g:unite_bookmark_source
		call UniteExplorerStart()
	else
		execute "normal \<Plug>(unite_all_exit)"
	endif
	let g:file_to_move = ''
	hi UniteInputPrompt guibg=NONE guifg=palegreen
endfunction
" Convert unite args to path.
function! UniteParsePath(args)
	let path = unite#util#substitute_path_separator(
		 \ unite#util#expand(join(a:args, ':')))
	let path = unite#util#substitute_path_separator(
		 \ fnamemodify(path, ':p'))

	return path
endfunction
function! UniteFixPath(path)
	if has('unix')
		if a:path =~ '\.\.$'
			let path = fnamemodify(a:path . '/', ':p')
		else
			let path = a:path
		endif
		return substitute(path, '//', '/', 'g')
	elseif has('win32')
		let path = fnamemodify(a:path, ':p')
		let splitWord = split(path, '\')
		return join(splitWord, '/')
	endif
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
" ---- [2.7] NEOCOMPLETE ----
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
" ---- [2.8] JEDI ----
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
" ---- [2.9] SYNTASTIC ----
let g:syntastic_mode_map = { "mode": "active",
			   \ "active_filetypes": [],
			   \ "passive_filetypes": ["vim"] }
let g:syntastic_auto_loc_list = 1
" --------------------
" --------------------
" ---- [3] BINDINGS ----
" ---- [3.0] NORMAL ----
function! BindInner(kMap, nMap)
	execute "nnoremap ci" . a:kMap . " " . a:nMap
	execute "nnoremap di" . a:kMap . " " . a:nMap
	execute "nnoremap vi" . a:kMap . " " . a:nMap
	execute "nnoremap yi" . a:kMap . " " . a:nMap
endfunction
" Wanted binds like cib ciB but for [] and <> "" ''
call BindInner('d', '[')
call BindInner('D', '>')
call BindInner('c', '"')
call BindInner('C', "'")

" I keep pressing << >> in the wrong order. HL are good for directions.
nnoremap H << 
nnoremap L >> 

" Wanted a easier bind for $
nnoremap + $

" Show the my normal and insert bindings.
nnoremap g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /\[3.0\]<CR> :0,.-1d<CR>/\[3.2\]<CR> :.,$d<CR>gg

" Do last recording. (Removes exmode which I never use.)
nnoremap Q @@

"Not vi-compatible but more logical. Y yanks to end of line.
nnoremap Y y$

" Close everything except current fold.
nnoremap zV zMzv

if !exists("g:disablePlugins")
	" Search file using unite.
	nnoremap ä :Unite line -custom-line-enable-highlight<CR>

	nnoremap ö :call UniteFileSwitcher()<CR>
	nnoremap Ö :call UniteExplorerStart()<CR>
else
	nnoremap ä /
	nnoremap ö :e
	nnoremap Ö :e
endif

" Jump to next(previous) ultisnips location if one exists, 
" else jump to next(previous) delimiter.
nnoremap <S-Space> :call SmartJump()<CR>
nnoremap <S-BS> :call SmartJumpBack()<CR>

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
nnoremap mg? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r
	\ ~/git/vim/.vimrc <CR> /\[9.2\]<CR>j :0,.-1d<CR>/" --------<CR>
	\ :.,$d<CR>:call HelpMarkColor()<CR>
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

" Autocomplete line.
inoremap <C-L> <C-X><C-L>

if !exists("g:disablePlugins")
	" Run my tabcompletion.
	inoremap <TAB> <C-R>=NeoTab()<CR>
else
	" Simple tabcompletion.
	inoremap <expr><TAB> getline(".")[col('.') - 2] =~ '\w' ? '<C-X><C-N>' : StartDelim("\<TAB>", "")
endif

" Jump to next(previous) ultisnips location if one exists, 
" else jump to next(previous) delimiter.
inoremap <S-Space> <C-R>=SmartJump()<CR>
inoremap <S-BS> <C-R>=SmartJumpBack()<CR>
inoremap <pageup> <C-R>=SmartJump()<CR>
inoremap <pagedown> <C-R>=SmartJumpBack()<CR>

" Readline bindings.
inoremap <C-A> <home>
inoremap <C-E> <end>
inoremap <C-K> <C-O>D

" Pressing enter chooses completion if completion window is up.
inoremap <expr> <CR> pumvisible() ? '<C-e><CR>' : StartDelim("\<CR>", '')

" Easier delimiters.
inoremap {{ {<cr><cr>}<up><TAB>
noremap! <expr> { StartDelim('{', '}')
noremap! <expr> } StartDelim('}', 'opt')
noremap! <expr> ( StartDelim('(', ')')
noremap! <expr> ) StartDelim(')', 'opt')
noremap! <expr> < StartDelim('<', '>')
noremap! <expr> > StartDelim('>', 'opt')
noremap! <expr> [ StartDelim('[', ']')
noremap! <expr> ] StartDelim(']', 'opt')
noremap! <expr> " StartDelim('"', '"')
noremap! <expr> ' StartDelim("'", "'")
noremap! <expr> <left> StartDelim("\<left>", '')
noremap! <expr> <space> StartDelim("\<space>", '')
noremap! <expr> <bs> StartDelim("\<bs>", '')
noremap! <expr> , StartDelim(",", '')
noremap! <expr> . StartDelim('dot', '')
" --------------------
" ---- [3.2] VISUAL ----
" I keep pressing << >> in the wrong order. HL are good for directions.
" Also reselects after action.
vnoremap H <gv
vnoremap L >gv

xnoremap + $

xnoremap å c<C-R>=PythonMath()<CR>

" Jump to next(previous) ultisnips location if one exists,
" else jump to next(previous) delimiter.
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

xnoremap g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /\[3.2\]<CR> :0,.-1d<CR>/\[3.3\]<CR> :.,$d<CR>gg
" --------------------
" ---- [3.3] LEADER ----
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
" Fetch new info from programming running with r
" G
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

if !exists("g:disablePlugins")
	map <leader>gc :Gcommit<CR>
	map <leader>gd :Gdiff<CR>
	map <leader>gg :Gstatus<CR>
endif

noremap <leader>g? :call OpohBuffer() <bar> setlocal syntax=vim <bar> keepalt r ~/git/vim/.vimrc <CR> /\[3.3\]<CR> :0,.-1d<CR>/\[3.4\]<CR> :.,$d<CR>gg
" H
" Unite help when I get it working.
" I
map <leader>ii :Unite tags:~/info/ <CR>
map <leader>in :Unite notes:~/info/ <CR>
" J
" K
" Kill program running with r
" L
" M
map <leader>m :!make<CR>
if !exists("g:disablePlugins")
	map <leader>m :cd %:h<CR>:Unite -auto-preview -no-start-insert
				\ build:make<CR>
endif
" N
map <leader>n :bn <CR>
" O
map <leader>o :call UniteFileSwitcher()<CR>
map <leader>O :call UniteExplorerStart()<CR>
" P
map <leader>p :bp <CR>
" Q
map <leader>q :q <CR>
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
	map <leader>S :Unite ultisnips <CR>
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
	map <leader>uu :Unite fil:~/vimfiles/Ultisnips <CR>
	map <leader>us :Unite ultisnips <CR>
endif
" V
map <leader>vv :e ~/git/vim/.vimrc<CR>
map <leader>vd :w !diff % -<CR>
" W
map <leader>w :w <CR>
" X
" Y
" Z
if !exists("g:disablePlugins")
	map <leader>z :Unite session<CR>
endif
" --------------------
" ---- [3.4] COMMAND ----
cnoremap <C-BS> <C-W>

" Readline bindings.
cnoremap <C-A> <home>
cnoremap <C-E> <end>
cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

cnoremap <expr> h<space> getcmdtype() == ":" && getcmdline() == "" ? "call FullScreenHelp('')\<left>\<left>" : "h "
cnoremap <expr> n getcmdtype() == ":" && getcmdline() == "t" ? 'abnew' : "n"
cnoremap <expr> c getcmdtype() == ":" && getcmdline() == "t" ? 'abc' : "c"

if !exists("g:disablePlugins")
	" I tend to write :git instead of :Git
	cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>Git" : "t"
else
	cnoremap <expr> t getcmdtype() == ":" && getcmdline() == "gi" ? "\<bs>\<bs>!git" : "t"
endif

" Show the my normal and insert bindings.
cnoremap <expr> ? getcmdtype() == ":" && getcmdline() == "g" ? 
			\ "\<bs>" . 'call OpohBuffer() <bar> setlocal syntax=vim <bar>
			\ keepalt r ~/git/vim/.vimrc <CR> /\[3.4\]<CR>
			\ :0,.-1d<CR>/\[3.5\]<CR> :.,$d<CR>gg' : '?'

" See insert for delimiterbindings.
" --------------------
" ---- [3.5] UNITE ----
function! UniteBinds()
	nmap <buffer> b :call OpenBookmarkSource()<CR>
	nmap <buffer> <ESC> :call UniteExit()<CR>
	nmap <buffer> <S-Space> <Plug>(unite_redraw)
	nmap <buffer> <BS> <Plug>(unite_insert_enter)
	nnoremap <silent><buffer><expr> dd unite#do_action('rm')
	nnoremap <silent><buffer><expr> cc unite#do_action('move')
	nnoremap <silent><buffer><expr> <C-p> unite#do_action('preview')
	nnoremap <silent><buffer><expr> <C-c> unite#do_action('cd')
	imap <buffer> <TAB> <Plug>(unite_select_next_line)
	imap <buffer> <S-TAB> <Plug>(unite_select_previous_line)
	inoremap <buffer> <BS> <BS>
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
	nmap <buffer> <esc> :bd<cr>
endfunction
" --------------------
" ---- [3.7] OPOHBUFFER ----
function! OpohBinds()
	nnoremap <buffer> <ESC> :execute("b #")<CR>
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
	autocmd BufWritePost *.tex call 
		\ vimproc#system("pdflatex -halt-on-error -output-directory=" 
		\ . expand('%:h') . " " . expand('%'))
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
if !exists("g:disablePlugins")
	set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
endif

" Gets the gitinfo for the statusline.
function! MyStatusLine()
	if !exists("b:statusLineVar")
		call UpdateGitInfo()
	endif
	if !exists("g:disablePlugins")
		if SyntasticStatuslineFlag() == ""
			hi StatusLine guibg=NONE
		else
			hi StatusLine guibg=red
		endif
	endif

	return b:statusLineVar
endfunction

" Updates gitinfo for the statusline.
" m - Nr of [m]odified [f]iles.
" +/- - Nr of rows added / deleted.
function! GitStatusLine()
	let SlowStatusLineVar = ""
	if &modifiable
		let currentFolder = substitute(expand('%:h'), "\\", "/", "g")
		if exists("*vimproc#system")
			let gitTemp = vimproc#system("git -C " . 
				\ currentFolder . " status -b -s")
			let rowsTemp = split(vimproc#system("git -C " . 
				\ currentFolder . " diff --numstat"), "\n")
		else
			let rowsTemp = split(system("git -C " .
				\ currentFolder . " diff --numstat"), "\n")
			let gitTemp = system("git -C " . 
				\ currentFolder . " status -b -s")
		endif
		if gitTemp !~ "fatal"
		let gitTemp = substitute(gitTemp[2:], "\\.\\.\\.", '->', '')
			let gitList = split(gitTemp, "\n")
			if len(gitList) > 0
				let SlowStatusLineVar .=
				\ "[" . substitute(substitute(gitList[0],
				\ " ", "", ""), " ", "] ", "")
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
				let SlowStatusLineVar .= " [+" . changedRows[0] .
							\ " -" . changedRows[1] . "]"
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
" --------------------
" ---- [10] AUTOCMD ----
autocmd BufWritePost * call SaveSession()
autocmd BufWritePost * call UpdateGitInfo()

autocmd BufEnter * call UpdateGitInfo()

" To make FastFold calculate the folds when you open a file.
autocmd BufReadPost * normal zuz

autocmd TextChanged,TextChangedI * call HighlightGitDisable()
autocmd TextChangedI * let g:stilldelim -= 1
autocmd InsertEnter * call HighlightDrawDisable()
autocmd InsertLeave * call HighlightDrawEnable()
autocmd BufEnter * call UpdateMatches()

function! KillAllExternal()
	if exists("g:EclimdRunning")
		ShutdownEclim
	endif
	call OmniSharp#StopServer()
endfunction
if !exists("g:disableExternal")
	autocmd VimLeave * call KillAllExternal()
endif

function! UpdateGitInfo()
	call UpdateMatches()
	call GitStatusLine()
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
	return StartDelim("\<TAB>", "")
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
		return StartDelim("\<TAB>", "")
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
" ---- [11.2] JUMP ----
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
" ---- [11.3] TEMPBUFFER ----
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
		setlocal buftype=nofile
	endif
endfunction
" --------------------
" ---- [11.4] EVALUATE MATH ----
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
" ---- [11.5] START EXTERNAL ----
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
" ---- [11.6] SPELLCHECK ----
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
" ---- [11.7] MATCH ----
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
" ---- [11.8] AUTODELIMITER ----
let g:stilldelim = 0
let g:nextdelim = ''
let g:prevdelim = ''
" kMap - first key of the delimiter, same as the button you will bind this to
" nMap - the end of the delimiter. Special values are "opt" and "".
" 		opt is for the last bind of the delimiter
" 		'' is for keys you press after the end of a delimiter
function! StartDelim(kMap, nMap)
	let nextdelim = g:nextdelim
	let prevdelim = g:prevdelim
	let stilldelim = g:stilldelim
	if (g:nextdelim =~ '"' && a:kMap =~ '"') ||
	 \ (g:nextdelim =~ "'" && a:kMap =~ "'")
		let g:nextdelim = 'opt'
	else
		let g:nextdelim = a:nMap
	endif
	let g:prevdelim = a:kMap
	let g:stilldelim = 2
	if nextdelim !~ '^$' && stilldelim > 0
		if nextdelim =~ a:kMap
			return a:kMap . "\<left>"
		elseif nextdelim =~ 'opt'
			if a:kMap =~ 'dot'
				if prevdelim !~ '"'
					return "\<right>."
				endif
			elseif a:nMap =~ '^$'
				return "\<right>" . a:kMap
			endif
		endif
	endif
	if a:kMap =~ 'dot'
		return "."
	endif
	return a:kMap
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
