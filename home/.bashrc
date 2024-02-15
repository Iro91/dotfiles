# /bin/bash

# ----------------------------------------------------------------------------
# Behavior
# ----------------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# Enable vim motions
set -o vi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

export FZF_DEFAULT_COMMAND='find .'
export BAT_THEME='base16-256'
export BAT_STYLE='numbers'

# Allow application core dumps
ulimit -c unlimited

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

# Colored shell prompt
#PS1='\[[iro:\w]\$\[\033[0m\] '
#PS1='\[\033[1;32m\][iro:\w]\$\[\033[0m\] '
eval "$(starship init bash)"

bind 'set bell-style visible'

# ----------------------------------------------------------------------------
# Environment Configuration
# ----------------------------------------------------------------------------

# Global exports
export EDITOR=nvim
export TERMINAL=kitty
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ----------------------------------------------------------------------------
# Shortcuts
# ----------------------------------------------------------------------------
alias cp='cp -iv'
alias mv='mv -iv'
alias ls="/bin/ls -F -h --color=auto"
alias la='ls -F -a'
alias la='ls -a'
alias ll='ls -l'
alias lm='ls -tr | tail -n 1'
alias lsd='/bin/ls -d --color */ 2>/dev/null || true'
alias grep='grep --color=auto'
alias ..='cd ../'
alias 2.='cd ../../ '
alias 3.='cd ../../../ '
alias path='echo $PATH'
alias rp='. $HOME/.bashrc'
alias cat='bat'

# cd and show me directories
function cd() { builtin cd "$@" && lsd; }

# Find anything that contains part of the string I provide
function ff() {
    local hits=""
    if [ $# -ne 0 ]; then
        hits="$(find . -type f -iname "*$1*" | sort | uniq)"
    else
        hits="$(find . -type f -iname "*" | fzf --preview 'bat {}')"
    fi

    if [ -n "$hits" ]; then
        echo "$hits" | xclip -f -selection clipboard
    fi
}

# find and open the target entry
function fe() {
    local hits=""
    hits="$(ff "$@")"

    [ -n "$hits" ] && $EDITOR "$hits"
}

# Find and jump to the target directory
function fcd() {
    local hits=""
    if [ $# -ne 0 ]; then
        hits="$(find . -type d -iname "*$1*" | sort | uniq)"
    else
        hits="$(find . -type d | fzf )"
    fi
    [ -n "$hits" ] && { cd "$hits" || false; }
}

# Look in all files recursively except for binaries for this string
function gf() { grep -irIns "$@" *; }
# Look in this dir for all files except for binaries for this string
function gl() { grep -iIns "$@" *; }
#function gf() {
#    rg --line-number --no-heading --color=always --smart-case "$@" | fzf -d ':' -n 2.. --ansi --no-sort --preview-window 'down:20%:+{2}' --preview 'bat --style=numbers --color=always --highlight-line {2} {1}'
#}


# ----------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------
# Determines if the item selected is a ui. If it isn't opens it up with the editor selected
function e()
{
    # Configure editor selections
    local editor=${EDITOR:-vim}
    [[ $editor =~ .*vim*. ]] && editor="$editor -p"

    # Capture files from fzf
    local files=("$@")
    if [[ $# -eq 0 ]]; then
        files=($(fzf --multi))
    fi

    local file
    local ui_files=()
    local txt_files=()
    for file in ${files[@]}; do
        echo $file
        [[ "$file" == *.ui ]] && ui_files+=("$file") || txt_files+=("$file")
    done

    [[ ${#ui_files[@]} -gt 0 ]]  && { designer "${ui_files[@]}" &> /dev/null & }
    [[ ${#txt_files[@]} -gt 0 ]] && $editor "${txt_files[@]}"
}

# Open VS code 
function ve()
{ 
    if [[ $# -gt 0 ]]; then
        code "$@";
    else
        files="$(fzf --multi)" && [ ! -z "$files" ] && code $files
    fi
}

# Run my runnable
function r()
{
    local script=./run.sh
    if [ -f $script ]; then
        $script "$@"
    else
        echo "$script not found" >&2
    fi
}

# Open up a black terminal
function t()
{
    args="-fg lime"
    if [[ $# -gt 0 ]]; then
        args="$@"
    fi

    xterm -fa mono:size=12 -bg black $args & disown
}

# Find and jump to target
# 
# Does a dirty search for a filename that matches the input expression
# If a matching file is found we present a list of matching directories that
# the user can select and then cd into
function fj(){
    if [ $# -ne 1 ]; then
        echo "ERROR: Single target required: $@" >&2
        return 1
    fi

    # Find matches and store them in an array
    mapfile -t matches < <(find . -iname "*$1*" | sort)
    if [ ${#matches[@]} -eq 0 ]; then
        echo "ERROR: No targets found" >&2
        return 0
    fi

    for match in ${matches[@]}; do
        echo $match
    done

    # Get the unique directories of the found files
    mapfile -t dir_list < <(for match in "${matches[@]}"; do dirname "$(realpath "$match")"; done | sort | uniq)

    local count=0
    for target in ${dir_list[@]}; do
        echo "[$count] $target"
        count=$((count + 1))
    done

    # If we only have one entry jump immediately to the target
    if [ ${#dir_list[@]} -eq 1 ]; then
        echo "jmp ${dir_list[0]}"
        cd ${dir_list[0]}
        return 0
    fi

    read -p "Select target: " selected

    # Validate the input and display the corresponding entry
    if [[ $selected =~ ^[0-9]+$ ]] && [ $selected -ge 0 ] && [ $selected -lt $count ]; then
        echo "jmp $selected: ${dir_list[$selected]}"
        cd ${dir_list[$selected]}
    else
        echo "ERROR: Invalid target: $selected" >&2
        return 1
    fi
}

# Git search
function gits(){
    git branch | fzf | tr -d ' '
}

function gc(){
    if [[ $# -gt 0 ]]; then
        git checkout "$1"
    else
        git checkout "$(gits)"
    fi
}

# ----------------------------------------------------------------------------
# Work specific loading
# ----------------------------------------------------------------------------
if [ -f $HOME/.workrc ]; then
    source $HOME/.workrc
    alias et='e $HOME/.workrc'
fi

# ----------------------------------------------------------------------------
# Frequent file edits
# ----------------------------------------------------------------------------
alias ep='e $HOME/.bashrc'
alias ev='e $HOME/.vimrc'
alias dot='cd $HOME/dev/dotfiles/home/'
alias nvc='cd $HOME/dev/dotfiles/home/.config/nvim'

# ----------------------------------------------------------------------------
# Bookmarks
# ----------------------------------------------------------------------------
function tb()  { cd $HOME/dev/testbench/bench/$@; }

# Enable bash fuzzy finding if available
if [ -f ~/.fzf.bash ]; then
    source "$HOME/.fzf.bash"
    export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
fi

# ----------------------------------------------------------------------------
# Kick off Tmux
# ----------------------------------------------------------------------------
# Starts our shell in a tmux session if the followingt are met:
# 1. Check that we are intearactive
# 2. That we have tmux installed
# 3. That we are not in a live tmux session
if [[ $- = *i* ]] && [[ $(which tmux) ]] && [[ -z "$TMUX" ]] && [[ ! $TERM_PROGRAM = vscode ]]; then
    if tmux has-session -t "main" &> /dev/null; then
        exec tmux a -t "main"
    else
        exec tmux new -s "main"
    fi
fi
