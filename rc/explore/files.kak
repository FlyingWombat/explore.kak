provide-module explore-files %{
  define-command explore-files-enable -docstring 'Enable explore-files' %{
    hook -group explore-files global RuntimeError "\d+:\d+: '(edit|e)' wrong argument count" %{
      evaluate-commands -save-regs 'd' %{
        set-register d %sh(dirname "$kak_buffile")
        echo -markup "{Information}explore-files %reg{d}{Default}"
        explore-files %reg{d}
      }
    }
    hook -group explore-files global RuntimeError "\d+:\d+: '(?:edit|e)' (.+): is a directory" %{
      echo -markup "{Information}explore-files %val{hook_param_capture_1}{Default}"
      explore-files %val{hook_param_capture_1}
    }
    hook -group explore-files global RuntimeError "unable to find file '(.+)'" %{
      echo -markup "{Information}explore-files %val{hook_param_capture_1}{Default}"
      explore-files %val{hook_param_capture_1}
    }
    hook -group explore-files global KakBegin .* %{
      hook -once global ClientCreate .* %{
        try %{
          evaluate-commands -buffer '*debug*' -save-regs '/' %{
            set-register / "^error while opening file '(.+?)':\n[^\n]+: is a directory$"
            execute-keys '%1s<ret>'
            evaluate-commands -draft -itersel -save-regs 'd' %{
              set-register d %reg{.}
              evaluate-commands -client %val{hook_param} %{
                echo -markup "{Information}explore-files %reg{d}{Default}"
                explore-files %reg{d}
              }
            }
          }
        }
      }
    }
  }
  define-command explore-files-disable -docstring 'Disable explore-files' %{
    remove-hooks global explore-files
  }
  # Show a template as fallback
  define-command -hidden explore-files-default -params .. %{
    echo -markup '{keyword}alias{Default} {attribute}global{Default} explore-files {Error}command{Default}'
  }
  alias global explore-files explore-files-default
}
