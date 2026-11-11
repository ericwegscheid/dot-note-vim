# AGENTS.md

dot-note-vim is a Vim plugin for the `note` filetype: plain-text notes built
out of nestable, titled blocks. This file gives coding agents the context
needed to generate and read `*.note` files, and to change the plugin itself.
The "note file format" section is self-contained, so it can be lifted and
used as context when working on `.note` files outside this repo.

## Source of truth

- `syntax/note.vim` — the operative format spec. Where other docs disagree
  with it, it wins.
- `examples/syntax-examples.note` — a working example of every construct;
  the canonical template when generating `.note` content.
- `doc/note.txt` — user-facing `:help` reference (Vim help format: ~78 cols,
  `ft=help` modeline, `*tag*` anchors).
- `README.md` — overview, install, mapping table.

When changing the format, update all four together; see "Known
doc/implementation gaps" for where they currently disagree.

## The note file format

### Blocks

A block is a titled region delimited by `[`...`]`, a colon, and an opening
brace, closed by `}`:

```
[block title]: {
  content lines, indented two spaces by convention
}
```

Rules:

- The opening `{` must be the **last character on the title line** (the
  syntax end pattern is `\]\ze.*:\s*{$`).
- The closing `}` goes on its own line, indented to match the title line.
- Blocks nest freely; a block's content may contain any other construct,
  including other blocks.
- An optional `!` may precede the bracket: `![title]: {` (the `!` is
  highlighted as part of the title delimiter).
- Use `[]` titles. README/doc also describe `<>` and `()` titles as legal
  delimiters, but only `[]` titles get block highlighting and are found by
  the `vib` motion; `<>`/`()` pairs are just generically colored punctuation.

### Titles

`##` at the start of a line (leading whitespace allowed) makes the entire
line a title. Convention: one space after `##`, blank lines around title
sections.

### Lists

`- `, `* `, or `+ ` after optional leading whitespace. The whitespace after
the marker is required (`-item` does not match). Nest levels by indenting.

### Inline emphasis

| Marker        | Meaning        | Syntax group    |
|---------------|----------------|-----------------|
| `*text*`      | bold           | `noteStars`     |
| `~text~`      | strikethrough  | `noteTildes`    |
| `` `text` ``  | inline code    | `noteBacktick`  |
| `$text$`      | highlight      | `noteDollars`   |
| `#text#`      | alert          | `notePound`     |
| `!text!`      | warning        | `noteExclamation` |
| `^text^`      | flag           | `noteCarrot`    |

Rules (from the regexes, verified empirically):

- Emphasis never spans lines; keep the pair on one line.
- The delimiter may not appear inside the span.
- Matching is non-greedy: the nearest pair wins, so `*a* and *b*` is two
  separate spans, not one.
- Unpaired markers are plain punctuation — bare `* ~ \` $ # ! ^ %` in prose
  is fine.
- `$` interacts with money matching and `$...$` pairing: in
  `$123.99 ok, $123. bad, $123.456 bad` the valid `$123.99` highlights as
  money, and the remaining two `$` signs pair up as a `noteDollars` span.
- `%percent%` emphasis is documented in README/doc but **not implemented**
  (see gaps below); do not generate it expecting highlighting.

### Fenced code blocks

Triple-backtick fences. Nothing inside a fence is otherwise processed for
note syntax — no titles, emphasis, lists, or comments match there.

### Comments

- Line comments: `//` at the start of a line (after optional leading
  whitespace only). Inline `//` mid-line does not comment.
- Block comments: `/** ... **/`, may span lines.
- Both may contain `TODO` markers, which still highlight inside them.

### Links

- `http://` / `https://` URLs. The pattern needs at least one dotted domain
  segment, e.g. `http://example.com`,
  `https://example.com/path?query=1`.
- `file:///...` links highlight as a separate group.
- Matching is case-insensitive (`syn case ignore`).

### Arrows

`-->` and `<--` highlight as arrows (use for direction of a relationship).

### Mentions

`@name` — runs until the next whitespace, so `@bob.smith` and
`@carol-jones` are single mentions.

### TODO markers

Bare `TODO` anywhere in the text, case-insensitive (`todo`, `Todo` also
match).

### Checklists

`[ ]` unchecked, `[x]` checked, `[-]` in progress — a plain-text
convention with no dedicated syntax group (the brackets just get
punctuation coloring).

### Money

`$` + digits + `.` + exactly two digits + a non-alphanumeric boundary:
`$1234.99` and `$0.10` match; `$123.`, `$123`, `$123.456` do not.

### Always-colored punctuation and characters

`[ ] { } < > ( )` and `|` are always highlighted, wherever they appear.
The literal character `¤` gets its own group (`noteConceal`).

## Generating `.note` files

