function! unite#sources#bmark#define()
	return s:source
endfunction

" Note source
let s:source = {
	\ 'name' : 'bmark',
	\ 'description' : 'bookmarks',
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ }
function! s:source.gather_candidates(args, context)
	let candidates = []
	let filename = fnamemodify('~/.cache/unite/bmark', ':p')
	if filereadable(filename)
		let lines = readfile(filename)
		for line in lines
			let candidate_info = filter(split(line, "\t"), 'v:val != ""')
			let word = candidate_info[0]
			let path = candidate_info[1]
			let indent = repeat(' ', 20-len(word))
			call add(candidates, {'word' : word,
				\ "action__path" : path,
				\ "abbr" : word . indent . path})
		endfor
	endif
	return candidates
endfunction

" Open a bmark
let s:source.action_table.open = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	let g:unite_bookmark_source = 0
	let g:unite_path = a:candidate.action__path
	call UniteExplorer()
endfunction
