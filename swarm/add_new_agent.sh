#/bin/bash
#prerequisite
# install docker-machine, cinder and nova(2.31.0 works)
# run the "docker login" command a couple of times manually if the script output errors.

echo "master or agent:0(master), 1(agent)"
read ISMASTER
echo "enter name:"
read AGENT_NAME
source spectrum-openrc.sh
#launch swarm agent nodes
#master
if [ $ISMASTER == "0" ]; then
	echo "creating master"
	docker-machine create -d openstack --openstack-flavor-name r620_1_4 --openstack-image-name ubuntu-trusty-150617 --openstack-net-name public --openstack-ssh-user ubuntu --swarm --swarm-master --swarm-discovery token://* ${AGENT_NAME}
else
	echo "creating agent"
	docker-machine create -d openstack --openstack-flavor-name r620_1_4 --openstack-image-name ubuntu-trusty-150617 --openstack-net-name public --openstack-ssh-user ubuntu --swarm --swarm-discovery token://* ${AGENT_NAME}
fi
# initialize the agent node:
# create a volume in openstack, format it, mount on /var/lib/docker
cinder create 50 --display-name ${AGENT_NAME}
id=`cinder list --name ${AGENT_NAME}|awk 'NR==4'|awk '{print $2}'`
nova volume-attach ${AGENT_NAME} ${id} /dev/vdb
ip=`nova show ${AGENT_NAME}|grep "public network"|awk '{print $5}'`
# wait for the volume to be detected, or else it will show "device not found /dev/vdb" when mkfs.ext4 is run
sleep 2
ssh -i ${HOMEDIR}/.docker/machine/machines/${AGENT_NAME}/id_rsa -o StrictHostKeyChecking=no ubuntu@$ip << EOF
        sudo mkfs.ext4 -q /dev/vdb
	sudo mount /dev/vdb /mnt
	sudo service docker stop
	sudo cp -R /var/lib/docker /mnt/
	sudo chmod -R a+rx /mnt
	sudo mv /mnt/docker/* /mnt/
	sudo rm -rf /mnt/docker
	sudo umount /mnt
        sudo mount /dev/vdb /var/lib/docker
	sudo service docker start
	sleep 2
        sudo docker login -u swarm -p ${password} --email ${email} ${docker_registry_url}
EOF
