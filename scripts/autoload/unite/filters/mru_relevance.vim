function! unite#filters#mru_relevance#define() "{{{
	return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'better abbrs for mru',
      \ 'description' : 'relevance of path',
      \}

function! s:sorter.filter(candidates, context)
	let newcs = []
	let indent = repeat(' ', 20)
	for candidate in a:candidates
		let candidate.abbr = fnamemodify(candidate.word, ':t') . indent . candidate.word
		call add(newcs, candidate)
	endfor
	return newcs
endfunction
