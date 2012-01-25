# Fetch dotfiles
dotfiles() {
  # Pull a tarball instead of doing git clone because I don't want $HOME/.git
  curl -Lso - https://github.com/jordansissel/dotfiles/tarball/master \
    | tar --strip-components 1 -C $HOME -zvxf -
}

vim_plugin() {
  repo="$1"
  basedir="$HOME/.vim/bundle"
  name="$(basename ${repo%%.git})"
  dir="$basedir/$name"

  [ ! -d "$basedir" ] && mkdir -p "$basedir"

  if [ -d "$dir/.git" ] ; then
    echo "Updating $name"
    (cd $dir; git fetch; git reset --hard origin/master)
  else
    echo "Cloning $name"
    (cd $basedir; git clone $repo)
  fi
}

# Sync dotfiles
dotfiles

# Sync vim plugins
vim_plugin https://github.com/mileszs/ack.vim.git
vim_plugin https://github.com/jordansissel/vim-ackmore.git
