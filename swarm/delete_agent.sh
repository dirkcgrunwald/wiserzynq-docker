#/bin/bash
echo "enter name:"
read AGENT_NAME
source spectrum-openrc.sh

id=`cinder list --name ${AGENT_NAME}|awk 'NR==4'|awk '{print $2}'`
nova volume-detach $AGENT_NAME $id
docker-machine kill $AGENT_NAME
docker-machine rm $AGENT_NAME
cinder delete $AGENT_NAME
