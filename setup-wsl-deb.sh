#!/bin/bash

echo "Installing tools"
echo "----------"
VIM_DIR=~/.vim/colors			# vim directory
LIST_OF_APPS="git tmux curl vim jq gnupg-agent unzip" 	# programs to install

sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install -y $LIST_OF_APPS 
echo -e "done\n"

##########

# Download and install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Git prompt
echo "Getting git-prompt.sh"
echo "----------"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
echo -e "done\n"

# Get dircolors for Bash console
echo "Getting and applying dircolors"
echo "----------"
curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark > ~/.dircolors
echo -e "done\n"

# Add vim colors
echo "Creating $VIM_DIR and getting gruvbox"
echo "----------"
mkdir -p $VIM_DIR
curl https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim > $VIM_DIR/gruvbox.vim
echo -e "done\n"

#########

# az cli
echo "Installing Azure CLI"
echo "----------"
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y apt-transport-https azure-cli 
echo ""

# docker
echo "Installing docker"
echo "----------"
echo "Adding Docker's GPG Key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "Adding Docker stable repository"
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
echo "Installing Docker CE"
sudo apt-get update
if grep -q Microsoft /proc/version; then
    # This is WSL1 on Windows
    echo "WSL1, installing docker-ce only"
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $USER
    echo -e "Done with Docker, need to logout and back in for new docker permissions to be reflected\n"
elif grep -q microsoft /proc/version; then
    # This is WSL2 on Windows
    echo -e "WSL2, skipping Docker install assuming Docker for Windows will be used.\n"
else
    # Straight Linux and we can install full docker
    echo "Straight Linux, installing full Docker"
    #sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    #sudo systemctl enable docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "Starting docker service"
    sudo service docker start
    sudo usermod -aG docker $USER
    echo -e "Done with Docker, need to logout and back in for new docker permissions to be reflected\n"
fi

# kubectl cli
echo "Installing kubectl CLI"
echo "----------"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
echo -e "done\n"

# dotnet
echo "Installing dotnet"
echo "----------"
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-5.0
echo -e "done\n"

# Create cron and add permission for user to start from .bashrc due to RAM issue https://github.com/microsoft/WSL/issues/4166#issuecomment-604707989
echo "Setting up cron job for reclaiming RAM"
echo "----------"
echo '%sudo ALL=NOPASSWD: /etc/init.d/cron start' | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/cron
echo -e "$(sudo crontab -u root -l 2>/dev/null)\n*/10 * * * * echo 3 > /proc/sys/vm/drop_caches; touch /root/drop_caches_last_run" | sudo crontab -u root -
echo -e "done\n"

# Create dev folders
echo "Creating dev folders"
echo "----------"
mkdir ~/scratch
mkdir ~/github
echo -e "done\n"
