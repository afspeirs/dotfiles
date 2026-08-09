# AGENTS.md

Dotfiles repo managed with GNU Stow. Every top-level, non-hidden directory is a **stow package**: its contents are symlinked into `$HOME` at the same relative path (e.g. `nvim/.config/nvim/...` → `~/.config/nvim/...`). Packages: `shell`, `nvim`, `tmux`, `ghostty`, `lazygit`, `zed`, `opencode`, `git`, `starship`.

## Layout

- `bootstrap.sh` — interactive install: prompts for each package (reads `/dev/tty`), detects OS, installs deps (apt/dnf/yay/brew), stows selections, adds the loader hook to `.zshrc`/`.bashrc`. `-d`/`--dry-run` previews without changing anything.
- `.stowed_packages` — gitignored, untracked local state of previously selected packages. Never commit it.
- `README.md`, `LICENSE`, `bootstrap.sh`, and hidden dirs (`.git`, `.github`) are not stow packages.

## Commands

- `./bootstrap.sh` — interactive; requires a TTY and prompts per package. Prefer `dotfiles stow` if you need non-interactive restow.
- `dotfiles stow` — non-interactive `stow --restow --target="$HOME" <pkg>` for each package in `.stowed_packages` (the `dotfiles` function is provided by the `shell` package).
- Manual: `stow --restow --target="$HOME" <pkg>`

## Gotchas

- **Creating any non-hidden top-level directory turns it into a stow package** (`bootstrap.sh` auto-discovers them via `find . -maxdepth 1 -type d ! -name '.*'`). New config files go under `<pkg>/` at a path relative to `$HOME`.
- New zsh helper → `shell/.zshrc.d/functions/<name>.zsh`: exactly one function named after the file, supporting `-h` help. These are auto-listed by `dotfiles -h` (which excludes `dotfiles` and `exists`).
- `git/.gitconfig` is a personal **global** gitconfig (user identity, difftool, editor). Machine-specific overrides belong in `~/.gitconfig.local`; `*.local` is gitignored, so never commit identity or machine-specific values.
- Image diffs route through the `imagediff` difftool (wired via `git/.gitattributes`), which shells into a zsh function; it only works in an interactive zsh.
- nvim uses lazy.nvim with a committed `lazy-lock.json` of pinned plugin versions. zed keymaps deliberately mirror nvim — keep them in sync (recent commits show this pattern).
- Shell load order: `~/.zshrc` → `~/.zshrc.d/loader.zsh` (functions → aliases → prompt → zsh options → completions) → `~/.dotfiles_loader.local.sh` for machine-local overrides.
- No tests, linter, or CI. Verify with `git diff` or a dry-run stow. Commit messages use Conventional Commits (`feat:`, `fix:`, `chore:`).
