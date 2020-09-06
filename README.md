# explore.kak

Explore things with your favorite explorer.

## Installation

Add [`explore`](rc/explore) to your autoload or source the files in the directory manually.

``` kak
require-module explore-files
require-module explore-buffers
```

## Usage

Enable explore with `explore-files-enable` and `explore-buffers-enable`.

Contrarily to its name, explore.kak does not explore files by itself, but provides
an interface for exploring things (currently [files] and [buffers]) with a command
implementation.

The [configuration](#configuration) section will give you a quick idea of how you
can hook your favorite explorer.

[files]: rc/explore/files.kak
[buffers]: rc/explore/buffers.kak

**Example** – Explore a directory:

``` kak
edit src
```

``` sh
kak src
```

**Example** – Explore the current buffer directory:

``` kak
edit
```

**Example** – Explore the directory whose name is selected with `gf`:

``` crystal
require "../src/project"
```

**Example** – Explore buffers:

``` kak
buffer
```

## Configuration

``` kak
alias global explore-files fzf-files
alias global explore-buffers fzf-buffers
```

See [connect.kak].

[Kakoune]: https://kakoune.org
[connect.kak]: https://github.com/alexherbo2/connect.kak
