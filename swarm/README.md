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




FAQ
1. swarm master doesn't discover new nodes even if the remote discover server list it.
	#check if the remote server has the new node config
	sudo docker run --rm swarm list token://6b9f2a61187cacd90c221305b74fabad
	#login to the master
	sudo docker kill swarm-agent-master
	docker run -t -p 3376:3376 -v /etc/docker:/etc/docker --name="swarm-agent-master" -t swarm manage --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:3376 --strategy spread token://6b9f2a61187cacd90c221305b74fabad

2. sshfs
	#check vivado-build files for sshfs set up.

3. docker pull hangs
	#restart docker daemon and swarm manager at manager node.
