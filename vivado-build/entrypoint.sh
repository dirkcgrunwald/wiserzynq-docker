#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# If we are running docker natively, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# If we are running from boot2docker, this is not necessary.

# replace the ${vivado_version} with real version, e.g. 2014.4, 2015.1

. /opt/Xilinx/Vivado/${vivado_version}/settings64.sh
ln -s /usr/bin/make /usr/bin/gmake
if [[ -n $LICENSE_IP ]];then
	export XILINXD_LICENSE_FILE=2100@$LICENSE_IP
fi
if [[ -n $MOUNT_PATH ]]; then
	if [[ -n $MOUNT_IP ]]; then
		if [[ -n $MOUNT_USER ]]; then
			sshfs -o allow_other -oStrictHostKeyChecking=no -oIdentityFile=/root/.ssh/id_rsa $MOUNT_USER@$MOUNT_IP:$MOUNT_PATH /vivado/build/
		else
			echo "MOUNT_USER should be provided"
			exit
		fi
	else
		echo "MOUNT_IP should be provided"	
	fi
fi

if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then

    BUILDER_USER=vivado-user
    BUILDER_GROUP=vivado-group

    groupadd -o -g $BUILDER_GID $BUILDER_GROUP 2> /dev/null
    useradd -o -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER 2> /dev/null
    echo "$BUILDER_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$BUILDER_USER

    # Run the command as the specified user/group.
    exec chpst -u :$BUILDER_UID:$BUILDER_GID "$@"
else
    # Just run the command as root.
    exec "$@"
fi
