provide-module explore-files %{
  # Enable explore-files
  define-command explore-files-enable -docstring 'Enable explore-files' %{
    # Allow :edit with no argument to explore the buffer directory
    hook -group explore-files global RuntimeError "\d+:\d+: '(edit|e)' wrong argument count" %{
      evaluate-commands -save-regs 'd' %{
        # Save the buffer directory
        set-register d %sh(dirname "$kak_buffile")

        # Display message
        echo -markup "{Information}explore-files %reg{d}{Default}"

        # Start exploring the buffer directory
        explore-files %reg{d}
      }
    }

    # Allow editing directories
    hook -group explore-files global RuntimeError "\d+:\d+: '(?:edit|e)' (.+): is a directory" %{
      # Display message
      echo -markup "{Information}explore-files %val{hook_param_capture_1}{Default}"

      # Start exploring files
      explore-files %val{hook_param_capture_1}
    }

    # Make `gf` to work with directories
    hook -group explore-files global RuntimeError "unable to find file '(.+)'" %{
      # Display message
      echo -markup "{Information}explore-files %val{hook_param_capture_1}{Default}"

      # Start exploring files
      explore-files %val{hook_param_capture_1}
    }

    # Start Kakoune with a directory
    hook -group explore-files global KakBegin .* %{
      # Kakoune just started; wait for the client to be created.
      hook -once global ClientCreate .* %{
        # Save the directories
        evaluate-commands -save-regs 'd' %{
          try %{
            # Search in the *debug* buffer
            evaluate-commands -buffer '*debug*' -save-regs '/' %{
              # Search the directories to edit
              set-register / "^error while opening file '(.+?)':\n[^\n]+: is a directory$"
              execute-keys '%1s<ret>'

              # Save the directories
              set-register d %reg{.}
            }
          }

          # Display message
          echo -markup "{Information}explore-files %reg{d}{Default}"

          # Start exploring files
          explore-files %reg{d}
        }
      }
    }
  }

  # Disable explore-files
  define-command explore-files-disable -docstring 'Disable explore-files' %{
    remove-hooks global explore-files
  }

  # Interface
  # Show usage
  define-command -hidden explore-files-interface -params .. %{
    echo -markup '{keyword}alias{Default} {attribute}global{Default} explore-files {Error}command{Default}'
  }

  alias global explore-files explore-files-interface
}
