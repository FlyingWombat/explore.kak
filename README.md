# Edit directory

[![IRC Badge]][IRC]

###### [Usage] | [Documentation] | [Contributing]

> A file explorer for [Kakoune].

![Demo]

## Installation

### [Pathogen]

``` kak
pathogen-infect /home/user/repositories/github.com/alexherbo2/edit-directory.kak
```

## Usage

``` kak
hook global WinCreate .* %{
  edit-directory-enable
}
```

Then edit a directory.

- Use <kbd>Return</kbd> to edit files (works with multiple selections).
- Use <kbd>Backspace</kbd> to edit parent directory.
- Use <kbd>.</kbd> to show hidden files.
- Use <kbd>R</kbd> to show directory entries recursively.
- Use <kbd>q</kbd> to change directory and quit.
- Use <kbd>Escape</kbd> to close buffer.

## Configuration

### [fd]

``` kak
define-command -hidden edit-directory-fd -params 0..1 %{
  edit-directory-display "fd %sh(test $kak_opt_edit_directory_show_hidden = true && echo --hidden)" %arg(1)
}

hook global WinSetOption filetype=directory %{
  map window normal R ':<space>edit-directory-fd %val(bufname)<ret>'
}
```

## Commands

- `edit-directory-enable`: Enable editing directories
- `edit-directory-disable`: Disable editing directories
- `edit-directory-toggle`: Toggle editing directories

## Options

- `edit_directory_show_hidden` `bool`: Whether to show hidden files (Default: `no`)
- `edit_directory_enabled` `bool`: Whether extension is active (Read-only)

## Faces

- `EditDirectoryFiles` `magenta,default`: Face used to show files
- `EditDirectoryDirectories` `cyan,default`: Face used to show directories

## Credits

Similar extensions:

- [TeddyDD]/[kakoune-edit-or-dir]
- [occivink]/[kakoune-filetree]

[Kakoune]: http://kakoune.org
[IRC]: https://webchat.freenode.net?channels=kakoune
[IRC Badge]: https://img.shields.io/badge/IRC-%23kakoune-blue.svg
[Demo]: images/demo.gif
[Usage]: #usage
[Documentation]: #commands
[Contributing]: CONTRIBUTING
[Pathogen]: https://github.com/alexherbo2/pathogen.kak
[fd]: https://github.com/sharkdp/fd
[TeddyDD]: https://github.com/TeddyDD
[kakoune-edit-or-dir]: https://github.com/TeddyDD/kakoune-edit-or-dir
[occivink]: https://github.com/occivink
[kakoune-filetree]: https://github.com/occivink/kakoune-filetree
