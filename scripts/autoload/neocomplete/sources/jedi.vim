let s:jedi_source = {
	\ 'name': 'jedi',
	\ 'kind': 'manual',
	\ 'mark': '[JE]',
	\ 'rank': 7,
	\ 'matchers': ['matcher_head'],
	\ 'is_volatile': 1,
	\ }

" \ 'filetypes' : {'python' : 1}
function! s:jedi_source.gather_candidates(context)
	let suggestions = []
	let l:linecont = getline('.')
	let l:linelen = len(linecont)
	let l:completion = []
	let l:line = line('.')
	let l:lines = join(getline('0', '$'), '\n')
python << endpy
import jedi
import re

source = '\n'.join(vim.current.buffer)
row = vim.current.window.cursor[0]
column = vim.current.window.cursor[1]
buf_path = vim.current.buffer.name
encoding = vim.eval('&encoding') or 'latin1'
script =  jedi.Script(source, row, column, buf_path, encoding)
completions = script.complete()
completion_string = ""
for completion in completions:
	params = completion.params if completion.type == 'function' else ""
	vim.command("call add( l:completion, {'word' : '" + completion.word +
       		"', 'menu' : s:jedi_source.mark . ' " + completion.type +
		"', 'description' : '" + re.sub("'", '`', completion.description) +
		"', 'type' : '" + completion.type + 
		"', 'param' : '" + params +
		"', 'name' : '" + completion.name + "'})")
import os
endpy
	return l:completion
endfunction

function! neocomplete#sources#jedi#define()
	return s:jedi_source
endfunction
