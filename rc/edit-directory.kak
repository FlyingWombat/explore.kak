declare-option -docstring 'Whether to show hidden files' bool edit_directory_show_hidden no
declare-option -docstring 'Whether extension is active' bool edit_directory_enabled no

declare-option -hidden str edit_directory
declare-option -hidden int edit_directory_file_count

set-face global EditDirectoryFiles 'magenta,default'
set-face global EditDirectoryDirectories 'cyan,default'

add-highlighter shared/directory regions
add-highlighter shared/directory/content default-region group
add-highlighter shared/directory/content/files regex '^.+$' 0:EditDirectoryFiles
add-highlighter shared/directory/content/directories regex '^.+/$' 0:EditDirectoryDirectories

define-command -hidden edit-directory-display -params 1..2 %{ evaluate-commands %sh{
  command=$1
  path=$(realpath "${2:-.}")
  name=$(basename "$path")
  out=$(mktemp --directory)
  fifo=$out/fifo
  last_buffer_name=$(basename "$kak_bufname")
  mkfifo $fifo
  cd "$path"
  ($command > $fifo) < /dev/null > /dev/null 2>&1 &
  echo "
    edit -fifo %($fifo) %($path)
    set-option buffer filetype directory
    hook -once window NormalIdle '' %{
      evaluate-commands -save-regs / %{
        set-register / %(\b\Q$last_buffer_name\E\b)
        try %(execute-keys n)
      }
      echo -markup {Information} %(Showing $name/ entries)
    }
    hook -always -once buffer BufCloseFifo '' %(nop %sh(rm --recursive $out))
  "
}}

define-command -hidden edit-directory-smart -params 0..1 %{ evaluate-commands %sh{
  file=${1:-.}
  edit=$(test -d "$file" && echo edit-directory || echo edit)
  echo "$edit %($file)"
}}

define-command -hidden edit-directory -params 0..1 -docstring 'Edit directory entries' %{
  edit-directory-display "ls --dereference --group-directories-first --indicator-style=slash %sh(test $kak_opt_edit_directory_show_hidden = true && echo --almost-all)" %arg(1)
}

define-command -hidden edit-directory-recursive -params 0..1 -docstring 'Edit directory entries recursively' %{
  edit-directory-display "find %sh(test $kak_opt_edit_directory_show_hidden = false && echo -not -path ""'*/.*'"")" %arg(1)
}

define-command -hidden edit-directory-forward -docstring 'Edit selected files' %{
  set-option current edit_directory %val(bufname)
  execute-keys '<a-s>;<a-x>_'
  set-option current edit_directory_file_count %sh(count() { echo $#; }; count $kak_selections_desc)
  evaluate-commands -draft -itersel %{
    evaluate-commands -client %val(client) edit-directory-smart "%val(bufname)/%reg(.)"
  }
  delete-buffer %opt(edit_directory)
  evaluate-commands %sh{
    count=$kak_opt_edit_directory_file_count
    test $count -gt 1 &&
      echo "echo -markup {Information} %[$count files opened]"
  }
}

define-command -hidden edit-directory-back -docstring 'Edit parent directory' %{
  set-option current edit_directory %val(bufname)
  edit-directory "%opt(edit_directory)/.."
  delete-buffer %opt(edit_directory)
  echo -markup {Information} "Showing %sh(basename ""$kak_bufname"")/ entries"
}

define-command -hidden edit-directory-change-directory -docstring 'Change directory and quit' %{
  change-directory %val(bufname)
  delete-buffer
}

define-command -hidden edit-directory-toggle-hidden -docstring 'Toggle hidden files' %{
  set-option current edit_directory_show_hidden %sh{
    if test $kak_opt_edit_directory_show_hidden = true; then
      echo no
    else
      echo yes
    fi
  }
  edit-directory %val(bufname)
}

hook global WinSetOption filetype=directory %{
  add-highlighter window/ ref directory
  map window normal <ret> ':<space>edit-directory-forward<ret>'
  map window normal <backspace> ':<space>edit-directory-back<ret>'
  map window normal . ':<space>edit-directory-toggle-hidden<ret>'
  map window normal R ':<space>edit-directory-recursive %val(bufname)<ret>'
  map window normal q ':<space>edit-directory-change-directory<ret>'
  map window normal <esc> ':<space>delete-buffer<ret>'
}

hook global WinSetOption filetype=(?!directory).* %{
  remove-highlighter window/directory
}

define-command edit-directory-enable -docstring 'Enable editing directories' %{
  hook window -group edit-directory RuntimeError '\d+:\d+: ''\w+'' (.+): is a directory' %{
    # Hide error message
    echo
    edit-directory %val(hook_param_capture_1)
  }
  hook window -group edit-directory RuntimeError 'unable to find file ''(.+)''' %{
    # Hide error message
    echo
    edit-directory-smart %val(hook_param_capture_1)
  }
  set-option window edit_directory_enabled yes
}

define-command edit-directory-disable -docstring 'Disable editing directories' %{
  remove-hooks window edit-directory
  set-option window edit_directory_enabled no
}

define-command edit-directory-toggle -docstring 'Toggle editing directories' %{ evaluate-commands %sh{
  if $kak_opt_edit_directory_enabled = true; then
    echo edit-directory-disable
  else
    echo edit-directory-enable
  fi
}}
