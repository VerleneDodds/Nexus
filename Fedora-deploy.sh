#!/bin/bash

# Install github-desktop      
sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.9.3-linux3/GitHubDesktop-linux-2.9.3-linux3.deb     
sudo yum install -y alien
sudo alien -r --scripts GitHubDesktop-linux-2.9.3-linux3.deb
sudo rpm -i github-desktop-2.9.3-1.x86_64.rpm
clear

# Install VS-code
sudo chown root /etc/yum.repos.d/vscode.repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo echo -e "[code] \nname=Visual Studio Code \nbaseurl=https://packages.microsoft.com/yumrepos/vscode \nenabled=1 \ngpgcheck=1 \ngpgkey=https://packages.microsoft.com/keys/microsoft.asc " > /etc/yum.repos.d/vscode.repo
sudo yum install -y code
clear

# Install Docker
sudo yum -y install dnf-plugins-core
sudo yum config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
    
clear

# Make Nexus folder
mkdir ~/Nexus

#Grab Dockerfile
curl https://raw.githubusercontent.com/VerleneDodds/Nexus/main/Dockerfile >> ~/Nexus/Dockerfile

clear

# Build Dockerfile
sudo docker build ~/Nexus

clear

# Get Image ID
ID=$(sudo docker images --format "{{.ID}}" --filter "dangling=true")

# Deploy Nexus Container
sudo docker run --name Nexus -t -i --privileged --init -p 443:443 -p 1000:1000 -p 2375:2375 -p 2376:2376 -p 2377:2377 -p 9443:9443 -v /var/run -v /var/lib/docker/volumes $ID
