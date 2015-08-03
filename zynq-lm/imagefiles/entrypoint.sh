#!/bin/bash


#
# Create a user to run the license manager
#

LICENSE_USER=lmadmin

useradd $LICENSE_USER 
mkdir -p /usr/tmp/.flexlm
chown -R $LICENSE_USER:$LICENSE_USER /opt /usr/tmp/.flexlm

# Run the command as the specified user/group.
if [[ $# == 0 ]]; then
  chpst -u $LICENSE_USER /opt/linux_flexlm_v11.11.0_201503/lnx64.o/lmgrd -l /tmp/lmgrd.log -c /opt/Xilinx.lic
  tail -f /tmp/lmgrd.log
else
  exec "$@"
fi
