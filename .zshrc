alias ls="ls -F"
which vim > /dev/null 2>&1 && alias vi=vim
unalias rm mv cp 2> /dev/null || true # no -i madness

# Run vim with tabs enabled, no X11, and only load *my* vimrc.
alias vim="vim -p -X -u $HOME/.vimrc"

# Lots of command examples (especially heroku) lead command docs with '$' which
# make it kind of annoying to copy/paste, especially when there's multiple
# commands to copy.
#
# This hacks around the problem by making a '$' command that simply runs
# whatever arguments are passed to it. So you can copy
#   '$ echo hello world'
# and it will run 'echo hello world'
function \$() { 
  "$@"
}

function sufferanguishandloadrvm() {
  if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
    . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
    rvm use default > /dev/null 2>&1
  fi
}

# make git run hub, but only in the 'default' rvm (ruby 1.9.3 usually)
if which hub > /dev/null 2>&1 && which rvm > /dev/null 2>&1; then
  function git() {
    rvm default do =hub "$@"
  }
fi

# run vim outside the current rvm ruby. This avoids long startup
# if our selected ruby is JRuby.
# Note: On some systems, if you background vim (^Z) while running it in
# this way, 'fg' will always hang. I don't know why. It seems to be
# a bug on zsh and OS X.
if which rvm > /dev/null 2>&1 ; then
  function vim() {
    rvm default do =vim -p -X -u $HOME/.vimrc "$@"
  }
fi

function loadvirtualenv() {
  . "$HOME/.venvburrito/startup.sh"
}

export LANG=en_US.UTF-8

# Bundler behaves quite badly. Sometimes it writes the flags/config for the
# current invocation to ./.bundle/config, and any future 'bundle install' 
# invocations have their flags ignored, which is pretty dumb and causes
# me great pain. To fix that, let's always purge .bundle before running
# bundler.
alias bundle='rm -rf .bundle; bundle'

# Defaults
PSARGS=-ax

# Some useful defaults
HISTSIZE=1048576
SAVEHIST=$HISTSIZE
HISTFILE=~/.history_zsh

# For some reason, golang doesn't have smart defaults. For pretty much every
# invocation, I have to set 'GOPATH=$PWD' in environment. So this is a nice
# hack to fix that problem:
# This was supposed to get fixed before Go 1, but it was not: 
# http://groups.google.com/group/golang-nuts/browse_thread/thread/d97f06aca4e5a722/91b55924ae0685b8?show_docid=91b55924ae0685b8
# This was previously /proc/self/cwd, but 'go build' changes directory, so now
# it needs to be the working directory of the shell, not of 'go build'
#export GOPATH=/proc/$$/cwd
function golang_is_very_disappointing_or_i_am_missing_something_obvious() {
  # OSX has no /proc so my previous use of /proc/$$/cwd doesn't work.
  export GOPATH="${PWD}"
}

# I hate ls colors...
export LS_COLORS=

# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""

# Some environment defaults
export RSYNC_RSH=ssh
export EDITOR=vim
export PAGER=less
export LESS="-nXR"

## zsh options settings
setopt no_beep                   # Beeping is annoying. Die.
setopt no_prompt_cr              # Don't print a carraige return before the prompt 
setopt interactivecomments       # Enable comments in interactive mode (useful)
setopt extended_glob             # More powerful glob features
setopt append_history            # Append to history on exit, don't overwrite it.
setopt extended_history          # Save timestamps with history
setopt hist_no_store             # Don't store history commands
setopt hist_save_no_dups         # Don't save duplicate history entries
setopt hist_ignore_all_dups      # Ignore old command duplicates (in current session)
setopt no_inc_append_history
setopt no_share_history
setopt auto_pushd                # Automatically pushd when I cd
setopt nocdable_vars

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
addpaths /opt/vagrant/bin
addpaths ~/projects/tools
addpaths /var/lib/gems/1.8/bin
addpaths ~/gentoo/bin ~/gentoo/usr/bin
PATH="$HOME/bin:$HOME/local/bin:$PATH"
export GOROOT=$HOME/go
addpaths $GOROOT/bin

