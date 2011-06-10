# Aliases are so totally my friend
alias ls="ls -F"
alias status="cvs status | grep '^File:' | grep -v 'Up-to-date'"
which vim > /dev/null 2>&1 && alias vi=vim
alias vim="vim -p -X -u $HOME/.vimrc"
unalias rm mv cp 2> /dev/null # no -i madness
function loadrvm() {
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
}


export LANG=en_US.utf8

# Revision Control

# subversion doesn't have SVNROOT like cvs does... so
# this makes me have to type less when checking stuff out:
# svn checkout $SVNHOME/foo
alias svn.syn="SVNHOME=svn+ssh://jls@syn.csh.rit.edu/home/jls/SVNREPO"
SVNHOME="https://semicomplete.googlecode.com/svn/"

# Defaults
PSARGS=-ax

# Some useful defaults
HISTSIZE=1048576
SAVEHIST=$HISTSIZE
HISTFILE=~/.history_zsh

# I hate ls colors...
export LS_COLORS=

# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""

# Check if we're using screen, set our term to xterm...# UGLY BAD HACK
# I only need this on Solaris machines with screen(1) but no screen
# terminfo entry. I don't use it much anymore.
# Really, it should check if 'screen' is set and there is no screen terminfo
# then set TERM=xtemr.
#[ $TERM = "screen" ] && TERM=xterm

# Some environment defaults
export CVS_RSH=ssh
export RSYNC_RSH=ssh
export EDITOR=vim
export PAGER=less
export LESS="-nX"

## zsh options settings
setopt no_beep                   # Beeping is annoying. Die.
setopt no_prompt_cr              # Don't print a carraige return before the prompt 
setopt interactivecomments       # Enable comments in interactive mode (useful)
setopt extended_glob             # More powerful glob features

# history settings
setopt append_history            # Append to history on exit, don't overwrite it.
setopt extended_history          # Save timestamps with history
setopt hist_no_store             # Don't store history commands
setopt hist_save_no_dups         # Don't save duplicate history entries
#setopt hist_expire_dups_first
setopt hist_ignore_all_dups      # Ignore old command duplicates (in current session)

# These two history options don't flow with my history usage.
#setopt inc_append_history
#setopt share_history

# changing directories
setopt auto_pushd                # Automatically pushd when I cd
setopt nocdable_vars               # Let me do cd ~foo if $foo is a directory

# ksh addictions
setopt no_nomatch                # Don't error when there's nothing to glob, leave it unchanged
bindkey "\e_" insert-last-word
bindkey "\e*" expand-word
bindkey "\e=" list-expand
bindkey -r "\e/" # let the vi keymap pick this up

## zsh zle and bindings
bindkey -v                      # vi mode == win
bindkey "\e_" insert-last-word
bindkey "\e*" expand-word
bindkey "\e=" list-expand
bindkey -M vicmd k vi-up-line-or-history
bindkey -M vicmd j vi-down-line-or-history

# completion madness
compctl -g '*(-/D)' cd
compctl -g '*.ps' ghostview gv
compctl -g '*.pdf' acroread xpdf
compctl -g '/var/db/pkg/*(/:t)' pkg_delete pkg_info
compctl -j -P '%' kill bg fg
compctl -v export unset vared

function up {
  if [ "$#" -eq 0 ] ; then
    echo "Up to where?"
    return 1
  fi

  times=$1
  target="$2"
  while [ $times -gt 0 ] ; do
    target="../$target"
    times=$((times - 1))
  done
  cd $target
}

# Set up $PATH
function notinpath {
  for tmp in $path; do
    [ $tmp = $1 ] && return 1
  done

  return 0
}

function addpaths {
  for i in $*; do
    i=${~i}
    if [ -d "$i" ]; then
      notinpath $i && path+=$i
    fi
  done
}

function delpaths {
  for i in $*; do
    i=${~i}
    PATH="$(echo "$PATH" | tr ':' '\n' | grep -v "$i" | tr '\n' ':')"
  done
}

# Make sure things are in my paths
BASE_PATHS="/bin /usr/bin /sbin /usr/sbin"
X_PATHS="/usr/X11R6/bin /usr/dt/bin /usr/X/bin"
LOCAL_PATHS="/usr/local/bin /usr/local/gnu/bin"
SOLARIS_PATHS="/opt/SUNWspro/bin /usr/ccs/bin /opt/csw/bin"
HOME_PATHS="~/bin"
addpaths $=BASE_PATHS $=X_PATHS $=LOCAL_PATHS $=SOLARIS_PATHS $=HOME_PATHS
addpaths ~/projects/tools
addpaths /var/lib/gems/1.8/bin
addpaths /usr/local/jruby-1.5.2/bin
PATH="$HOME/bin:$HOME/local/bin:$PATH"


# Periodic Reminder!
PERIOD=3600                       # Every hour, call periodic()
function periodic() {
  [ -f ~/.plan ] || return

  echo
  echo "= Todo List"
  sed -e 's/^/   /' ~/.plan
  echo "= End"
}

