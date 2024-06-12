#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
# alias clear='clear;neofetch'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ls='exa -al --color=always --group-directories-first --icons'     # preferred listing
# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
neofetch
. "$HOME/.cargo/env"
export ANDROID_HOME=$HOME/Android/Sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export JAVA_HOME=/usr/lib/jvm/java-17-microsoft-openjdk/
eval "$(starship init bash)"
