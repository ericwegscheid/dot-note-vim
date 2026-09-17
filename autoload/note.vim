" Autoload:     Note
" Maintainer:   Eric Wegscheid <ericwegscheid@mailfence.com>
" Description:  Functions backing the note filetype's mappings. Self
"               contained: none of this depends on functions defined
"               in a personal vimrc.

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