# Completion
function screen-sessions {
  typeset -a sessions
  for i in /tmp/screens/S-${USER}/*(p:t);  do
    sessions+=(${i#*.})
  done

  reply=($sessions)
}

compctl -g '*(-/D)' cd 
compctl -c which
compctl -o setopt unsetopt
compctl -v export unset vared
compctl -g '/u9/psionic/Mail/*(/:t)' -P '+' folder
compctl -g '/var/db/pkg/*(/:t)' pkg_delete pkg_info
compctl -g '*.pdf' xpdf acroread
#compctl -g "/tmp/screens/S-${USER}/*(p:t)" + -g "/tmp/screens/S-${USER}/*(:e)" screen
#compctl -g "/tmp/screens/S-${USER}/*(p:tW:.:)" screen
compctl -K screen-sessions screen
compctl -g "*(-/D)" + -g "*.class(.:r)" java

# The Prompt
PS1='%m(%35<...<%~) %(?..!%?! )%# '
unset RPROMPT RPS1

# This section sets useful variables for various things...
HOST="$(hostname)"
HOST="${HOST%%.*}"
UNAME="$(uname)"

# title/precmd/postcmd
function precmd() {
  title "zsh - $PWD"
}

function preexec() {
  # The full command line comes in as "$1"
  local cmd="$1"
  local -a args

  # add '--' in case $1 is only one word to work around a bug in ${(z)foo}
  # in zsh 4.3.9.
  tmpcmd="$1 --"
  args=${(z)tmpcmd}

  # remove the '--' we added as a bug workaround..
  # per zsh manpages, removing an element means assigning ()
  args[${#args}]=()
  if [ "${args[1]}" = "fg" ] ; then
    local jobnum="${args[2]}"
    if [ -z "$jobnum" ] ; then
      # If no jobnum specified, find the current job.
      for i in ${(k)jobtexts}; do
        [ -z "${jobstates[$i]%%*:+:*}" ] && jobnum=$i
      done
    fi
    cmd="${jobtexts[${jobnum#%}]}"
  else
  fi
  title "$cmd"
}

function title() {
  # This is madness.
  # We replace literal '%' with '%%'
  # Also use ${(V) ...} to make nonvisible chars printable (think cat -v)
  # Replace newlines with '; '
  local value="${${${(V)1//\%/\%\%}//'\n'/; }//'\t'/ }"
  local location

  location="$HOST"
  [ "$USERNAME" != "$LOGNAME" ] && location="${USERNAME}@${location}"

  # Special format for use with print -Pn
  value="%70>...>$value%<<"
  unset PROMPT_SUBST
  case $TERM in
    screen)
      # Put this in your .screenrc:
      # hardstatus string "[%n] %h - %t"
      # termcapinfo xterm 'hs:ts=\E]2;:fs=\007:ds=\E]2;screen (not title yet)\007'
      print -Pn "\ek${value}\e\\"     # screen title (in windowlist)
      print -Pn "\e_${location}\e\\"  # screen location
      ;;
    xterm*)
      print -Pn "\e]0;$value\a"
      ;;
  esac
  setopt LOCAL_OPTIONS
}

function config_laptop() {
  export P4CLIENT=jls_nightfall
}

function config_csh() {
  alias which="/u9/psionic/bin/which"
}

# Host-based changes
case $HOST in
  fury|tempest) config_csh ;;
  thinktop|nightfall) config_laptop ;;
esac

function config_SunOS() {
  SUN_PATHS="/usr/ucb:/usr/ccs/bin:/opt/SUNWspro/bin"
  SUN_MANPATHS="/opt/SUNWspro/man:/usr/openwin/man"

  PATH="${PATH}:${SUN_PATHS}"
  MANPATH="${MANPATH}:${SUN_MANPATHS}"
  PSARGS=-ef
}

function config_FreeBSD() {
  PSARGS=-ax
}

function config_Linux() {
  PSARGS=ax
}

case $UNAME in
  FreeBSD) config_FreeBSD ;;
  SunOS) config_SunOS ;;
  Linux) config_Linux ;;
esac

## Useful functions

function psg() {
  ps $PSARGS | egrep "$@" | fgrep -v egrep
}

function findenv() {
  ps aexww | sed -ne "/$1/ { s/.*\($1[^ ]*\).*/\1/; p; }" | sort | uniq -c $2
}

function _awk_col() {
  echo "$1" | egrep -v '^[0-9]+$' || echo "\$$1"
}

function sum() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -eq 0 ] && set -- 0
  key="$(_awk_col "$1")"
  awk $SP "{ x+=$key } END { printf(\"%d\n\", x) }"
}

function sumby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -lt 0 ] && set -- 0 1
  key="$(_awk_col "$1")"
  val="$(_awk_col "$2")"
  awk $SP "{ a[$key] += $val } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
}

function countby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -eq 0 ] && set -- 0
  key="$(_awk_col "$1")"
  awk $SP "{ a[$key]++ } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
}

function bytes() {
  if [ $# -gt 0 ]; then
    while [ $# -gt 0 ]; do
      echo -n "${1}B = "
      byteconv "$1"
      shift
    done
  else
    while read a; do
      byteconv "$a"
    done
  fi
}

function byteconv() {
  a=$1
  ORDER=BKMGTPE
  while [ $(echo "$a >= 1024" | bc) -eq 1 -a $#ORDER -gt 1 ]; do
    a=$(echo "scale=2; $a / 1024" | bc)
    ORDER="${ORDER#?}"
  done
  echo "${a}$(echo "$ORDER" | cut -b1)"
}

function datelog() {
  [ $# -eq 0 ] && set -- "%F %H:%M:%S]"
  perl -MPOSIX -e 'while (sysread(STDIN,$_,1,length($_)) > 0) { while (s/^(.*?\n)//) { printf("%s %s", strftime($ARGV[0], localtime), $1); } }' "$@"
}

function pastebin() {
  curl --data-urlencode "paste_code@${1:--}" http://pastebin.com/api_public.php
  echo ""  # API doesn't return a newline
}

# Any special local config?
[ -r ~/.zshrc_local ] && . ~/.zshrc_local
