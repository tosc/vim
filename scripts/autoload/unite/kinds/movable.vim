if !exists('g:files_to_move')
	let g:files_to_move = []
endif

function! unite#kinds#movable#define() "{{{
	return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'movable',
      \ 'default_action' : 'move',
      \ 'action_table' : {},
      \ 'parents' : [],
      \}

" move a file
let s:kind.action_table.move = {
      \ 'description' : 'move file',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.move.func(candidates)
	let g:files_to_move = []
	for candidate in a:candidates
		call add(g:files_to_move, UniteFixPath(candidate.action__path))
	endfor
	hi UniteInputPrompt guibg=tomato guifg=black
	call UniteExplorer()
endfunction
