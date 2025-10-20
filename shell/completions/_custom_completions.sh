# Zsh completion script for custom dotfiles functions

_dotfiles_completion() {
    local -a subcommands
    subcommands=(
        "open:Open the dotfiles repo in VS Code or navigates to it"
        "pull:Pull the latest changes from the dotfiles repo"
        "reload:Reload the shell"
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

compdef _dotfiles_completion dotfiles
compdef _ip_completion ip
compdef _folder_completion o each_folder video_compress_all zipper
compdef _files_completion remove_quarantine underscore_files video_compress

# Disable completion for these commands
compdef _nothing exists gc yt
