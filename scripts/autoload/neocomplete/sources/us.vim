let s:us_source = {
	\ 'name': 'us',
	\ 'kind': 'keyword',
	\ 'mark': '[US]',
	\ 'matchers': ['matcher_head'],
	\ 'max_candidates': 20,
	\ 'is_volatile': 1,
	\ 'rank' : 9
	\ }

function! s:us_source.gather_candidates(context)
	let suggestions = []
	let file = g:UltiSnipsSnippetsDir . '/' . &filetype . '.tags'
	if exists("*vimproc#system")
		let newWords = vimproc#system('cat ' . file . ' | grep "^'. a:context.complete_str . '"')
	else
		let newWords = system('cat ' . file . ' | grep "^'. a:context.complete_str . '"')
	endif
	let wordList = split(newWords, "\n")
	for t_word in wordList
		let suggestion = split(t_word, '\t')
		call add(suggestions, {
			\ 'word' : suggestion[0],
			\ 'menu' : '[US] ' . suggestion[1]
			\ })
	endfor

	let file = g:UltiSnipsSnippetsDir . '/all.tags'
	if exists("*vimproc#system")
		let newWords = vimproc#system('cat ' . file . ' | grep "^'. a:context.complete_str . '"')
	else
		let newWords = system('cat ' . file . ' | grep "^'. a:context.complete_str . '"')
	endif
	let wordList = split(newWords, "\n")
	for t_word in wordList
		let suggestion = split(t_word, '\t')
		call add(suggestions, {
			\ 'word' : suggestion[0],
			\ 'menu' : '[US] <MISSING>' . suggestion[1]
			\ })
	endfor
	return suggestions
endfunction

function! neocomplete#sources#us#define()
	return s:us_source
endfunction
