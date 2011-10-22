# Rather than set my shell to zsh, just exec zsh if we find it and we are an
# interactive / login shell. This is useful in the wide array of cases where
# you don't have root to install zsh or permissions to change your default
# shell.
which zsh > /dev/null 2>&1 && exec zsh -l
echo "No zsh found, sorry I couldn't save you..."
