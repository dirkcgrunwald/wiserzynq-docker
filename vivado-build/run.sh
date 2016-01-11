#!/bin/bash
if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters: input the directory to mount on /vivado/build"
	exit
fi
sudo docker run --privileged --cap-add SYS_ADMIN --device /dev/fuse -e MOUNT_PATH=$1 -e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g ) --rm -it docker.csel.io:7777/vivado-build:sshfs /bin/bash
