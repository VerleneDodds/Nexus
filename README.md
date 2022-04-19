## Getting Started

To start, either download the script by hand and then run

```bash
sudo chmod +x detect-distro.sh && sudo ./detect-distro.sh
```

Or you can use curl to download the script and run it

```bash
curl https://raw.githubusercontent.com/VerleneDodds/Nexus/main/detect-distro.sh > detect-distro.sh && sudo chmod +x detect-distro.sh && sudo ./detect-distro.sh
```

Now to have the service fully up you will need to open another terminal and type the following command

```bash
sudo docker exec Nexus sh deploy-olympiad.sh
```

Now you have succesfully started a Nexus docker container, if you would like to see more information on it, check out [Nato As Code on YouTube](https://www.youtube.com/c/NatoasCode) 
