function! unite#sources#dir#define()
	return [s:source, s:source_new]
endfunction

" Custom dir source.
let s:source = {
	\ 'name': 'dir',
	\ 'description': 'custom dir source',
	\ 'max_candidates': 200,
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ 'default_kind' : 'movable',
	\ 'sorters' : ['sorter_ftime', 'sorter_reverse']
	\}
function! s:source.gather_candidates(args, context)
	let files = []
	
	let path = join(a:args, ':')
	" Add all possible drives if user is at root.
	if path == '' && has('win32')
		let lines = split('A: B: C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: X: Y: Z:')
	else
		" Get content of folder.
		let pathcontent = glob(path . '*')
		let lines = split(pathcontent, '\n')
		let pathcontent = glob(path . '.*')
		let lines += split(pathcontent, '\n')
	endif
	for candidate in lines
		if isdirectory(candidate)
			" Add correct separators if on windows.
			let newpath = UniteFixPath(candidate)
			let file = fnamemodify(newpath, ':t')
			if file == ""
				let file = newpath
			endif
			if file !~ '^\.$' && file !~ '^\.\.$'
				" Add folder to unite.
				call add(files, {'word' : file . "/", 
					\ 'action__path' : newpath . "/"})
			endif
		endif
	endfor
	return files
endfunction

" Open a directory.
let s:source.action_table.open = {
      \ 'description' : 'open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	call UniteExplorer(a:candidate.action__path)
endfunction

" Rm a directory.
let s:source.action_table.rm = {
      \ 'description' : 'rm directory',
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
	if confirm("Confirm deleting folders?" . confirmText, "&Yes\n&No\n&Cancel") == 1
		for path in paths
			if has('win32')
				call system('RD /S /Q "' . path . '"')
			endif
				call system('rm -r "' . path . '"')
		endfor
		call UniteExplorer()
	endif
endfunction

" New directory source
let s:source_new = {
      \ 'name' : 'dir/n',
      \ 'description' : 'dir candidates from input',
      \   'action_table': {},
      \   'default_action' : 'new_folder'
      \ }
function! s:source_new.change_candidates(args, context)
	let path = unite#sources#file#_get_path(a:args, a:context)
	let input = unite#sources#file#_get_input(path, a:context)
	let input = substitute(input, '\*', '', 'g')

	if input == '' || filereadable(input) || isdirectory(input)
		return []
	endif

	let folders = []
	call add(folders, {'word' : a:context.input, 'action__path' : input})
	return folders
endfunction

" Create new directory
let s:source_new.action_table.new_folder = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source_new.action_table.new_folder.func(candidate)
	let filepath = a:candidate.action__path
	if confirm("Create folder " . filepath . "?", "&Yes\n&No\n&Cancel") == 1
		execute 'call mkdir("". "' . filepath . '")'
		call UniteExplorer()
	endif
endfunction
