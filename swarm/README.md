set up swarm cluster for fair scheduling
follow the instructions here

1. create swarm token and record it
	docker run swarm create

2. launch swarm master and agent nodes
	download openstack rc file name as spectrum-openrc.sh
	install docker-machine
	refer to add_new_agent.sh
	choose add master or agent; then input name, follow name conventions like swarm-master, swarm-agent-00, swarm-agent-01

3. set up environment to talk to docker in master(or append the following command in bashrc for convenience)
	this is tls protected by default
	eval $(docker-machine env --swarm swarm-master)


FAQ
1. swarm master doesn't discover new nodes even if the remote discover server list it.
	#check if the remote server has the new node config
	sudo docker run --rm swarm list token://*
	#login to the master
	sudo docker kill swarm-agent-master
	docker run -t -p 3376:3376 -v /etc/docker:/etc/docker --name="swarm-agent-master" -t swarm manage --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:3376 --strategy spread token://*

2. sshfs
	#check vivado-build files for sshfs set up.

3. docker pull hangs
	#restart docker daemon and swarm manager at manager node.
