#!/bin/bash


# Install github-desktop
sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.9.3-linux3/GitHubDesktop-linux-2.9.3-linux3.deb
sudo apt-get install gdebi-core -y
sudo gdebi GitHubDesktop-linux-2.9.3-linux3.deb -y

clear

# Install VS-code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y

clear

# Install docker
sudo apt-get install docker -y
sudo apt-get install docker.io -y

clear

# Install Curl
sudo apt-get install curl -y

clear

# Make Nexus folder
mkdir ~/Nexus

# Grab Dockerfile
curl https://raw.githubusercontent.com/VerleneDodds/Nexus/main/Dockerfile >> ~/Nexus/Dockerfile

# Build Dockerfile
sudo docker build ~/Nexus

clear

# Get image ID 
ID=$(sudo docker images --format "{{.ID}}" --filter "dangling=true")

#Deploy Nexus container

sudo docker run --name Nexus -t -i --privileged -p 443:443 -p 1000:1000 -p 2375:2375 -p 2376:2376 -p 2377:2377 -p 9443:9443 -v /var/run -v /var/lib/docker/volumes $ID

