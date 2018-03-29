#!/bin/bash


VIM_DIR=~/.vim/colors		# vim directory
LIST_OF_APPS="git tmux curl"	# programs to install

sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install -y $LIST_OF_APPS 

##########

# Git prompt
echo -n "Getting git-prompt.sh"
echo -n ""
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
echo "done"

# Get dircolors for Bash console
echo -n "Getting and applying dircolors"
echo -n ""
curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark > ~/.dircolors
echo "done"

# Add vim colors
echo -n "Creating $VIM_DIR and getting gruvbox"
mkdir -p $VIM_DIR
echo -n ""
curl https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim > $VIM_DIR/gruvbox.vim
echo "done"

 
