function! unite#sources#dirn#define()
	return s:source
endfunction

let s:source = {
	\ 'name': 'dirn',
	\ 'description': 'custom dir source',
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\}

function! s:source.change_candidates(args, context)
	let path = unite#sources#file#_get_path(a:args, a:context)
	let input = unite#sources#file#_get_input(path, a:context)
	let input = substitute(input, '\*', '', 'g')

	if input == '' || filereadable(input) || isdirectory(input)
		return []
	endif

	let folders = []
	call add(folders, {'word' : a:context.input, 'action__path' : a:context.input})
	return folders
endfunction

" Create new directory
let s:source.action_table.open = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	let filepath = a:candidate.action__path
	if confirm("Create folder " . filepath . "?", "&Yes\n&No\n&Cancel") == 1
		execute 'call mkdir("". "' . filepath . '")'
		call UniteExplorer(filepath)
	endif
endfunction
