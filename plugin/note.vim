" Plugin:       Note
" Maintainer:   Eric Wegscheid <ericwegscheid@mailfence.com>
" Description:  Load guard for the note filetype plugin.

if exists('g:loaded_note')
  finish
endif
let g:loaded_note = 1
