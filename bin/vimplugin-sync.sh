#!/bin/sh

vim_plugin() {
  repo="$1"
  #basedir="$HOME/.vim/bundle"
  basedir="$HOME/.config/nvim/bundle"

  [ ! -d "$basedir" ] && mkdir -p "$basedir"

  case $repo in
    */scripts/download_script.php\?src_id=*)
      name="${repo##*src_id=}"
      dir="$basedir/$name"
      mkdir -p $dir/plugin/
      wget -O "$dir/plugin/$name.vim" "$repo"
      ;;
    *.git) 
      name="$(basename ${repo%%.git})"
      dir="$basedir/$name"
      if [ -d "$dir/.git" ] ; then
        echo "vim plugin: Updating $name"
        (
          cd $dir
          git fetch
          git reset --hard origin/$(git branch | grep '^\* ' | cut -b 3-)
        )
      else
        echo "vim plugin: Cloning $name"
        (cd $basedir; git clone $repo)
      fi
      ;;
  esac
}

purge() {
  [ -d "$HOME/.vim/bundle/$1" ] && rm -rf "$HOME/.vim/bundle/$1"
}

# Sync vim plugins
vim_plugin https://github.com/airblade/vim-gitgutter.git
#vim_plugin https://github.com/alfredodeza/posero.vim.git
#vim_plugin https://github.com/christoomey/vim-tmux-navigator.git
#vim_plugin https://github.com/myusuf3/numbers.vim.git 
#vim_plugin https://github.com/scrooloose/syntastic.git
vim_plugin https://github.com/tpope/vim-fugitive.git
#vim_plugin https://github.com/zhaocai/unite-tmux.git
vim_plugin https://github.com/Shougo/unite.vim.git
vim_plugin https://github.com/bling/vim-airline.git
vim_plugin https://github.com/scrooloose/nerdtree.git
vim_plugin https://github.com/gcmt/taboo.vim.git
vim_plugin https://github.com/tfnico/vim-gradle.git

# Snippets
#vim_plugin https://github.com/honza/vim-snippets.git
#vim_plugin https://github.com/sirver/ultisnips.git
purge ultisnips

purge "vim-powerline"
purge "vimproc"
purge "tagbar"
purge "vim-slime"
purge "vim-colors-solarized"
purge "vim-dispatch"
purge "vim-multiple-cursors"
purge "vim-gitgutter"
purge "emmet-vim"
#vim_plugin https://github.com/terryma/vim-multiple-cursors.git
#vim_plugin https://github.com/Shougo/vimproc.vim.git
#vim_plugin https://github.com/majutsushi/tagbar.git
#vim_plugin https://github.com/jpalardy/vim-slime.git
#vim_plugin https://github.com/altercation/vim-colors-solarized.git
#vim_plugin https://github.com/jnwhiteh/vim-golang.git
#vim_plugin https://github.com/vim-scripts/DrawIt.git
#vim_plugin https://github.com/pydave/AsyncCommand.git
#vim_plugin https://github.com/tpope/vim-unimpaired.git
#vim_plugin https://github.com/tpope/vim-dispatch.git

#make -C $HOME/.vim/bundle/vimproc.vim/ -f make_unix.mak

#vim_plugin "http://vim.sourceforge.net/scripts/download_script.php?src_id=4318"
purge "close_tag"
purge "Command-T"
purge "lusty"
purge "AsyncCommand"
purge "taglist.vim"
purge "conque_2.3"
purge "conque"
purge "ack.vim"
purge "vim-ackmore"
purge "DrawIt"

# I have a fork of ruby-matchit to make it a proper ftplugin
vim_plugin https://github.com/jordansissel/ruby-matchit.git
