# Rather than set my shell to zsh, exec zsh if we find it and we are 
# an interactive / login shell.
which zsh > /dev/null 2>&1 && exec zsh -l


