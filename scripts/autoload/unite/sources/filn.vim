function! unite#sources#filn#define()
	return s:source
endfunction

let s:source = {
	\ 'name' : 'filn',
	\ 'description' : 'new file',
	\ 'action_table' : {},
	\ 'default_action' : 'open' }

function! s:source.change_candidates(args, context)
	let path = unite#sources#file#_get_path(a:args, a:context)
	let input = unite#sources#file#_get_input(path, a:context)
	let input = substitute(input, '\*', '', 'g')

	if input == '' || filereadable(input) || isdirectory(input)
		return []
	endif

	let files = []
	call add(files, {'word' : a:context.input, 'action__path' : a:context.input})
	return files
endfunction

let s:source.action_table.open = {
	\ 'description' : 'create new file',
	\ 'is_quit' : 0,
	\ 'is_start' : 1,
	\ }
function! s:source.action_table.open.func(candidate)
	execute 'e ' . a:candidate.action__path
endfunction
