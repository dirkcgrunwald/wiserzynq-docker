set up swarm cluster for fair scheduling
follow the instructions here

#create swarm token and record it
docker run swarm create

#source openstack authentication
source *.sh 
#launch swarm master
docker-machine create -d openstack --openstack-flavor-name r620_1_4 --openstack-image-name ubuntu-trusty-150617 --openstack-net-name public --openstack-ssh-user ubuntu --swarm --swarm-master --swarm-discovery token://6b9f2a61187cacd90c221305b74fabad --engine-install-url https://docker.csel.io:7777/get.docker.com swarm-master

#launch swarm agent nodes
#refer to add_new_agent.sh
#at the same time, repeat the steps for volume initialization at swarm master, too

#set up environment to talk to docker in master
#this is tls protected by default
eval $(docker-machine env --swarm swarm-master)



