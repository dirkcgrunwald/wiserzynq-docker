This subproject sets up docker container for vivado build environment

First: create vivado-base image following the instructions
Install vivado 2014-4 based on ubuntu14.04
Setup x11 forwarding to have GUI for vivado installation
(Host)sudo docker run -it -v $PATH_TO_VIVAODI_FILE:/mnt  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY ubuntu:14.04 /bin/bash
(Host)xhost +(turn off the access control so that everyone can connect to it)
(Host)sudo docker run -it ubuntu:14.04 /bin/bash
(Container)sudo apt-get update && apt-get install libxtst6 libxrender1 libxi6 git runit
(Container)./xsetup
Then simply follow the GUI instruction
Finally commit the changes to vivado-base image
(Host)sudo docker commit $CONTAINER_NAME vivado-base 

Second: create ssh keys for remote sshfs commands and store them in sshkeys directory
ssh-keygen -t rsa 

Second create vivado-build image
sudo docker build -t vivado-build .

Third run the vivado build
sudo ./run.sh $PATH_TO_VOLUME_MOUNT


FAQ
1. what are some hardcoded path I need to know?
	/vivado: working directory
	/vivado/build: mounting volume path
