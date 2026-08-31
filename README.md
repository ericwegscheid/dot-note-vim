# dot-note-vim

A Vim plugin for the `note` filetype: a plain-text format built out of
nestable, titled blocks. Includes syntax highlighting, folding, and
block-editing commands.

## Installation

**vim-plug**

```vim
Plug 'ericwegscheid/dot-note-vim'
```

**packer.nvim**

```lua
use 'ericwegscheid/dot-note-vim'
```

**Native package (Vim 8+ / Neovim)**

```sh
git clone https://github.com/ericwegscheid/dot-note-vim \
  ~/.vim/pack/plugins/start/dot-note-vim
```

After installing, run `:helptags ALL` (or point it at this plugin's
`doc/` directory) to enable `:help note.txt`.

## Format

A block is a titled region delimited by a matching bracket pair, a
colon, and an opening brace, closed by `}`:

```
[a bracket-titled block]: {
  content goes here
}
```

Blocks may use `[]`, `<>`, or `()` as delimiters, and may nest freely.
Inline emphasis markers wrap their contents in a repeated delimiter:
`*bold*`, `~strikethrough~`, `` `code` ``, `$highlight$`, `#alert#`,
`!warning!`, `^flag^`, `%percent%`.

See [`examples/syntax-examples.note`](examples/syntax-examples.note) for
an exhaustive demonstration of every syntax group, and `:help note.txt`
for the full reference.

## Mappings

All mappings are buffer-local to `.note` files and defined as `<Plug>`
mappings, so any of them can be remapped without touching the plugin —
e.g. `nmap <buffer> <your-key> <Plug>(note-create-block)`.

| Default    | Mode | `<Plug>` target             | Action                                                    |
|------------|------|------------------------------|------------------------------------------------------------|
| `<leader>[`| n, i | `(note-create-block)`        | Wrap the current line in a block, or insert an empty one   |
| `vib`      | n    | `(note-select-block)`        | Visually select the block enclosing the cursor              |
| `za`       | n    | `(note-squish)`              | Fold every block in the buffer                               |
| `zoa`      | n    | `(note-unsquish)`            | Open every fold in the buffer                                |

## Configuration

| Variable                 | Default          | Description                                                        |
|---------------------------|------------------|----------------------------------------------------------------------|
| `g:note_squish_pattern`   | `'^\s*\[.*\]:.*\s{'` | Regex used to find block headers when folding                    |
| `g:note_auto_squish`      | `1`              | Fold every block automatically when a `.note` buffer is first read |

## License

GPLv3, see [LICENSE](LICENSE). `syntax/note.vim` carries its own MIT
header from the file it was originally derived from.
