" Vim syntax file
" Language:     Note
" Maintainer:   Eric Wegscheid <ericwegscheid@mailfence.com>

" Licensed under the MIT License (MIT):
"
" Copyright (c) 2008 Stephan Müller
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

if exists('b:current_syntax')
  finish
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

syn match noteTodo             /TODO/
hi link noteTodo               Red

syn match noteBrackets         /\[\|\]/
hi link noteBrackets           SubBlue

syn match noteBraces           /{\|}/
hi link noteBraces             SubBlue

syn match noteAngles           /<\|>/
hi link noteAngles             SubBlue

syn match noteParens           /(\|)/
hi link noteParens             SubBlue

syn match notePipe             /|/
hi link notePipe               SubBlue

syn match noteListItem         /^\s*[-*+]\s\+/
hi link noteListItem           Magenta

" oneline groups
syn match noteTilde            /\~/
hi link noteTilde              SubBlue
syn match noteTildes            /\~\([^\~]\{-}\)\~/
hi link noteTildes             SubBlue

syn match noteDollar            /\$/
hi link noteDollar             SubGreen
syn match noteDollars           /\$\([^\$]\{-}\)\$/
hi link noteDollars             SubGreen

syn match notePound             /#\([^#]\{-}\)#/
hi link notePound               Red

syn match noteStar               /\*/
hi link noteStar                 Magenta
syn match noteStars              /\*\([^\*]\{-}\)\*/
hi link noteStars                Magenta

syn match noteExclamation        /\!\([^\!]\{-}\)\!/
hi link noteExclamation          SubYellow

syn match noteBacktick           /`\([^`]\{-}\)`/
hi link noteBacktick             Green

syn match noteCarrot             /\^\([^\^]\{-}\)\^/
hi link noteCarrot               Red

" syn match notePercent          /%\([^%]\{-}\)%/ conceal cchar=╬
syn match notePercent            /%/
hi link notePercent              Yellow
syn match notePercents           /%\([^%]\{-}\)%/ conceal cchar=¤
hi link notePercents             Yellow

syn match noteConceal            "¤"
hi link noteConceal              Yellow

" line breaks (must be after oneline groups)
syn match noteLineTilde          /\~\~\~/
hi link noteLineTilde            SubBlue

syn match noteLineDashed         /\-\-\-/
hi link noteLineDashed           Yellow

syn match noteLineEquals         /===/
hi link noteLineEquals           SubCyan

syn match noteLineStars          /\*\*\*/
hi link noteLineStars            Magenta

" multiline groups
syn region noteCodeBlock start=/```/ end=/```/ keepend
hi link noteCodeBlock       Green

syn region noteComment start=/\/\*\*/ end=/\*\*\//   contains=noteTodo
hi link noteComment       SubGreen

" special
" syn match noteTitle            /^\s*\#\#.*$/
" hi link noteTitle              Red


" syn match noteGroupTitle            /^\s*\#\#\s*[a-z]\+/
" hi link noteGroupTitle              Blue
"

" syn match noteLink            /\(asdf\):\/\/\/\([a-z0-9\-]\+\.\)\+[a-z0-9\-]\+[^ ]\+/
syn match noteUrl            /\(https\?\):\/\/\([a-z0-9\-]\+\.\)\+[a-z0-9\-]\+[^ ]\+/
hi link noteUrl              SubMagenta

syn match noteLink            /\(file\):\/\/\/[a-z0-9\-\.\/]\+/
hi link noteLink              SubMagenta

syn match noteCommentLine     /^\s*\/\/.*$/   contains=noteTodo
hi link noteCommentLine       Comment

syn match noteArrow            /\-\->\|<\-\-/
hi link noteArrow              Magenta

" syn match noteCheckbox         /(\zs[^)]\+\ze)/
" syntax match noteCheckbox      /\%(\(\zs[^)]\+\ze\)\)/ contained
" hi link noteCheckbox           Yellow

syn region noteBlock matchgroup=noteDelimiter start="\!\?\[" end="\]\ze.*:\s*{$" contains=noteAngles,noteParens,notePipe,notenotePound,noteExclamation,noteDollar,noteCarrot,noteTilde,notePercent,noteStar,noteBacktick,@Spell oneline
syn region noteBlock matchgroup=noteDelimiter start="\!\?<" end=">\ze.*:\s*{$" contains=noteBrackets,noteParens,notePipe,notePound,noteExclamation,noteDollar,noteCarrot,noteTilde,notePercent,noteStar,noteBacktick,@Spell oneline
syn region noteBlock matchgroup=noteDelimiter start="\!\?(" end=")\ze.*:\s*{$" contains=noteBrackets,noteAngles,notePipe,notePound,noteExclamation,noteDollar,noteCarrot,noteTilde,notePercent,noteStar,noteBacktick,@Spell oneline
hi link noteBlock         Magenta
hi link noteDelimiter     SubBlue

autocmd InsertEnter <buffer> syntax sync fromstart

let b:current_syntax = "note"
