# dotfiles

This directory contains the dotfiles for my system.

## Installation

To get started, you can run the `bootstrap.sh` script directly from the repository. This will clone the repository to `~/dotfiles` if it doesn't exist, and then proceed with the setup.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/afspeirs/dotfiles/main/bootstrap.sh)"
```

### Dependencies

The script checks for the following dependencies:

- `ffmpeg`
- `ghostty`
- `git`
- `herdr`
- `neovim`
- `stow`
- `yt-dlp`

### Stow the Dotfiles

This repository uses `stow` to create symlinks for the dotfiles.

```bash
stow loader
```

### Source the Loader Script

The `bootstrap.sh` script will attempt to automatically configure your shell (`.bashrc` or `.zshrc`) to source the `.dotfiles_loader.sh` file. If the script cannot detect your shell or if you prefer to do it manually, add the following to your shell's configuration file:

```bash
# Start dotfiles loader
if [ -f "$HOME/.dotfiles_loader.sh" ]; then
  source "$HOME/.dotfiles_loader.sh"
fi
# End dotfiles loader
```

## Tmux Agent Sidebar

The `tmux` package installs [`tmux-agent-sidebar`](https://hiroppy.github.io/tmux-agent-sidebar/) through TPM, and the `opencode` package wires up the OpenCode bridge so the sidebar sees prompts, tool calls, and session status.

Both packages must be stowed, and the plugin must be installed before the bridge link resolves:

```bash
stow tmux opencode
tmux source ~/.tmux.conf
```

Then press `prefix + I` to let TPM install the plugin (its binary installer runs on first load), and restart OpenCode so it discovers the bridge.

- Toggle the sidebar with `prefix + e`, or `prefix + E` for every window.
- New worktrees are spawned with OpenCode (`n`), since `tmux/.tmux.conf` sets `@agent-sidebar-default-agent opencode`.
- Appearance is themed to the Catppuccin Mocha palette via `@sidebar_color_*` options in `tmux/.tmux.conf`.
- Nord palettes are retained as fallbacks: set `palette = "nord"` in `starship/.config/starship.toml`; for tmux, uncomment the Nord block and comment the Catppuccin Mocha values in `tmux/.tmux.conf`.

## Herdr

[Herdr](https://herdr.dev) is an agent-aware terminal multiplexer: a single Rust binary that runs in your existing terminal, keeps sessions alive across detach, and shows every coding agent's state (`working`, `blocked`, `done`) in a sidebar.

The `herdr` package carries `herdr/.config/herdr/config.toml`, which sets the prefix to `` ` `` (with `§` as an alternate) to match tmux, plus the Catppuccin Mocha theme, symbol status indicators, and terminal-delivered notifications. It is not a distro package, so `bootstrap.sh` installs it with the official script when it is missing.

Both `herdr` and `opencode` must be stowed for agent state reporting to work:

```bash
stow herdr opencode
herdr server reload-config
```

If `~/.config/herdr/config.toml` already exists as a real file, `stow` will refuse to overwrite it. Move it aside once before stowing:

```bash
mv ~/.config/herdr/config.toml ~/.config/herdr/config.toml.bak
```

- Start or reattach with `herdr`. Detach with `prefix + q`; stop the server with `herdr server stop`.
- The prefix is `` ` ``, **not** `ctrl+b`. Press `prefix + ?` for the live keybind list.
- Validate config changes with `herdr config check`, then apply them with `herdr server reload-config`.
- Report agent state with `herdr integration install opencode`, and inspect integrations with `herdr integration status`. The generated bridge is gitignored and safe to reinstall.
- To return Herdr to Nord, set `name = "nord"`, replace the Catppuccin overrides with the commented Nord overrides in `herdr/.config/herdr/config.toml`, then run `herdr server reload-config`.
- Ghostty can switch back with `theme = Nord`; Zed with `"theme": "Nord Dark"`.
- In Neovim, set `enabled = false` in `plugins/catppuccin.lua`, remove that setting or set `enabled = true` in `plugins/nord.lua`, then run `:Lazy sync`.
- **Heads up:** changing settings from inside Herdr's settings panel rewrites `config.toml` with an atomic rename, which replaces the stow symlink with a real file and silently unlinks the package. If that happens, run `dotfiles stow` to restore the link.

## Platform-Specific Instructions

### Windows

If you are on Windows, you cannot use `stow` (unless you are using WSL). Since there is just a `.dotfiles_loader.sh` file, you can create a symbolic link.

As an administrator, run the below script, making sure to update the paths to be correct for your computer:

```bash
mklink "\Users\<USERNAME>\.dotfiles_loader.sh" "\Users\<USERNAME>\PATH\TO\FOLDER\dotfiles\loader\.dotfiles_loader.sh"
```
