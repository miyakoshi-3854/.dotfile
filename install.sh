#!/bin/bash

set -euo pipefail

# ── Install mise ──────────────────────────────────────────────────────────────
if ! command -v mise &>/dev/null; then
  echo "Installing mise..."
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "mise: already installed"
fi

# ── Clone dotfiles ────────────────────────────────────────────────────────────
DOTFILE_DIR="$HOME/ghq/github.com/miyakoshi-3854/dotfiles"

if [ ! -d "$DOTFILE_DIR" ]; then
  echo "Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILE_DIR")"
  git clone "https://github.com/miyakoshi-3854/dotfiles.git" "$DOTFILE_DIR"
else
  echo "dotfiles: already cloned"
fi

cd "$DOTFILE_DIR"

# ── Symlinks ──────────────────────────────────────────────────────────────────
link() {
  local src="$DOTFILE_DIR/$1"
  local dest="$HOME/$1"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "backup: $backup"
  fi
  ln -sfn "$src" "$dest"
  echo "linked: $dest"
}

link .zshrc
link .config/git/config
link .config/gh/config.yml
link .config/mise/config.toml
link .config/gwq/config.toml

# ── Git identity ──────────────────────────────────────────────────────────────
GIT_LOCAL_CONFIG="$HOME/.config/git/config.local"
if [ ! -e "$GIT_LOCAL_CONFIG" ]; then
  echo ""
  read -rp "Git user.name: " git_user_name
  read -rp "Git user.email: " git_user_email
  cat >"$GIT_LOCAL_CONFIG" <<EOF
[user]
    name = $git_user_name
    email = $git_user_email
EOF
  echo "created: $GIT_LOCAL_CONFIG"
else
  echo "Git identity: already configured"
fi

# ── mise install ──────────────────────────────────────────────────────────────
echo "Running mise install..."
mise install

echo ""
echo "Done!"
