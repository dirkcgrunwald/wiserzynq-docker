Set up web front with nginx as the reverse proxy to authenticate with ldap servers.
#prepare
1. create nginx docker image with ldap support.
	add certification and key files to auth directory, the names of these two files should be: domain.crt. domain.key
	cd nginx
	docker build -t nginx_ldap .
2. install Flask, redis-py
	sudo pip install Flask
	sudo pip install redis
3. run the system
	./run.sh

#port graph
client--------> nginx(443)-----------------> ldaps 
		 |
		 -----flask(localhost:5000)
