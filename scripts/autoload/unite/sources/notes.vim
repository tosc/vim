function! unite#sources#notes#define()
	return s:source_notes
endfunction

" Note source
let s:source_notes = {
	\ 'name' : 'notes',
	\ 'description' : 'dir notes',
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ 'sorters' :  []
	\ }
function! s:source_notes.gather_candidates(args, context)
	let files = []
	
	let path = join(a:args, ':')
	let pathcontent = glob(path . '*')
	let lines = split(pathcontent, '\n')

	for candidate in lines
		if has('win32')
			let splitWord = split(candidate, '\')
			let newpath = join(splitWord, '/')
		else
			let splitWord = split(candidate, '/')
			let newpath = candidate
		endif
		let file = splitWord[-1]
		call add(files, {
			\ 'word' : file,
			\ 'action__path' : newpath . "/",
			\ 'new' : 0})
	endfor
	return files
endfunction

function! s:source_notes.change_candidates(args, context)
	let path = unite#sources#file#_get_path(a:args, a:context)
	let input = unite#sources#file#_get_input(path, a:context)
	let input = substitute(input, '\*', '', 'g')

	if input == '' || filereadable(input) || isdirectory(input)
	return []
	endif

	let folders = []
	call add(folders, {
			\ 'word' : a:context.input,
			\ 'action__path' : input,
			\ 'abbr': "Create new category: " . a:context.input,
			\ 'new' : 1})
	return folders
endfunction

" Open a note
let s:source_notes.action_table.open = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source_notes.action_table.open.func(candidate)
	let filepath = a:candidate.action__path
	let path = a:candidate.action__path . "notes/"
	if a:candidate.new
		if confirm("About to create folders:\n\t" .
					\ filepath . "\n\t" .
					\ filepath . "/notes\n\t" .
					\ filepath . "/documentation",
				\ "&Yes\n&No\n&Cancel") == 1
			execute 'call mkdir("". "' . filepath . '")'
			execute 'call mkdir("". "' . filepath . "/notes" . '")'
			execute 'call mkdir("". "' . filepath . "/documentation" . '")'
			call unite#start_temporary([
			\ ['fil', path],
			\ ['fil/n', path]],
			\ {'prompt' : path  . '>'})
		endif
	else
		call unite#start_temporary([
		\ ['fil', path],
		\ ['fil/n', path]],
		\ {'prompt' : path  . '>'})
	endif
endfunction
