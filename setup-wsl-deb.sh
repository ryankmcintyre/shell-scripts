#!/bin/bash


VIM_DIR=~/.vim/colors			# vim directory
LIST_OF_APPS="git tmux curl vim jq" 	# programs to install

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

#########

# az cli
echo -n "Installing Azure CLI"
echo -n ""
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y apt-transport-https azure-cli 
echo -n ""

# kubectl cli
echo -n "Installing kubectl CLI"
echo -n ""
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
echo "done"
