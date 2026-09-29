# Zsh completion script for custom dotfiles functions

_dotfiles_completion() {
  local -a subcommands
  subcommands=(
    "bootstrap:Install dependencies and make sure device is set up for use with the dotfiles repo"
    "open:Open the dotfiles repo in VS Code or navigates to it"
    "pull:Pull the latest changes from the dotfiles repo"
    "reload:Reload the shell"
    "stow:re-link dotfiles repo files"
  )
  _describe "dotfiles commands" subcommands
}

_ip_completion() {
  local -a subcommands
  subcommands=(
    "local:Display local private IPv4 address"
    "public:Display public IPv4 address"
  )
  _describe "ip commands" subcommands
}

_folder_completion() {
  _files -/
}

_files_completion() {
  _files
}

# Completes the labels of the workspaces herdr currently has open, so
# `h <TAB>` jumps to an active space.
_h_workspace_completion() {
  local -a labels

  labels=("${(@f)$(_h_workspace_labels)}")

  if [[ ${#labels[@]} -eq 0 ]]; then
    _message "no herdr workspaces"
    return 1
  fi

  # compadd rather than _describe: labels may contain a colon, which
  # _describe would read as a value:description separator. -J names the
  # group shown in the completion listing; -Q disables quoting.
  compadd -Q -J workspaces -a labels
}

compdef _dotfiles_completion dotfiles
compdef _ip_completion ip
compdef _folder_completion o each_folder video_compress_all zipper
compdef _files_completion remove_quarantine underscore_files video_compress
compdef _h_workspace_completion h

# Disable completion for these commands
compdef _nothing exists gc yt
