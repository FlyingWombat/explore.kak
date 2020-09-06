provide-module explore-buffers %{
  # Enable explore-buffers
  define-command explore-buffers-enable -docstring 'Enable explore-buffers' %{
    # Allow :buffer with no argument
    hook -group explore-buffers global RuntimeError "\d+:\d+: '(buffer|b)' wrong argument count" %{
      # Display message
      echo -markup '{Information}explore-buffers{Default}'

      # Start exploring buffers
      explore-buffers
    }
  }

  # Disable explore-buffers
  define-command explore-buffers-disable -docstring 'Disable explore-buffers' %{
    remove-hooks global explore-buffers
  }

  # Interface
  # Show usage
  define-command -hidden explore-buffers-interface -params .. %{
    echo -markup '{keyword}alias{Default} {attribute}global{Default} explore-buffers {Error}command{Default}'
  }

  alias global explore-buffers explore-buffers-interface
}
