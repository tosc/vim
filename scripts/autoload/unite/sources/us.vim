function! unite#sources#us#define()
	return s:source
endfunction

" Ultisnips source
let s:source = {
	\ 'name' : 'us',
	\ 'description' : 'us',
	\ 'action_table': {},
	\ 'default_action' : '',
	\ }

function! s:source.gather_candidates(args, context)
	let suggestions = []
	let file = g:UltiSnipsSnippetsDir . '/tags/' . &filetype . '.tags'
	if exists("*vimproc#system")
		let newWords = vimproc#system('cat ' . file . ' | grep "^'. a:context.input . '"')
	else
		let newWords = system('cat ' . file . ' | grep "^'. a:context.input . '"')
	endif
	let wordList = split(newWords, "\n")
	for t_word in wordList
		call add(suggestions, {
			\ 'word' : t_word,
			\ })
	endfor

	let file = g:UltiSnipsSnippetsDir . '/tags/all.tags'
	if exists("*vimproc#system")
		let newWords = vimproc#system('cat ' . file . ' | grep "^'. a:context.input . '"')
	else
		let newWords = system('cat ' . file . ' | grep "^'. a:context.input . '"')
	endif
	let wordList = split(newWords, "\n")
	for t_word in wordList
		call add(suggestions, {
			\ 'word' : '<MISSING>' . t_word,
			\ })
	endfor
	return suggestions
endfunction
