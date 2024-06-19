#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# Aliases
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias act='source .venv/bin/activate' # Activate mediu virtual python
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Cleanup orphaned packages

. "$HOME/.cargo/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(starship init bash)"

# Variabile de mediu
export __NV_PRIME_RENDER_OFFLOAD=1 # Nvidia prime offload
export ANDROID_HOME=$HOME/Android/Sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/usr/lib/jvm/java-17-microsoft-openjdk/
