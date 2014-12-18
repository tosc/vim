function! unite#sources#dots#define()
	return s:source
endfunction

" Custom dir source.
let s:source = {
	\ 'name': 'dots',
	\ 'description': 'a folder for going up',
	\ 'max_candidates': 2,
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ 'sorters' : []
	\}
function! s:source.gather_candidates(args, context)
	let files = []
	
	let path = join(a:args, ':')
	if path != ''
		call add(files, {'word' : "..",
				\ 'action__path' : path . ".."})
	endif
	return files
endfunction

" Open a directory.
let s:source.action_table.open = {
      \ 'description' : 'open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	" If going back once more then in the top directory of a drive.
	let rawpath = a:candidate.action__path
	if rawpath =~ '^[a-zA-Z]:/\.\.' && has('win32')
		let path = ''
	else
		let path = UniteFixPath(fnamemodify(rawpath, ':p'))
	endif
	" Open new instance with new folder
	let g:unite_path = path
	call UniteExplorer()
endfunction
