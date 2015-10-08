#!/bin/bash
if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters: input the directory to mount on /vivado/build"
	exit
fi
sudo docker run -v $1:/vivado/build -e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g ) --rm -it vivado-build /bin/bash
