#!/bin/bash


VIM_DIR=~/.vim/colors			# vim directory
LIST_OF_APPS="git tmux curl vim jq gnupg-agent" 	# programs to install

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

# docker
echo -n "Installing docker"
echo -n ""
echo -n "Adding Docker's GPG Key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo -n "Adding Docker stable repository"
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
echo -n "Installing Docker CE"
sudo apt-get update
if grep -q Microsoft /proc/version; then
    # This is WSL1 on Windows
    echo -n "WSL1, installing docker-ce only"
    sudo apt-get install -y docker-ce
elif grep -q microsoft /proc/version; then
    # This is WSL2 on Windows
    echo -n "WSL2, skipping Docker install assuming Docker for Windows will be used."
else
    # Straight Linux and we can install full docker
    echo -n "Straight Linux, installing full Docker"
    #sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    #sudo systemctl enable docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo -n "Starting docker service"
    sudo service docker start
fi
sudo usermod -aG docker $USER
echo -n "Done with Docker, need to logout and back in for new docker permissions to be reflected"

# kubectl cli
echo -n "Installing kubectl CLI"
echo -n ""
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
echo "done"
