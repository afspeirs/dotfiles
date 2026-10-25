# AGENTS.md

Dotfiles repo managed with GNU Stow. Every top-level, non-hidden directory is a **stow package**: contents are symlinked into `$HOME` at the same relative path.

## Layout

- `bootstrap.sh` — interactive install: prompts per package, detects OS, installs deps (apt/dnf/yay/brew), stows selections, adds loader hook to `.zshrc`/`.bashrc`. `-d/--dry-run` previews without changes.
- `.stowed_packages` — gitignored, untracked local state of selected packages. Never commit it.
- `README.md`, `LICENSE`, `bootstrap.sh`, and hidden dirs (`.git`, `.github`) are not stow packages.

## Commands

- `./bootstrap.sh` — interactive; requires TTY. Prefer `dotfiles stow` for non-interactive restow.
- `dotfiles stow` — non-interactive `stow --restow --target="$HOME" <pkg>` for each package in `.stowed_packages`.
- Manual: `stow --restow --target="$HOME" <pkg>`

## Gotchas

- **New top-level non-hidden directory → stow package**. Config files go under `<pkg>/` at path relative to `$HOME`.
- New zsh helper → `shell/.zshrc.d/functions/<name>.zsh` with `-h` help. Listed by `dotfiles -h` (excludes `dotfiles`, `exists`).
- `git/.gitconfig` is personal global gitconfig (identity, difftool, editor). Machine-specific overrides in `~/.gitconfig.local`; `*.local` is gitignored.
- Image diffs route through `imagediff` difftool (`git/.gitattributes`), shells into zsh function; only works in interactive zsh.
- nvim uses lazy.nvim with committed `lazy-lock.json`. Zed keymaps mirror nvim — keep them in sync.
- Shell load order: `~/.zshrc` → `~/.zshrc.d/loader.zsh` (functions → aliases → prompt → options → completions) → `~/.dotfiles_loader.local.sh`.
- `opencode/.config/opencode/plugins/tmux-agent-sidebar.js` is a relative symlink into `~/.tmux/plugins/`. Only resolves when repo sits at `~/dotfiles`. Opencode depends on tmux being installed first.
- `herdr/.config/herdr/config.toml` can be silently replaced by Herdr's settings UI (atomic rename). Prefer editing repo file + `herdr server reload-config`; validate with `herdr config check`. Not a distro package — installs via `https://herdr.dev/install.sh`.
- Herdr key prefix is `` ` `` (`§`). Use `herdr config check` to verify; don't guess.
- No tests, linter, or CI. Verify with `git diff` or dry-run stow. Commits use Conventional Commits (`feat:`, `fix:`, `chore:`).
- Never `git add/commit/push` — you stage and commit yourself. These commits are pushed within seconds, so treat them as publishing; only do git writes when explicitly asked.
