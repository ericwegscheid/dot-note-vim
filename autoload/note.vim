" Autoload:     Note
" Maintainer:   Eric Wegscheid <ericwegscheid@mailfence.com>
" Description:  Functions backing the note filetype's mappings. Self
"               contained: none of this depends on functions defined
"               in a personal vimrc.

" Count lines in the current buffer matching a:pattern.
function! s:count_matches(pattern) abort
  let l:count = 0
  let l:lnum = 1
  while l:lnum <= line('$')
    if getline(l:lnum) =~ a:pattern
      let l:count += 1
    endif
    let l:lnum += 1
  endwhile
  return l:count
endfunction

" Fold every [title]: { ... } block in the buffer. Blocks are folded from
" the bottom of the buffer up so nested blocks are folded innermost-first.
function! note#squish() abort
  let l:pattern = get(g:, 'note_squish_pattern', '^\s*\[.*\]:.*\s{')
  let l:count = s:count_matches(l:pattern)
  if l:count == 0
    echo 'Nothing to squish'
    return
  endif

  let l:view = winsaveview()
  normal! G
  let l:i = 0
  while l:i < l:count
    call search(l:pattern, 'bW')
    normal! $V%zf
    let l:i += 1
  endwhile
  call winrestview(l:view)
  nohlsearch
endfunction

" Open every fold created by note#squish().
function! note#unsquish() abort
  normal! zR
endfunction

" Turn the current line into a block, or insert an empty block below it.
function! note#create_block() abort
  let l:line = getline('.')
  let l:indent = matchstr(l:line, '^\s*')
  let l:chars = substitute(l:line, '\s', '', 'g')
  if l:chars !=# ''
    normal! I[
    normal! A]: {
    execute 'normal! }i' . l:indent . '}'
  else
    execute "normal! ddko[]: {\n}"
    normal! k
  endif
endfunction

" Visually select the block enclosing the cursor.
function! note#select_block() abort
  execute '/]:\s*{/'
  normal! NVf{%
endfunction
