# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#------------------------------
# Prompt
#------------------------------


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

SAVEHIST="${HISTSIZE}"
export EDITOR="/usr/bin/vim"
export VISUAL=$EDITOR
export ESCDELAY=10 # ncurses escape wait time (ms)

if [ $SSH_TTY ]; then
  MUTT_EDITOR=$EDITOR
else
  MUTT_EDITOR=emacsclient.emacs-snapshot
fi

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
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1="\[\e[1;31m\]\u\[\e[0;34m\]@\h\[\e[1;32m\]\w\[\e[1;32m\]\\$\[\e[m\] "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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



#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

ulimit -S -c 0          # Don't want any coredumps.
set -o notify
set -o noclobber
set -o ignoreeof
#set -o xtrace          # Useful for debuging.

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"

#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
complete -d cd rmdir
bind 'set match-hidden-files off'
bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
set -o vi


#------------------------------
# Comp stuff
#------------------------------

if [ "${BASH_VERSION%.*}" \< "3.0" ]; then
    echo "You will need to upgrade to version 3.0 \
for full programmable completion features."
    return
fi

shopt -s extglob         # Necessary,
#set +o nounset          # otherwise some completions will fail.

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # Currently, same as builtins.
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract

# Documents - Postscript,pdf,dvi.....
complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.+(dvi|DVI)' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.+(pdf|PDF)' acroread pdf2ps
complete -f -o default -X \
'!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
complete -f -o default -X \
'!*.+(doc|DOC|xls|XLS|ppt|PPT|sx?|SX?|csv|CSV|od?|OD?|ott|OTT)' libreffice

# Multimedia
complete -f -o default -X \
'!*.+(gif|GIF|jp*g|JP*G|bmp|BMP|xpm|XPM|png|PNG)' xv gimp ee gqview
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123
complete -f -o default -X \
'!*.@(mp[23]|MP[23]|ogg|OGG|wav|WAV|pls|m3u|xm|mod|s[3t]m|it|mtm|ult|flac)' xmms
complete -f -o default -X \
'!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|asf|vob|VOB|bin|dat|vcd|\
ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|QT|wmv|mp3|MP3|ogg|OGG|\
ogm|OGM|mp4|MP4|wav|WAV|asx|ASX)' xine


complete -f -o default -X '!*.pl'  perl perl5


# This is a 'universal' completion function - it works when commands have
# a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'
# Needs the '-o' option of grep
#  (try the commented-out version if not available).

# First, remove '=' from completion word separators
# (this will allow completions like 'ls --color=auto' to work correctly).

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}


_get_longopts() 
{ 
    #$1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
#grep ^"$2" |sort -u ;
    $1 --help | grep -o -e "--[^[:space:].,]*" | grep -e "$2" |sort -u 
}

_longopts()
{
    local cur
    cur=${COMP_WORDS[COMP_CWORD]}

    case "${cur:-*}" in
       -*)      ;;
        *)      return ;;
    esac

    case "$1" in
      \~*)      eval cmd="$1" ;;
        *)      cmd="$1" ;;
    esac
    COMPREPLY=( $(_get_longopts ${1} ${cur} ) )
}
complete  -o default -F _longopts configure bash
complete  -o default -F _longopts wget id info a2ps ls recode

