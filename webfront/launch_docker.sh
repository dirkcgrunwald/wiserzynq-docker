#!/bin/bash
#
# parameter
# LICENSE_IP: server ip for distributing vivado license
# MOUNT_PATH: local/remote dirctory path that needs to be mounted in docker
# MOUNT_IP: if the directory to be mounted is at a remote machine, this is the ip address
# MOUNT_USER: if the directory to be mounted is at a remote machine, this is the username
MOUNT_IP=$(ifconfig eth0 | sed -rn 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
MOUNT_USER=$(whoami)
while getopts ":v:c:L:p:i:u:l:h" opt; do
	case $opt in
	v)
		VIVADO_VERSION=$OPTARG
		;;
	c)
		CONFIG_UUID=$OPTARG
		;;
	L)
 		LICENSE_IP=$OPTARG
		;;
	l)
		IPLIB=$OPTARG
		;;
	p)
		MOUNT_PATH=$OPTARG
		;;
	i)
		MOUNT_IP=$OPTARG
		;;
	u)
		MOUNT_USER=$OPTARG
		;;
	h)
		echo "options: v----> vivado version, for examplle 2014.4"
		echo "options: c----> config uuid in the redis db"
		echo "options: L----> license manager ip address"
		echo "options: l----> ip library repository"
		echo "options: p----> mounting path, whether it's local or remote server"
		echo "options: i----> ip for the server where mounting directory resides, default:" $(ifconfig eth0 | sed -rn 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p') 
		echo "options: u----> username for the server where mounting directory resides, default:" $(whoami)  
		echo "options: h----> helper"
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		;;
	esac
done
if [[ -z $VIVADO_VERSION ]];then
	echo "provide vivado version, please"
	exit
fi
if [[ -z $CONFIG_UUID ]];then
	echo "provide config uuid, please"
	exit
fi
if [[ -z $LICENSE_IP ]];then
	echo "provide license manager ip, please"
	exit
fi

if [[ -z $IPLIB ]];then
	docker run --privileged --cap-add SYS_ADMIN --device /dev/fuse -e LICENSE_IP=$LICENSE_IP -e MOUNT_PATH=$MOUNT_PATH -e MOUNT_IP=$MOUNT_IP -e MOUNT_USER=$MOUNT_USER -e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g ) --rm docker.csel.io:7777/vivado-build$VIVADO_VERSION:1.0 python /vivado/build/StartBuild.py -v $VIVADO_VERSION -c $CONFIG_UUID
else
	docker run --privileged --cap-add SYS_ADMIN --device /dev/fuse -e LICENSE_IP=$LICENSE_IP -e MOUNT_PATH=$MOUNT_PATH -e MOUNT_IP=$MOUNT_IP -e MOUNT_USER=$MOUNT_USER -e BUILDER_UID=$( id -u ) -e BUILDER_GID=$( id -g ) --rm docker.csel.io:7777/vivado-build$VIVADO_VERSION:1.0 python /vivado/build/StartBuild.py -v $VIVADO_VERSION -c $CONFIG_UUID -i $IPLIB
fi
