provide-module explore-buffers %{
  define-command explore-buffers-enable -docstring 'Enable explore-buffers' %{
    hook -group explore-buffers global RuntimeError "\d+:\d+: '(buffer|b)' wrong argument count" %{
      echo -markup '{Information}explore-buffers{Default}'
      explore-buffers
    }
  }
  define-command explore-buffers-disable -docstring 'Disable explore-buffers' %{
    remove-hooks global explore-buffers
  }
  # Show a template as fallback
  define-command -hidden explore-buffers-default -params .. %{
    echo -markup '{keyword}alias{Default} {attribute}global{Default} explore-buffers {Error}command{Default}'
  }
  alias global explore-buffers explore-buffers-default
}
