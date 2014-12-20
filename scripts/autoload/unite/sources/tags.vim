function! unite#sources#tags#define()
	return s:source
endfunction

" Tag source
let s:source = {
	\ 'name' : 'tags',
	\ 'description' : 'tags',
	\ 'action_table': {},
	\ 'default_action' : 'open',
	\ }

function! s:source.gather_candidates(args, context)
	let candidates = []
	if exists("*vimproc#system")
		let newWords = vimproc#system('cat ~/info/' . a:args[0] . '/tags | grep "'. a:context.input . '"')
	else
		let newWords = system('cat ~/info/' . a:args[0] . '/tags | grep "^'. a:context.input . '"')
	endif
	let filelist = split(newWords, "\n")
	for tag in filelist
		let taglist = split(tag, "\t")
		call add(candidates, {
			\ 'word' : taglist[0],
			\ "action__path" : taglist[1],
			\ "abbr" : taglist[0],
			\ "search" : taglist[2],
			\ })
	endfor
	return candidates
endfunction

" Open a tag
let s:source.action_table.open = {
      \ 'description' : 'open files or open directory',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.open.func(candidate)
	execute "e +/" . a:candidate.search . " " . a:candidate.action__path
endfunction
