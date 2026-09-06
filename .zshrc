# mise, and the tools it manages (starship, gh, ghq, gwq, fzf), live under ~/.local/bin.
# macOS zsh doesn't add this to PATH by default, so it must be set explicitly here.
export PATH="$HOME/.local/bin:$PATH"

# apply tools
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(mise completion zsh)"
source <(gwq completion zsh)
source <(fzf --zsh)

# get repo list
function ghq-fzf() {
  local repo=$(ghq list | fzf --query="$1")
  if [ -n "$repo" ]; then
    cd "$(ghq root)/$repo"
  fi
}
alias r=ghq-fzf

# create branch
function gwq-fzf() {
  local repo=$(ghq list | fzf --query="$1")
  if [ -z "$repo" ]; then return; fi

  local repo_path=$(ghq root)/$repo
  cd "$repo_path"

  echo -n "New branch name: "
  read branch
  if [ -z "$branch" ]; then
    echo "キャンセルしました"
    return
  fi

  gwq add -b "$branch" -s

  # 元のworktreeから.envをすべてコピー
  local new_path="$(ghq root)/${repo}=${branch}"
  local copied=0
  while IFS= read -r env_file; do
    local relative="${env_file#${repo_path}/}"
    local dest="${new_path}/${relative}"
    mkdir -p "$(dirname "$dest")"
    cp "$env_file" "$dest"
    copied=$((copied + 1))
  done < <(find "${repo_path}" -name ".env" -not -path "*/.git/*")
  if [ "$copied" -gt 0 ]; then
    echo ".env を ${copied} 件コピーしました"
  fi
}
alias wc=gwq-fzf

# remove branch
alias wr="gwq remove -b"

# prune directory
alias wp="gwq prune"

# git shortcut
alias g="git"

# mise shortcut
alias mr="mise run"

# open cursor
alias c="cursor ."
