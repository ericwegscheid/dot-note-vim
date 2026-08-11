" Plugin:       Note
" Maintainer:   Eric Wegscheid <ericwegscheid@mailfence.com>
" Description:  Global configuration defaults for the note filetype.
"               See doc/note.txt for the full list of g:note_* options.

if exists('g:loaded_note')
  finish
endif
let g:loaded_note = 1

" Vim regex matched against each line to find a block header, e.g. [title]: {
if !exists('g:note_squish_pattern')
  let g:note_squish_pattern = '^\s*\[.*\]:.*\s{'
endif

" Fold every block automatically the first time a *.note buffer is read.
if !exists('g:note_auto_squish')
  let g:note_auto_squish = 1
endif
