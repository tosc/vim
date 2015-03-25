function! unite#sources#tagfolders#define()
	return s:source_tags
endfunction

" Tagsource
let s:source_tags = {
	\ 'name' : 'tagfolders',
	\ 'description' : 'dir notes',
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ 'sorters' :  []
	\ }
function! s:source_tags.gather_candidates(args, context)
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
			\ 'action__path' : newpath . "/"})
	endfor
	return files
endfunction

function! s:source_tags.change_candidates(args, context)
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
			\ 'abbr': "Create new category: " . a:context.input})
	return folders
endfunction

" Open tag
let s:source_tags.action_table.open = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source_tags.action_table.open.func(candidate)
	let filetype = fnamemodify(a:candidate.action__path, ':t')
	" Open new instance with new folder
	call UniteTags(a:candidate.word)
endfunction
