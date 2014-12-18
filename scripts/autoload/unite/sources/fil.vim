function! unite#sources#fil#define()
	return [s:source, s:source_new]
endfunction

" Custom file source
let s:source = {
	\ 'name': 'fil',
	\ 'description': 'custom file source',
	\ 'max_candidates': 200,
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ 'default_kind' : 'movable',
	\ 'sorters' : ['sorter_ftime', 'sorter_reverse']
	\ }

function! s:source.gather_candidates(args, context)
	let files = []
	
	let path = join(a:args, ':')
	if path != ''
		" Get content of folder
		let pathcontent = glob(path . '*')
		let lines = split(pathcontent, '\n')
		" Get hidden content
		let pathcontent = glob(path . '.*')
		let lines += split(pathcontent, '\n')
		for candidate in lines
			if !isdirectory(candidate)
				" Fix separators
				let newpath = UniteFixPath(candidate)
				let file = fnamemodify(newpath, ':t')
				" Add file to unite
				call add(files, {'word' : file, 'action__path' : newpath})
			endif
		endfor
	endif
	return files
endfunction

" Open a file
let s:source.action_table.open = {
      \ 'description' : 'open a file',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	let filepath = a:candidate.action__path
	let filetype = fnamemodify(filepath, ':e')
	let osstart = 0
	for startfiletype in g:osfiletypes
		if filetype =~ startfiletype 
			let osstart = 1
			break
		endif
	endfor
	if osstart
		let splitfilepath = split(filepath, '/')
		let newsplitpath = []
		for folder in splitfilepath
			if folder =~ "\s"
				 call add(newsplitpath, '"' . folder . '"')
			else
				 call add(newsplitpath, folder)
			endif
		endfor
		let newpath = join(newsplitpath, '/')
		call system(' start ' . newpath)
	else	
		execute 'e ' . filepath
	endif
endfunction

" rm a file
let s:source.action_table.rm = {
      \ 'description' : 'rm file',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.rm.func(candidates)
	let paths = []
	for candidate in a:candidates
		call add(paths, candidate.action__path)
	endfor
	let confirmText = "\n\t" . join(paths, "\n\t")
	if confirm("Confirm deleting files?" . confirmText, "&Yes\n&No\n&Cancel") == 1
		for filepath in paths
			call delete(filepath)
		endfor
		call UniteExplorer()
	endif
endfunction

" New file source
let s:source_new = {
	\ 'name' : 'fil/n',
	\ 'description' : 'new file',
	\ 'action_table': {},
	\ 'default_action' : 'new_edit'
	\ }
function! s:source_new.change_candidates(args, context) "{{{
	let path = unite#sources#file#_get_path(a:args, a:context)
	let input = unite#sources#file#_get_input(path, a:context)
	let input = substitute(input, '\*', '', 'g')

	if input == '' || filereadable(input) || isdirectory(input)
		return []
	endif

	let files = []
	call add(files, {'word' : a:context.input, 'action__path' : input})
	return files
endfunction"}}}

" Create new file
let s:source_new.action_table.new_edit = {
	\ 'description' : 'create new file',
	\ 'is_quit' : 0,
	\ 'is_start' : 1,
	\ }
function! s:source_new.action_table.new_edit.func(candidate)
	execute 'e ' . a:candidate.action__path
endfunction
