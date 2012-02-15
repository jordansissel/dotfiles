#!/bin/sh

# Fetch dotfiles
dotfiles() {
  echo "Fetching latest dotfiles"
  # Pull a tarball instead of doing git clone because I don't want $HOME/.git
  curl -Lso - https://github.com/jordansissel/dotfiles/tarball/master \
    | tar --exclude README.md --strip-components 1 -C $HOME -zvxf -
}

vim_plugin() {
  repo="$1"
  basedir="$HOME/.vim/bundle"
  name="$(basename ${repo%%.git})"
  dir="$basedir/$name"

  [ ! -d "$basedir" ] && mkdir -p "$basedir"

  if [ -d "$dir/.git" ] ; then
    echo "vim plugin: Updating $name"
    (cd $dir; git fetch; git reset --hard origin/master)
  else
    echo "vim plugin: Cloning $name"
    (cd $basedir; git clone $repo)
  fi
}

# Sync dotfiles
dotfiles
rm ~/bin/vim

# Sync vim plugins
vim_plugin https://github.com/mileszs/ack.vim.git
vim_plugin https://github.com/jordansissel/vim-ackmore.git
vim_plugin https://github.com/scrooloose/nerdtree.git
vim_plugin https://github.com/majutsushi/tagbar.git

# Compiling required for Command-T
vim_plugin https://github.com/wincent/Command-T.git
(
  cd $HOME/.vim/bundle/Command-T/ruby/command-t/
  ruby extconf.rb
  make
)

# I have a fork of ruby-matchit to make it a proper ftplugin
vim_plugin https://github.com/jordansissel/ruby-matchit.git

#rm -rf $HOME/.vim/bundle/conque_2.3
#vim_plugin https://github.com/jordansissel/conque

#vim_plugin https://github.com/vim-scripts/taglist.vim.git
rm -rf $HOME/.vim/bundle/taglist.vim

