function! unite#sources#move#define()
	return s:source_move
endfunction

" move file source
let s:source_move = {
      \ 'name' : 'move',
      \ 'description' : 'move file source',
      \   'action_table': {},
      \   'default_action' : 'move'
      \ }
function! s:source_move.change_candidates(args, context)
	let files = []
	if len(g:files_to_move)
		let path = unite#sources#file#_get_path(a:args, a:context)
		let input = unite#sources#file#_get_input(path, a:context)
		let input = substitute(input, '\*', '', 'g')
		let current_folder = path
		let default_name = fnamemodify(g:files_to_move[0], ':t')
		let default_path = current_folder . default_name
		if len(g:files_to_move) == 1
			if default_path != g:files_to_move[0]
				call add(files, {'word' : default_name , 'action__path' : current_folder})
			endif
			if input != '' && !filereadable(input) && !isdirectory(input)
				call add(files, {'word' : a:context.input, 'action__path' : current_folder})
			endif
		elseif len(g:files_to_move) > 1
			if current_folder != fnamemodify(g:files_to_move[0], ":h")
				call add(files, { 'word' : default_name,
						\ 'action__path' : current_folder,
						\ 'abbr' : len(g:files_to_move) . " files"})
			endif
		endif
	endif
	return files
endfunction

" Move
let s:source_move.action_table.move = {
      \ 'description' : 'move a file',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source_move.action_table.move.func(candidate)
	let filepath = a:candidate.action__path
	let beforePaths = []
	let afterPaths = []
	let confirmTextList = []
	for old_file_to_move in g:files_to_move
		let file_to_move = substitute(old_file_to_move, "/$", "", 'g')
		let default_name = fnamemodify(file_to_move, ':t')
		let before = file_to_move
		if len(g:files_to_move) > 1
			let after = filepath . default_name
		else
			let after = filepath . a:candidate.word
		endif
		call add(beforePaths, before)
		call add(afterPaths, after)
		call add(confirmTextList, before . " -> " . after)
	endfor
	let confirmText = "\n\t" . join(confirmTextList, "\n\t")
	if confirm("Move file(s)?" . confirmText, "&Yes\n&No\n&Cancel") == 1
		for i in range(len(beforePaths))
			call rename(beforePaths[i], afterPaths[i])
		endfor
		let g:files_to_move = []
		hi UniteInputPrompt guibg=NONE guifg=palegreen
		call UniteExplorer()
	endif
endfunction
