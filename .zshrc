#
# History and Completeion
#
autoload -U compinit
compinit -u
autoload -Uz colors ; colors
autoload -Uz history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
HISTFILE=${HOME}/.zsh-history
HISTSIZE=10000000
SAVEHIST=100000

if [[ ! -z `compaudit` ]]; then
  compaudit | xargs chmod g-w
fi

bindkey -v
bindkey -a 'q' push-line
bindkey -a 'h' run-help
bindkey "" history-incremental-search-backward
bindkey "" history-incremental-search-forward
bindkey "[3~" delete-char

zstyle ':completion:*' use-cache true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %P Lines: %m
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:approximate:*' max-errors 1
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*:default' menu select auto
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:::::' completer _complete _approximate

autoload -U zmv
autoload -U zfinit
zmodload zsh/complist
zmodload zsh/zftp



#
# Configuration
#
limit coredumpsize 102400
setopt prompt_subst
setopt nobeep
setopt long_list_jobs
setopt list_types
setopt auto_resume
setopt auto_list
setopt hist_ignore_dups
setopt auto_pushd
setopt pushd_to_home
setopt pushd_ignore_dups
setopt extended_glob
setopt auto_menu
setopt extended_history
setopt equals
setopt magic_equal_subst
setopt hist_verify
setopt numeric_glob_sort
setopt print_eight_bit
setopt share_history
setopt auto_cd
setopt auto_param_keys
setopt auto_param_slash
setopt correct
setopt noautoremoveslash
setopt complete_aliases
setopt glob_complete


#
# Prompt
#
COMPPATH=''
SUDOPATH=''
for it in `echo $PATH | sed -e 's/:/ /g'`; do
  if [[ sbin = `basename $it` ]]; then
    SUDOPATH="$SUDOPATH $it"
  else
    SUDOPATH="$SUDOPATH $it"
    COMPPATH="$COMPPATH $it"
  fi
done

case ${UID} in
  0)
    zstyle ':completion:*' command-path `echo $SUDOPATH`
    PROMPT="%{${fg[red]}%}%n@%m%{${reset_color}%} %{${fg[blue]}%}#%{${reset_color}%} "
    ;;
  *)
    zstyle ':completion:*' command-path `echo $COMPPATH`
    zstyle ':completion:*:sudo:*' command-path `echo $SUDOPATH`
    case ${HOST} in
      miku)
        PCOLOR=$'\x1b[38;5;44m'
        ;;
      haku)
        PCOLOR=$'\x1b[38;5;60m'
        ;;
      neru)
        PCOLOR=$'\x1b[38;5;214m'
        ;;
      teto)
        PCOLOR=$'\x1b[38;5;162m'
        ;;
      ruka)
        PCOLOR=$'\x1b[38;5;182m'
        ;;
      *)
        PCOLOR=${fg[green]}
        ;;
    esac
    PROMPT="%{$PCOLOR%}%n@%m $ %{${reset_color}%}"
    ;;
esac


