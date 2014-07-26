How to enjoy:

    (umask 022; curl -Lso - https://github.com/jordansissel/dotfiles/tarball/master \
    | tar --strip-components 1 -C $HOME -zvxf -)
