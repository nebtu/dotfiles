#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'
PS1='[\u@\h \W]\$ '
#export PATH=~/.emacs.d/bin:$PATH
export PATH="$PATH:/opt/nvim/"
PATH="$HOME/.local/bin:$PATH"
export VISUAL=nvim
export EDITOR="$VISUAL"
export TERMINAL=alacritty

alias beet='~/builds/beets-src/beets/beet'
alias sus='systemctl suspend'
alias bgimg=~/.fehbg
alias mntnas='sudo mount -t nfs -o vers=4 klumpat-nas:/volume1/B_Special ~/nas'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#source /usr/share/fzf/key-bindings.bash
#source /usr/share/fzf/completion.bash

source /usr/share/doc/fzf/examples/key-bindings.bash