_make()
{
    local mdef makef makef_dir="." makef_inc gcmd cur prev i;
    COMPREPLY=();
    cur=${COMP_WORDS[COMP_CWORD]};
    prev=${COMP_WORDS[COMP_CWORD-1]};
    case "$prev" in
        -*f)
            COMPREPLY=($(compgen -f $cur ));
            return 0
        ;;
    esac;
    case "$cur" in
        -*)
            COMPREPLY=($(_get_longopts $1 $cur ));
            return 0
        ;;
    esac;

    # make reads `GNUmakefile', then `makefile', then `Makefile'
    if [ -f ${makef_dir}/GNUmakefile ]; then
        makef=${makef_dir}/GNUmakefile
    elif [ -f ${makef_dir}/makefile ]; then
        makef=${makef_dir}/makefile
    elif [ -f ${makef_dir}/Makefile ]; then
        makef=${makef_dir}/Makefile
    else
        makef=${makef_dir}/*.mk        # Local convention.
    fi


    # Before we scan for targets, see if a Makefile name was
    # specified with -f ...
    for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
        if [[ ${COMP_WORDS[i]} == -f ]]; then
           # eval for tilde expansion
           eval makef=${COMP_WORDS[i+1]}
           break
        fi
    done
    [ ! -f $makef ] && return 0

    # deal with included Makefiles
    makef_inc=$( grep -E '^-?include' $makef | \
    sed -e "s,^.* ,"$makef_dir"/," )
    for file in $makef_inc; do
        [ -f $file ] && makef="$makef $file"
    done


    # If we have a partial word to complete, restrict completions to
    # matches of that word.
    if [ -n "$cur" ]; then gcmd='grep "^$cur"' ; else gcmd=cat ; fi

    COMPREPLY=( $( awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ \
                                {split($1,A,/ /);for(i in A)print A[i]}' \
                                $makef 2>/dev/null | eval $gcmd  ))

}
complete -F _make -X '+($*|*.[cho])' make gmake pmake




_killall()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}

    # get a list of processes (the first sed evaluation
    # takes care of swapped out processes, the second
    # takes care of getting the basename of the process)
    COMPREPLY=( $( /usr/bin/ps -u $USER -o comm  | \
        sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
        awk '{if ($0 ~ /^'$cur'/) print $0}' ))

    return 0
}

complete -F _killall killall killps



# A meta-command completion function for commands like sudo(8), which need to
# first complete on a command, then complete according to that command's own
# completion definition - currently not quite foolproof,
# but still quite useful (By Ian McDonald, modified by me).


_meta_comp()
{
    local cur func cline cspec

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    cmdline=${COMP_WORDS[@]}
    if [ $COMP_CWORD = 1 ]; then  
         COMPREPLY=( $( compgen -c $cur ) )
    else
        cmd=${COMP_WORDS[1]}            # Find command.
        cspec=$( complete -p ${cmd} )   # Find spec of that command.

        # COMP_CWORD and COMP_WORDS() are not read-only,
        # so we can set them before handing off to regular
        # completion routine:
        # Get current command line minus initial command,
        cline="${COMP_LINE#$1 }"
        # split current command line tokens into array,
        COMP_WORDS=( $cline )
        # set current token number to 1 less than now.
        COMP_CWORD=$(( $COMP_CWORD - 1 ))
        # If current arg is empty, add it to COMP_WORDS array
        # (otherwise that information will be lost).
        if [ -z $cur ]; then COMP_WORDS[COMP_CWORD]=""  ; fi

        if [ "${cspec%%-F *}" != "${cspec}" ]; then
      # if -F then get function:
            func=${cspec#*-F }
            func=${func%% *}
            eval $func $cline   # Evaluate it.
        else
            func=$( echo $cspec | sed -e 's/^complete//' -e 's/[^ ]*$//' )
            COMPREPLY=( $( eval compgen $func $cur ) )
        fi

    fi
    
}

complete -o default -F _meta_comp nohup \
eval exec trace truss strace sotruss gdb
complete -o default -F _meta_comp command type which  nice time

#------------------------------
# Alias
#------------------------------

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

alias apt=apt-get

alias ll='ls -l'
alias la='ls -a'
alias ls='ls --color=auto --human-readable --group-directories-first'
alias gdb='gdb -q' # quiet
alias make='make --no-print-directory'
alias valgrind-full='valgrind --leak-check=full --show-reachable=yes'
alias pstree='ps auxwwwf'
alias bc='bc -q'
alias netstat='netstat 2> /dev/null'
alias lst='lst -F -s'
alias less='less -R'
alias cpv='rsync -P -rR' # verbose copy
alias rd='rmdir'
alias cp='cp -i'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias mv='mv -i'
alias rm='rm -i'
alias chmod="chmod -c"
alias chown="chown -c"
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

alias df='df -kTh'

alias rsync_auto='rsync -Puvarph'

# Misc
alias c='clear'
alias cl='clear ; ls -l'
alias e='exit'
alias i='ifconfig ; ping google.com -c3 ; echo'
alias l='ls -l'
alias n='netstat -antup ; echo ;
echo -n "Interface:    " ; ifconfig | grep Ethernet | cut -d " " -f1 ;
echo -n "MAC address:  " ; ifconfig | grep Ethernet | cut -d " " -f11 ;
echo -n "Internal IP:  " ; ifconfig | grep Bcast | cut -d ":" -f2 | cut -d " " -f1 ;
echo -n "External IP:  " ; curl ifconfig.me ; echo'
alias r='cd /root/ ; clear'
alias s='cd /opt/scripts/ ; clear'
alias sip='sort -n -u -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#------------------------------
# Functions 
#------------------------------

# Functions
if [ -f '/etc/profile.d/prll.sh' ]; then
    . "/etc/profile.d/prll.sh"
fi

run_under_tmux() {
    # Run $1 under session or attach if such session already exist.
    # $2 is optional path, if no specified, will use $1 from $PATH.
    # If you need to pass extra variables, use $2 for it as in example below..
    # Example usage:
    #   torrent() { run_under_tmux 'rtorrent' '/usr/local/rtorrent-git/bin/rtorrent'; }
    #   mutt() { run_under_tmux 'mutt'; }
    #   irc() { run_under_tmux 'irssi' "TERM='screen' command irssi"; }


    # There is a bug in linux's libevent...
    # export EVENT_NOEPOLL=1

    command -v tmux >/dev/null 2>&1 || return 1

    if [ -z "$1" ]; then return 1; fi
    local name="$1"
    if [ -n "$2" ]; then
        local file_path="$2"
    else
        local file_path="command ${name}"
    fi

    if tmux has-session -t "${name}" 2>/dev/null; then
        tmux attach -d -t "${name}"
    else
        tmux new-session -s "${name}" "${file_path}" \; set-option status \; set set-titles-string "${name} [tmux]"
    fi
}

t() { run_under_tmux rtorrent; }
irc() { run_under_tmux irssi "TERM='screen' command irssi"; }

over_ssh() {
    if [ -n "${SSH_CLIENT}" ]; then
        return 0
    else
        return 1
    fi
}

reload () {
          exec "${SHELL}" "$@"
}

confirm() {
    local answer
    echo -ne "zsh: sure you want to run '${YELLOW}$@${NC}' [yN]? "
    read -q answer
        echo
    if [[ "${answer}" =~ ^[Yy]$ ]]; then
        command "${=1}" "${=@:2}"
    else
        return 1
    fi
}

confirm_wrapper() {
    if [ "$1" = '--root' ]; then
        local as_root='true'
        shift
    fi

    local runcommand="$1"; shift

    if [ "${as_root}" = 'true' ] && [ "${USER}" != 'root' ]; then
        runcommand="sudo ${runcommand}"
    fi
    confirm "${runcommand}" "$@"
}

poweroff() { confirm_wrapper --root $0 "$@"; }
reboot() { confirm_wrapper --root $0 "$@"; }
hibernate() { confirm_wrapper --root $0 "$@"; }

detox() {
    if [ "$#" -ge 1 ]; then
        confirm detox "$@"
    else    
        command detox "$@"
    fi
}

has() {
    local string="${1}"
    shift
    local element=''
    for element in "$@"; do
        if [ "${string}" = "${element}" ]; then
            return 0
        fi
    done
    return 1
}

begin_with() {
    local string="${1}"
    shift
    local element=''
    for element in "$@"; do
        if [[ "${string}" =~ "^${element}" ]]; then
            return 0
        fi
    done
    return 1

}



preexec() {
    # Set terminal title along with current executed command pass as second argument
    termtitle preexec "${(V)1}"
}

man() {
    if command -v vimpager >/dev/null 2>&1; then
        PAGER="vimpager" command man "$@"
    else
        command man "$@"
    fi
}

# Are we running under grsecurity's RBAC?
rbac_auth() {
    local auth_to_role='admin'
    if [ "${USER}" = 'root' ]; then
        if ! grep -qE '^RBAC:' "/proc/self/status" && command -v gradm > /dev/null 2>&1; then
            echo -e "\n${BLUE}*${NC} ${GREEN}RBAC${NC} Authorize to '${auth_to_role}' RBAC role."
            gradm -a "${auth_to_role}"
        fi
    fi
}
#rbac_auth

#
# File & string-related functions:
#

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more 

}

function cuttail() # cut last n lines in file, 10 by default
{
    nlines=${2:-10}
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}


function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.tar.xz)    bsdtar xf $1    ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *.xz)        7za x $1         ;;
             *.lzma)      lzma -d $1      ;;
             *.deb)       bsdtar xzvf $1      ;;
             *.tar)       tar -xvf $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#
# Process/system related functions:
#

function ips() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


function killps()                 # Kill by process name.
{
    local pid pname sig="-TERM"   # Default signal.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Open connections :$NC "; netstat -pan --inet;
    echo
}

#
# Misc utilities:
#
mkcd(){
    if [ $# -ne 1 ]
    then
        echo "Usage: $0 dir" >&2
        return 1
    fi
    mkdir -p "$1"
    cd "$1"
}

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

export PATH=${PATH}:/usr/share/android-sdk/tools:/usr/share/android-sdk/platform-tools
