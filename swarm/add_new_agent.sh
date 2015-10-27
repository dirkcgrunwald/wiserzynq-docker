#/bin/bash
#prerequisite
# install docker-machine, cinder and nova(2.31.0 works)
echo "enter agent name:"
read AGENT_NAME
source spectrum-openrc.sh
#launch swarm agent nodes
docker-machine create -d openstack --openstack-flavor-name r620_1_4 --openstack-image-name ubuntu-trusty-150617 --openstack-net-name public --openstack-ssh-user ubuntu --swarm --swarm-discovery token://6b9f2a61187cacd90c221305b74fabad --engine-install-url https://docker.csel.io:7777/get.docker.com ${AGENT_NAME}
# initialize the agent node:
# create a volume in openstack, format it, mount on /var/lib/docker
cinder create 50 --display-name ${AGENT_NAME}
id=`cinder list --name ${AGENT_NAME}|awk 'NR==4'|awk '{print $2}'`
nova volume-attach ${AGENT_NAME} ${id} /dev/vdb
ip=`nova show ${AGENT_NAME}|grep "public network"|awk '{print $5}'`
ssh -i /home/work/nigo9731/.docker/machine/machines/${AGENT_NAME}/id_rsa -o StrictHostKeyChecking=no ubuntu@$ip << EOF
        sudo mkfs.ext4 /dev/vdb
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
        sudo docker login -u $username -p $password --email $email docker.csel.io:7777
EOF

