provide-module explore %{
  # Modules
  require-module explore-files
  require-module explore-buffers

  # Enable explore
  define-command explore-enable -docstring 'Enable explore' %{
    explore-files-enable
    explore-buffers-enable
  }

  # Disable explore
  define-command explore-disable -docstring 'Disable explore' %{
    explore-files-disable
    explore-buffers-disable
  }
}
