# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Add Python user bin
export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

# SU
#export CWPROOT=~/SU
#export PATH=$PATH:$CWPROOT/bin

# Intel compiler
# source /opt/intel/bin/compilervars.sh intel64
if [ -f /opt/intel/oneapi/setvars.sh ]; then
  alias iintel='source /opt/intel/oneapi/setvars.sh intel64'
else
  alias iintel='echo "OneAPI not installed"'
fi

# Gurobi
export GUROBI_HOME="/opt/gurobi1000/linux64"
export PATH="${PATH}:${GUROBI_HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"

# Flutter
# export PATH="$PATH:~/development/flutter/bin"

# Ruby Gems
# export GEM_HOME="$HOME/.local/gems"
# export PATH="$PATH:$GEM_HOME/bin"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# colors codes
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
yellow2=$(tput setaf 190)
blue=$(tput setaf 4)
blue2=$(tput setaf 12)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
silver=$(tput setaf 7)
grey=$(tput setaf 8)
pink=$(tput setaf 9)
default=$(tput sgr0)



# user config
if [ $UID == 0 ]; then
  ucolor=$red
else
  ucolor=$yellow
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

get_current_dir() {
  dcolor=${1-'default'}
  pcolor=${2-'default'}
  pwd|awk -F/ -v n="$(tput cols)" -v h="^$HOME" -v u="$(echo $USER@$HOSTNAME|cut -d . -f 1)" -v r="${!pcolor}" -v d="${!dcolor}" \
    '{sub(h,"~"); n=n-length(u)-8;} length($0)<=n || NF==2 {print d$0; exit;} \
    NF>2 {b=d$1"/"$2"/"r".."d"/"; e=$NF; n=n-length(b e)+length(d r d); for (i=NF-1; i>2; i--) \
    {n-=length($i)+1; if (n < 0) break; e=$i"/"e}} {print b e;}'
}
if [ "$color_prompt" = yes ]; then
  PS1="\[${blue2}\]╭─(\[${ucolor}\]\u\[${blue2}\]@\[${silver}\]\h\[${blue2}\])-[\$(get_current_dir 'green' 'red')\[${blue2}\]]\n\[${blue2}\]╰─(\[${yellow2}\]\$(date +%H:%M)\[${blue2}\])>\[${default}\] "
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1="╭─(\u@\h)-[\$(get_current_dir)]\n╰─(\$(date +%H:%M))> "
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alvFh --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
#alias dualscreen="xrandr --setprovideroutputsource modesetting 0; xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --scale 1x1 --output LVDS-1-1 --mode 1366x768 --scale 1x1 --pos 1920x160"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
