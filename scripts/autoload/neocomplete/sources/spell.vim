let s:spell_source = {
	\ 'name': 'spell',
	\ 'kind': 'keyword',
	\ 'mark': '[SC]',
	\ 'rank': 7,
	\ 'matchers': ['matcher_head'],
	\ 'max_candidates': 20,
	\ 'is_volatile': 1
	\ }

let g:neocomplete_spell_file = ''
function! s:spell_source.gather_candidates(context)
	let suggestions = []
	if exists("g:neocomplete_spell_file")
		let file = g:neocomplete_spell_file
	else
		let file = ''
	endif
	if exists("b:neocomplete_spell_file")
		let file = b:neocomplete_spell_file
	endif
	if file != ''
		if exists("*vimproc#system")
			let newWords = vimproc#system('cat ~/.vim/dict/' . file . ' | grep "^'. a:context.complete_str . '"')
		else
			let newWords = system('cat ~/.vim/dict/' . file . ' | grep "^'. a:context.complete_str . '"')
		endif
		let wordList = split(newWords, "\n")
		for t_word in wordList
			call add(suggestions, {
				\ 'word' : t_word,
				\ 'menu' : '[SC]'
				\ })
		endfor
	endif
	return suggestions
endfunction

function! neocomplete#sources#spell#define()
	return s:spell_source
endfunction
