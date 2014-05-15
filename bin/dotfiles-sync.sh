#!/bin/sh

umask 022

# Fetch dotfiles
dotfiles() {
  echo "Fetching latest dotfiles"
  # Pull a tarball instead of doing git clone because I don't want $HOME/.git
  curl -Lso - https://github.com/jordansissel/dotfiles/tarball/master \
    | tar --exclude README.md --strip-components 1 -C $HOME -zvxf -
}

# Sync dotfiles
git_it() {
  repo="$1"
  target="$2"
  name="$(basename ${repo%%.git})"
  if [ -d "$target/.git" ] ; then
    echo "Updating $name"
    (
      cd "$target"
      git fetch
      git reset --hard "origin/$(git branch | grep '^\* ' | cut -b 3-)"
    )
  else
    echo "Cloning $name"
    (cd "$(dirname $target)"; git clone "$repo" "$target")
  fi
}

git_it https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
dotfiles
chmod 600 ~/.ssh/*
chmod 700 ~/.ssh
rm ~/bin/vim

vimplugin-sync.sh
