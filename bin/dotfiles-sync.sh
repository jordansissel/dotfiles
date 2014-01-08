#!/bin/bash

if [ -d $HOME/jordansissel/ ]; then
        REPOHOME=$HOME/jordansissel
else
        echo "Couldn't find repo."
        exit
fi

if [ ! -e "${REPOHOME}/ssh/config" ] ; then
    echo problem with repo home
    echo
    exit
fi

e=1
if [ -d $HOME/.ssh ]; then
    SSHFROM="$HOME/.ssh-`date +%F`-${e}"
    while [ -d "${SSHFROM}" ]; do
        e=$((${e}+1))
        SSHFROM="$HOME/.ssh-`date +%F`-${e}"
    done
    mv -v $HOME/.ssh "${SSHFROM}" || true
fi
mkdir -p $HOME/.ssh 2> /dev/null

### SSH setup
for e in ${REPOHOME}/ssh/* ; do
        ln -vfs "${e}" ~/.ssh/
done
unset e

chmod 700 $HOME/.ssh/
chmod 600 -R ${REPOHOME}/ssh/*

for e in bash_profile zprofile zshenv vim vimrc aprc ackrc gernc gitconfig gtkrc-2.0 hushlogin screenrc config notion; do
     ln -svf "${REPOHOME}/${e}" "$HOME/.${e}"
done
for e in bin; do
     ln -svf "${REPOHOME}/${e}" "$HOME/.${e}"
done

ln -s ../../githooks/post-checkout $REPOHOME/.git/hooks
