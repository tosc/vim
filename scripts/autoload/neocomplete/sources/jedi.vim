let s:jedi_source = {
	\ 'name': 'jedi',
	\ 'kind': 'keyword',
	\ 'mark': '[JE]',
	\ 'rank': 1,
	\ 'matchers': ['matcher_head'],
	\ 'is_volatile': 1,
	\ }

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '\jedi.py'
function! s:jedi_source.gather_candidates(context)
	let l:completion = []
	execute 'pyfile ' . s:path
	return l:completion
endfunction

function! neocomplete#sources#jedi#define()
	return s:jedi_source
endfunction
