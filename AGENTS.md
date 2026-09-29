# AGENTS.md

Dotfiles repo managed with GNU Stow. Every top-level, non-hidden directory is a **stow package**: its contents are symlinked into `$HOME` at the same relative path (e.g. `nvim/.config/nvim/...` → `~/.config/nvim/...`). Packages: `shell`, `nvim`, `tmux`, `herdr`, `ghostty`, `lazygit`, `zed`, `opencode`, `git`, `starship`.

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
- `opencode/.config/opencode/plugins/tmux-agent-sidebar.js` is a **relative** symlink into `~/.tmux/plugins/`, which TPM owns and rewrites. It climbs five levels to reach `$HOME`, so it only resolves when the repo sits at `~/dotfiles` (as `bootstrap.sh` and the `dotfiles` function assume). Link the file, not the directory — the bridge walks up from `import.meta.url` to find the plugin's `hook.sh`, and that only works if the runtime resolves the realpath. It dangles until TPM has installed the plugin (`prefix + I`) and unstowing `tmux` leaves it dangling, so the `opencode` package effectively depends on `tmux`.
- `herdr/.config/herdr/config.toml` is a plain stowed file, so Herdr's **settings UI can silently unlink the package**: it rewrites `config.toml` with an atomic rename, which replaces the symlink with a real file. Recovery is `dotfiles stow` (plus moving any locally edited copy aside, since stow then aborts on the real file). Prefer editing the repo file and running `herdr server reload-config` over using the settings panel. Validate with `herdr config check`. Herdr is not a distro package — `bootstrap.sh` installs it via `https://herdr.dev/install.sh`, deliberately bypassing the generic `install_package` path, which would fail on Fedora/Debian and nixpkgs.
- Herdr's prefix is `` ` `` (`§` alternate), chosen to match `tmux/.tmux.conf`. Key names in `[keys]` come from a fixed vocabulary: `backtick` and `§` validate, but `` "`" ``, `section`, and `grave` are rejected. Check with `herdr config check` rather than guessing.
- No tests, linter, or CI. Verify with `git diff` or a dry-run stow. Commit messages use Conventional Commits (`feat:`, `fix:`, `chore:`).
- Never `git add`, `git commit`, `git push`, or otherwise write to the index or history for the user — they stage and commit themselves. Commits here get pushed within seconds of being created, so treat any git write as publishing: only do it when explicitly asked.
