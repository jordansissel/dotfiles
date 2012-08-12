#!/bin/sh

# Fetch dotfiles
dotfiles() {
  echo "Fetching latest dotfiles"
  # Pull a tarball instead of doing git clone because I don't want $HOME/.git
  curl -Lso - https://github.com/jordansissel/dotfiles/tarball/master \
    | tar --exclude README.md --strip-components 1 -C $HOME -zvxf -
}

# Sync dotfiles
dotfiles
rm ~/bin/vim

vimplugin-sync.sh
chmod 644 ~/.ssh/config
