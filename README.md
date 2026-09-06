# dotfiles

Personal dotfiles for WSL2 / macOS.

## Directory Structure

```
dotfiles/
├── .config/
│   ├── gh/config.yml
│   ├── git/config
│   ├── gwq/config.toml
│   └── mise/config.toml
├── .zshrc
└── install.sh
```

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/miyakoshi-3854/dotfiles/main/install.sh | bash && source ~/.zshrc
```

This single command will:

1. Install [mise](https://mise.jdx.dev) (if not already installed)
2. Install [ghq](https://github.com/x-motemen/ghq) and clone this repo
3. Symlink config files to `$HOME`
4. Prompt for your Git `user.name` / `user.email` and save them to `~/.config/git/config.local` (untracked, included from `.config/git/config`)
5. Install all tools via `mise install`

| Tool | Description |
|------|-------------|
| [starship](https://starship.rs) | Shell prompt |
| [gh](https://cli.github.com) | GitHub CLI |
| [ghq](https://github.com/x-motemen/ghq) | Git repository manager |
| [gwq](https://github.com/d-kuro/gwq) | Git worktree manager |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |

## Notes

- `wc` (`gwq-fzf`) creates a new worktree and automatically copies all `.env` files from the original worktree into it. Be aware that this includes any secrets stored in those files.
