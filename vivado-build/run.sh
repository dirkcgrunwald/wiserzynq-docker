#!/bin/bash
if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters: input the directory to mount on /vivado/build"
	exit
fi
docker run --privileged --cap-add SYS_ADMIN --device /dev/fuse -e MOUNT_PATH=$1 -e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g ) --rm docker.csel.io:7777/vivado-build:lightweight3.0 /bin/bash -c "cd /vivado/build/projects/fmcomms2/zed;make"