case "${TERM}" in
  kterm*|xterm)
    precmd() { echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007" }
    ;;
esac


PROMPT2="%B%{${fg[magenta]}%}%_#%{${reset_color}%}%b "
SPROMPT="%B%{${fg[magenta]}%}%r is correct? [n,y,a,e] :%{${reset_color}%}%b "

#
# Aliases and Functions
#
alias ls="ls -vF --color"
alias dir="dir --color"
alias cp="cp -iv"
alias mv="mv -iv"
alias ln="ln -v"
alias c="cd"
alias v="vi"
alias l="ls"
alias q="exit"
alias la="ls -A"
alias ll="ls -l"
alias lla="ls -lA"
alias ss="sudo su"
alias ce="crontab -e"
alias cv="convmv -f utf-8 --nfd -t utf-8 --nfc -r ."
alias ip="curl ifconfig.me"
alias zmv='noglob zmv'
[[ -f `which dcfldd` ]]  && alias dd="dcfldd"
[[ -f `which catimg` ]]  && alias cat="catimg"
[[ ! -f `which tailf` ]] && alias tailf="tail -f"
[[ -f `which htop` ]]    && alias top="htop"
[[ -f `which hub` ]]     && alias git="hub"

function copy() {
  IN=$1
  OUT=$2
  if [ -f `which pv` ]; then
    pv $IN > $OUT
  else
    cp -iv $IN $OUT
  fi
}

function chkey() {
  if [ -z $1 ]; then
    tmux set-option prefix C-a
    tmux bind C-a last-window
    tmux bind a last-window
  else
    tmux set-option prefix C-$1
    tmux bind C-$1 last-window
    tmux bind $1 last-window
  fi
}
function socks() {
  PORT=$1
  HOST=$2
  ssh -N -f -c 3des -D localhost:$PORT $HOST
}
function search() {
  TARGET=$1
  STRING=$2
  find . -type f -name $TARGET -exec grep --color -IHnibe $STRING {} \;
}
function count() {
  echo $(( `ls -l | wc -l`-1 )) `du -s $@`
}
function psx() {
  ps aux | grep $1 | grep -v grep
}
function pskill() {
  list=''
  for p in `psx $1 | sed -E 's/  */ /g' | cut -d' ' -f2`; do
    list="$list `echo $p | tr '\n' ' '`"
  done
  kill `echo $list | sed -E 's/  */ /g'`
}
function chpwd() {
  ls
}

#
# Git Prompt
#
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz is-at-least
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' enable git
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' formats '[%r](%b%c%u)' '%m'
  zstyle ':vcs_info:git:*' actionformats '[%r](%b%c%u)' '%m' '<!%a>'
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "^"
  zstyle ':vcs_info:git:*' unstagedstr "*"
fi
if is-at-least 4.3.11; then
  zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-untracked git-push-status git-nomerge-branch git-stash-count
  function +vi-git-hook-begin() {
    [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]] && return 1
    return 0
  }
  function +vi-git-untracked() {
    [[ "$1" != "1" ]] && return 0
    if command git status --porcelain 2> /dev/null | awk '{print $1}' | command grep -F '??' > /dev/null 2>&1 ; then
      hook_com[unstaged]+='?'
    fi
    return 0
  }
  function +vi-git-push-status() {
    [[ "$1" != "1" ]] && return 0
    local ahead
    ahead=$(command git rev-list origin/${hook_com[branch]}..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')
    [[ $ahead -gt 0 ]] && hook_com[misc]+=":P${ahead}"
    return 0
  }
  function +vi-git-nomerge-branch() {
    [[ "$1" != "1" ]] && return 0
    [[ "${hook_com[branch]}" == "master" ]] && return 0
    local nomerged
    nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')
    [[ "$nomerged" -gt 0 ]] && hook_com[misc]+=":M${nomerged}"
    return 0
  }
  function +vi-git-stash-count() {
    [[ "$1" != "1" ]] && return 0
    local stash
    stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
    [[ "${stash}" -gt 0 ]] && hook_com[misc]+=":S${stash}"
    return 0
  }
fi

function _update_vcs_info_msg() {
  local -a messages
  local prompt
  LANG=C vcs_info
  if [[ -z ${vcs_info_msg_0_} ]]; then
    prompt=""
  else
    [[ -n "$vcs_info_msg_0_" ]] && messages+=("%F{green}${vcs_info_msg_0_}%f")
    [[ -n "$vcs_info_msg_1_" ]] && messages+=("%F{yellow}${vcs_info_msg_1_}%f")
    [[ -n "$vcs_info_msg_2_" ]] && messages+=("%F{red}${vcs_info_msg_2_}%f")
    prompt="${(j: :)messages}"
  fi
  RPROMPT="$prompt %{${fg[blue]}%}[`pwd | sed "s:$HOME:~:"`]%{${reset_color}%}"
}
add-zsh-hook precmd _update_vcs_info_msg

#RPROMPT="%1(v|%F{green}%1v%f|)"
#RPROMPT="$RPROMPT %{${fg[blue]}%}[%/]%{${reset_color}%}"

#
# buf stacker
#

show_buffer_stack() {
  POSTDISPLAY="
  stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

#
# tmux
#

if [ ! -z "`which tmux`" ]; then
  if [ $SHLVL = 1 ]; then
    if [ $(( `ps aux | grep tmux | grep $USER | grep -v grep | wc -l` )) != 0 ]; then
      echo "There is $(( `ps aux | grep tmux | grep $USER | grep -v grep | wc -l` )) tmux session."
    fi
  else
    [[ -f `which pbcopy` ]] && alias pbcopy="ssh 127.0.0.1 `which pbcopy`"
    [[ -f `which pbpaste` ]] && alias pbpaste="ssh 127.0.0.1 `which pbpaste`"
  fi
fi

