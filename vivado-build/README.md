This subproject sets up docker container for vivado build environment

First: create vivado-base image following the instructions
	Install vivado 2014.4/2015.1 based on ubuntu14.04
	Setup x11 forwarding to have GUI for vivado installation
		(Host)xhost +(turn off the access control so that everyone can connect to it)
		(Host)sudo docker run -it --name=vivado-base -v $PATH_TO_VIVAODI_FILE:/mnt  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY ubuntu:14.04 /bin/bash
		(Container)sudo apt-get update && apt-get install libxtst6 libxrender1 libxi6 git runit
		(Container)./xsetup
	Then simply follow the GUI instruction
		(Container)chmod -R a+rw /opt/Xilinx/Vivado/2014.4
	Finally commit the changes to vivado-base image
		(Host)sudo docker commit vivado-base vivado-base${version}:1.0

Second: create vivado-build image(change version at entrypoint.sh and Dockerfile base image)
	1. create bitbucket account
	2. create ssh keys for the bitbucket
		ssh-keygen
	3. store the keys as id_rsa, id_rsa.pub in a directory called sshkeys
		also push the public key to the bitbucket account

Third: run setup.sh ${version} ${docker registry url}
	note: run setup at webfront to initialize redis authorization

FAQ
1. what are some hardcoded path I need to know?
	/vivado: working directory
	/vivado/build: mounting volume path
2. what to replace in the ${} in the scripts
	${version}: use vivado version e.g. 2014.4, 2015.1
	${docker registry url}: server name that runs docker registry process
3. what is the ENV directory
	It is used in chpst command in the entrypoint.sh to adjust correct HOME environment  

TODO:
1. for Zync board to build successfully, the following packages needs to be installed.
	gcc, libssl-dev, bc
	Zync board build includes linux image, device tree, etc.