for i in $HOME/node_modules/*/bin ; do
  addpaths $i
done

# completion madness
compctl -g '*.ps' ghostview gv
compctl -g '*.pdf' acroread xpdf
compctl -j -P '%' kill bg fg
compctl -g '*(-/D)' cd 
compctl -c which
compctl -o setopt unsetopt
compctl -v export unset vared
compctl -g '/var/db/pkg/*(/:t)' pkg_delete pkg_info
compctl -g '*.pdf' xpdf acroread
compctl -g "*(-/D)" + -g "*.class(.:r)" java

autoload -U colors
colors

# The Prompt
setopt promptsubst
PS1=$'${fg[cyan]}⓿${reset_color} ${fg[yellow]}%m${fg[magenta]}(%55<...<%~)${reset_color}${git_prompt} %(?..!%?! )\n%# '
unset RPROMPT RPS1

function refresh_git() {
  git_branch="$(git_branch)"
  git_status="$(parse_git_dirty)"

  # For use in shell
  b="$git_branch"

  if =git rev-parse >& /dev/null ; then
    if [ "$git_status" = "dirty" ] ; then
      git_prompt=" ${fg[red]}${git_branch}${reset_color}"
    else
      git_prompt=" ${fg[green]}${git_branch}${reset_color}"
    fi
  else
    git_prompt=""
  fi
}

function git_branch() {
  # Derived from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh
  ref=$(=git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(=git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref##refs/heads/}"
}

# Derived from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh
function parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  local GIT_STATUS=''
  local CLEAN_MESSAGE='nothing to commit (working directory clean)'
  if [[ "$(=git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      SUBMODULE_SYNTAX="--ignore-submodules=dirty"
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      GIT_STATUS=$(=git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
    else
      GIT_STATUS=$(=git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
    fi
    if [[ -n $GIT_STATUS ]]; then
      echo dirty
    else
      echo clean
    fi
  else
    echo clean
  fi
}

# This section sets useful variables for various things...
HOST="$(hostname)"
HOST="${HOST%%.*}"
UNAME="$(uname)"

# title/precmd/postcmd
function precmd() {
  title "zsh - $PWD"
  duration=$(( $(date +%s) - cmd_start_time ))

  # Notify if the previous command took more than 5 seconds.
  if [ $duration -gt 5 ] ; then
    case "$lastcmd" in
      vi*) ;; # vi, don't notify
      "") ;; # no previous command, don't notify
      *) 
        [ ! -z "$TMUX" ] && tmux display-message "($duration secs): $lastcmd"
    esac
  fi

  golang_is_very_disappointing_or_i_am_missing_something_obvious

  lastcmd=""
  refresh_git
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
  fi

  # These are used in precmd
  cmd_start_time=$(date +%s)
  lastcmd="$cmd"

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
    screen|screen-256color)
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

# Find an environment variable in all processes and show the unique values
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
  awk $SP "{ x+=$key } END { printf(\"%f\n\", x) }"
}

function sumby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -lt 0 ] && set -- 0 1
  key="$(_awk_col "$1")"
  val="$(_awk_col "$2")"
  awk $SP "{ a[$key] += $val } END { for (i in a) { printf(\"%f %s\\n\", a[i], i) } }"
}

function countby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -eq 0 ] && set -- 0
  key="$(_awk_col "$1")"
  awk $SP "{ a[$key]++ } END { for (i in a) { printf(\"%f %s\\n\", a[i], i) } }"
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

# From petef's zshrc.
# Make scp error if I forget to specify a remote host target.
function scp() {
  found=false
  for arg; do
    if [ "${arg%%:*}" != "${arg}" ]; then
      found=true
      break
    fi
  done

  if ! $found; then
    echo "scp: no remote location specified" >&2
    return 1
  fi

  =scp "$@"
}

# section grep. Greps for text in sections of text delimited by blank lines.
function sgrep() {
  re="$1"
  shift
  [ "$#" -eq 0 ] && set -- -
  sed -rne '/^$/!H; /^$/ { x; /'"$re"'/p; }; ${ x; /'"$re"'/p; d; } ' "$@"
}

# Git tab completion is horrible and slow. Disable it.
# Found here: http://stackoverflow.com/a/9810612
compdef -d git

sufferanguishandloadrvm
# Make rvm STFU about path warnings.
rvm use >& /dev/null