Model layout on `examples/syntax-examples.note`:

1. A `//` line-comment header explaining the file.
2. `## ` section titles with blank lines around them.
3. `- ` list items; nest with deeper indentation.
4. `[title]: {` blocks with `{` as the last character of the title line,
   two-space-indented content, and a matching-indent `}` line.
5. Emphasis pairs on a single line, delimiter excluded from the span.
6. `//` comments only at line start; triple-backtick fences for literal
   text.
7. Do not use `%percent%` or `~~~` / `---` / `===` / `***` rules — they are
   documented but unimplemented (see gaps below).

## Reading `.note` files

- A block is a titled region; nesting is conveyed by indentation plus
  matching braces. `%` on a block's `{` jumps to its `}`.
- Emphasis semantics: `*bold*`, `~strikethrough~`, `` `code` `` (literal),
  `$highlight$`, `#alert#`, `!warning!`, `^flag^`.
- `TODO` marks tasks; `@name` marks people; arrows show direction; URLs and
  `file:///` paths are references; checklist states as above.
- Inside triple-backtick fences and comments, emphasis and structure do not
  apply.

## Plugin mechanics (for code changes)

- `ftdetect/note.vim` — `*.note` → `filetype note`.
- `ftplugin/note.vim` — buffer-local `nowrap` and `formatoptions-=cro`;
  defines `<Plug>(note-create-block)` (normal + insert) and
  `<Plug>(note-select-block)` (normal), plus defaults `<leader>[` and `vib`,
  skipped via `hasmapto()` if the user has mapped the `<Plug>` targets;
  `b:undo_ftplugin` unmaps everything.
- `autoload/note.vim` —
  - `note#create_block()`: on a non-blank line, prepends `[`, appends `]: {`,
    and puts the closing `}` on its own line after the paragraph, indented
    to match (so it wraps the cursor's whole paragraph, titling it with the
    current line). On a blank line, replaces the blank line with an empty
    `[]: {` / `}` skeleton and leaves the cursor on the title line.
  - `note#select_block()`: searches for the next `]: {` header, steps back
    one header with `N`, then selects linewise through `%` — i.e. it
    visually selects the innermost enclosing `[]` block from its title line
    through its closing `}`. Only recognizes `]`-style headers.
- `plugin/note.vim` — load guard (`g:loaded_note`).
- `plugin/dot-note.vim` — legacy empty stub.
- `syntax/note.vim` — note also `syn case ignore` (all matching is
  case-insensitive) and a buffer-local `InsertEnter` autocmd forcing
  `syntax sync fromstart`.

### Gotchas

- Highlight links point at custom groups (`Blue`, `SubBlue`, `Magenta`,
  `SubMagenta`, `Red`, `SubRed`, `Green`, `SubGreen`, `Yellow`, `SubYellow`)
  that the user's colorscheme must define. With default colors they are
  undefined and nothing is colored — do not read that as a broken rule.
  Only `Comment` is a standard group.
- `syntax/note.vim` carries its own MIT header (derived from Stephan
  Müller's 2008 file); preserve it when editing. The rest of the plugin is
  GPLv3.

### Known doc/implementation gaps

Documented in `README.md`/`doc/note.txt` but **not implemented** in
`syntax/note.vim` — do not generate these expecting highlighting, and
resolve them (implement or de-document) when touching the format:

- `%percent%` emphasis and the `notePercents` group (only `noteConceal` for
  the literal `¤` exists).
- Horizontal rules `~~~`, `---`, `===`, `***` (`noteLineTilde`,
  `noteLineDashed`, `noteLineEquals`, `noteLineStars`).
- `<>` / `()` block titles (only generic punctuation highlighting, no
  motion support).

Also: the `noteBlock` region's `contains=` list references `notePercent`,
  `noteStar`, `noteDollar`, and `noteTilde`, which are not defined (the
  defined groups are `noteStars`, `noteDollars`, `noteTildes`) — dead
  references, harmless to Vim.

## Verifying changes

There is no test suite; verification is manual. Smoke-test that the plugin
loads and applies the filetype cleanly (run from the repo root; expect exit
0, no error output, and `note` twice in the output file):

```sh
vim -es -Nu NONE -U NONE \
  --cmd 'set rtp+=.' --cmd 'filetype on' --cmd 'syntax on' \
  examples/syntax-examples.note \
  -c 'call writefile([&filetype, b:current_syntax], "/tmp/note-smoke.out")' \
  -c 'qa!' && cat /tmp/note-smoke.out
```

To check which syntax group a character gets:

```vim
:echo synIDattr(synID(line('.'), col('.'), 0), 'name')
```

For interactive checks, open `examples/syntax-examples.note` with the
plugin installed and `:syntax on` active.
