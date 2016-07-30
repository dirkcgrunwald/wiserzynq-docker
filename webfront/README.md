Set up web front with nginx as the reverse proxy to authenticate with ldap servers.
1. add auth files
	add certification and key files to auth directory, the names of these two files should be: domain.crt. domain.key
2. run setup.sh ${ldap_server_ip} ${server dns name}
3. replace ${restriction} in the auth/registry.conf with proper restrictions for ldaps server 
3. set up redis server
	follow instructions online
4. run the system
	./run.sh

#port graph
client--------> nginx(443)-----------------> ldaps 
		 |
		 -----flask(localhost:5000)

Important
1. make sure docker client api version matches swarm server spi version
