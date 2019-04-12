alias ls="ls -F"
unalias rm mv cp 2> /dev/null || true # no -i madness

alias gradle='if [ -f "./gradlew" ] ; then ./gradlew "$@"; else; \gradle "$@"; fi' -

function has() {
  which "$@" > /dev/null 2>&1
}

if has vim ; then
  alias vi=vim
fi

if has nvim ; then
  alias vim="nvim"
else
  # Run vim with no X11 and only load *my* vimrc.
  alias vim="vim -X -u $HOME/.vimrc"
fi

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

function loadrbenv() {
  if [ -d "$HOME/.rbenv/bin" ] ; then
    if ! which rbenv > /dev/null 2>&1 ; then
      PATH="${PATH}:$HOME/.rbenv/bin"
      eval "$(rbenv init -)"
      rbenv shell 2.5.1
    fi
  fi
}

function setupcargo() {
  if [[ -s "$HOME/.cargo/env" ]] ; then
    . "$HOME/.cargo/env"
  fi
}

function loadvirtualenv() {
  . "$HOME/.venvburrito/startup.sh"
}

# Defaults
PSARGS=-ax

# Some useful defaults
HISTSIZE=1048576
SAVEHIST=$HISTSIZE
HISTFILE=~/.history_zsh


# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""

# Some environment defaults
export LANG=en_US.UTF-8
export LS_COLORS= # I hate ls colors...
export RSYNC_RSH=ssh
export PAGER=less
export LESS="-nXR"
export GOPATH="${HOME}/projects/go"

if has nvim ; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

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
bindkey "^R" history-incremental-search-backward
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
addpaths /usr/local/heroku/bin
addpaths /var/lib/gems/1.8/bin
addpaths ~/gentoo/bin ~/gentoo/usr/bin
PATH="$HOME/bin:$HOME/local/bin:$PATH"
#export GOROOT=$HOME/go
#addpaths $GOROOT/bin

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

function precmd() {
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

  lastcmd=""
  refresh_git
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

# Fun powershell vm stuff

function host-powershell() {
  # Send our command over ssh, but escaped/quoted.
  # ${@:q} will produce an escaped eval-friendly text from the args array,
  # and the gs/\\/\`/ will replace backslash with backtick (powershell's escape char)

  host-ssh ". ../jls.FRIENDSHIP/documents/windows*/microsoft*.ps1; ${@:q:gs/\\/\`/}" 2> /dev/null
}

function host-powershell-stdin() {
  # Send our command over ssh, but escaped/quoted.
  # ${@:q} will produce an escaped eval-friendly text from the args array,
  # and the gs/\\/\`/ will replace backslash with backtick (powershell's escape char)

  host-ssh powershell -File -
}

function host-ssh() {
  #echo "host-ssh"
  #echo "Args: $#"
  #echo "${@}"
  ssh "${SSH_CONNECTION%% *}" "$@"
}

function get-vm() {
  host-powershell "get-vm" "$@"
}

function clone-vm() {
  host-powershell "clone-vm" "$@"
}

function get-vmipv6address() {
  echo ". ../jls.FRIENDSHIP/documents/windows*/microsoft*.ps1; get-vm ${@:q:gs/\\/\`/} | get-vmipv6address"  \
    | host-powershell-stdin
}

function connect-vm() {
  address="$(get-vmipv6address "$@" | tr -d '\r\n')"
  interface="$(echo "$SSH_CONNECTION" | fex '1%2')"

  echo ssh "${address}%${interface}"
  ssh "${address}%${interface}"
}

loadrbenv

export NVM_DIR="/home/jls/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

function awsmfa() {
  eval "$(awsmfa_shell "$@")"
  aws sts get-caller-identity
}

function awsmfa_shell() {
  if [ -z "$MFA_ARN" ] ; then
    echo "Missing \$MFA_ARN. Cannot continue."
    return 1
  fi

  if [ "$#" -eq 0 ] ; then
    read token?"MFA Token: "
  else
    token="$1"
  fi

  (
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN;
    aws sts get-session-token --serial-number $MFA_ARN --token-code $token \
    | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\"\(.AccessKeyId)\" AWS_SECRET_ACCESS_KEY=\"\(.SecretAccessKey)\" AWS_SESSION_TOKEN=\"\(.SessionToken)\""'
  )
}


[ -s "$HOME/.zshrc_private" ] && . "$HOME/.zshrc_private"
