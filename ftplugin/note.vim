" Filetype plugin: Note
" Maintainer:       Eric Wegscheid <ericwegscheid@mailfence.com>

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal nowrap
setlocal formatoptions-=cro

let b:undo_ftplugin = 'setlocal wrap< formatoptions<'
      \ . '|nunmap <buffer> <leader>['
      \ . '|iunmap <buffer> <leader>['
      \ . '|nunmap <buffer> vib'

nnoremap <buffer> <silent> <Plug>(note-create-block) :call note#create_block()<CR>
inoremap <buffer> <silent> <Plug>(note-create-block) <Esc>:call note#create_block()<CR>
nnoremap <buffer> <silent> <Plug>(note-select-block) :call note#select_block()<CR>

if !hasmapto('<Plug>(note-create-block)', 'n')
  nmap <buffer> <leader>[ <Plug>(note-create-block)
endif
if !hasmapto('<Plug>(note-create-block)', 'i')
  imap <buffer> <leader>[ <Plug>(note-create-block)
endif
if !hasmapto('<Plug>(note-select-block)', 'n')
  nmap <buffer> vib <Plug>(note-select-block)
endif
