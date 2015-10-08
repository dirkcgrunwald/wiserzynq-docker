#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# If we are running docker natively, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# If we are running from boot2docker, this is not necessary.

. /opt/Xilinx/Vivado/2014.4/settings64.sh

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
