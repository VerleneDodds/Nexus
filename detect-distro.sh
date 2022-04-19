#!/bin/bash

Linux_version=$(grep -o 'fedora\|debian\|arch\|slackware\|unix\|freebsd' /etc/os-release | uniq)


if [ $Linux_version = fedora ]
then
    #Install github-desktop      
    sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.9.3-linux3/GitHubDesktop-linux-2.9.3-linux3.deb     
    sudo yum install -y alien
    sudo alien -r --scripts GitHubDesktop-linux-2.9.3-linux3.deb
    sudo rpm -i github-desktop-2.9.3-1.x86_64.rpm
    
    clear

    #Install VS-code
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo echo -e "[code] \nname=Visual Studio Code \nbaseurl=https://packages.microsoft.com/yumrepos/vscode \nenabled=1 \ngpgcheck=1 \ngpgkey=https://packages.microsoft.com/keys/microsoft.asc " > /etc/yum.repos.d/vscode.repo
    sudo chown root /etc/yum.repos.d/vscode.repo
    sudo yum install -y code
    
    clear

    #Install Docker
    sudo yum -y install dnf-plugins-core
    sudo yum config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    
    clear

    #Make Nexus folder
    mkdir ~/Nexus
    clear

    #Build Dockerfile
    sudo docker build ~/Nexus
    
    clear

    #Get Image ID
    ID=$(sudo docker images --format "{{.ID}}" --filter "dangling=true")

    #Deploy Nexus Container
    sudo docker run --name=Nexus -t -i --privileged --init -p 1000:1000 -p 9443:9443 -v /var/run -v /var/lib/docker/volumes $ID

elif [ $Linux_version = debian ]; 
then
    #Install github-desktop      
    sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.9.3-linux3/GitHubDesktop-linux-2.9.3-linux3.deb     
    sudo apt-get install gdebi-core -y    
    sudo gdebi GitHubDesktop-linux-2.9.3-linux3.deb -y    

    clear     

    #Install VS-code     
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg      
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/    
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'      
    rm -f packages.microsoft.gpg      
    sudo apt-get install apt-transport-https -y   
    sudo apt-get update   
    sudo apt-get install code -y      

    clear     

    #Install docker      
    sudo apt-get install docker -y    
    sudo apt-get install docker.io -y     

    clear     

    #Install Curl    
    sudo apt-get install curl -y      

    clear     

    #Make Nexus folder   
    mkdir ~/Nexus     

    #Grab Dockerfile     
    curl https://raw.githubusercontent.com/Underground-Ops/underground-nexus/main/Dockerfile > ~/Nexus/Dockerfile   

    #Build Dockerfile    
    sudo docker build ~/Nexus     

    clear     

    #Get image ID    
    ID=$(sudo docker images --format "{{.ID}}" --filter "dangling=true")      

    #Deploy Nexus container   

    sudo docker run --name=Nexus -t -i --privileged --init -p -p 1000:1000 -p 9443:9443 -v /var/run -v /var/lib/docker/volumes $ID     

elif [ $Linux_version = arch ]
then

    #Update repositories 
    sudo pacman -Syy

    clear

    #Install and enable docker
    sudo pacman -S docker --noconfirm
    sudo systemctl start docker.service
    sudo systemctl enable docker.service

    clear

    #Add user to Docker group
    sudo usermod -aG docker $USER

    clear

    #Install git
    sudo pacman -S git --noconfirm

    clear
    
    #Install VS-code
    cd ~/Downloads
    git clone https://AUR.archlinux.org/visual-studio-code-bin.git
    cd visual-studio-code-bin/
    sudo makepkg -s --noconfirm
    sudo pacman -U visual-studio-code-bin-*.pkg.tar.xz --noconfirm
    cd ../ && sudo rm -rfv visual-studio-code-bin/

    clear

    #Install Curl    
    pacman -Sy curl --noconfirm   

    clear     

    #Make Nexus folder   
    mkdir ~/Nexus     

    #Grab Dockerfile     
    curl https://raw.githubusercontent.com/Underground-Ops/underground-nexus/main/Dockerfile > ~/Nexus/Dockerfile   

    #Build Dockerfile    
    sudo docker build ~/Nexus     

    clear     

    #Get image ID    
    ID=$(sudo docker images --format "{{.ID}}" --filter "dangling=true")      

    #Deploy Nexus container   

    sudo docker run --name=Nexus -t -i --privileged --init -p -p 1000:1000 -p 9443:9443 -v /var/run -v /var/lib/docker/volumes $ID     


#elif [$Linux_version = slackware"]
#    STATEMENTS4
elif [ $Linux_version = freebsd ]
then

    #Put username into variable
    USERNAME=$(whoami)

    #Update repositories
    freebsd-update fetch 
    
    #Install docker 
    pkg install -y docker docker-machine virtualbox-ose 
    pw groupmod vboxuser -m $USERNAME
    docker-machine create -d virtualbox default
    eval "$(docker-machine env default)"


    
else
    echo 'Unable to detect distro version'
fi
