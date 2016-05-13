function! unite#sources#marks#define()
	return s:source
endfunction

let s:source = {
	\ 'name' : 'marks',
	\ 'description' : 'show marks',
	\ 'action_table' : {},
	\ 'default_action' : 'goto' }

function! s:source.gather_candidates(args, context)
	let marks = []
	
	for mark in g:marks
		let info = getpos("'" . mark)
		let text = mark . "\t[" . bufname(info[0]) . "][" . info[1] . "]"
		if info[1] != 0
			call add(marks, {
				\ 'word' : text,
				\ 'action__path' : mark})
			let text = join(getbufline(info[0], info[1]))
			if text == ""
				let text = "File not open."
			endif
			call add(marks, {
				\ 'word' : text,
				\ 'action__path' : mark})
		endif
	endfor
	return marks
endfunction

let s:source.action_table.goto = {
	\ 'description' : 'goto mark',
	\ 'is_quit' : 0,
	\ 'is_start' : 1,
	\ }
function! s:source.action_table.goto.func(candidate)
	let mark = tolower(a:candidate.action__path)
	execute "normal m" . mark
endfunction
