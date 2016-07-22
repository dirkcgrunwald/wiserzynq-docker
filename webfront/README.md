Set up web front with nginx as the reverse proxy to authenticate with ldap servers.
#prepare
create nginx docker image with ldap support.
	cd nginx
	docker build -t nginx_ldap .
add certification and key files to auth directory, the names of these two files should be: domain.crt. domain.key
install Flask
	sudo pip install Flask
run the system
	./run.sh

#port graph
               ----------------------------------------
              |			docker                |
client-------->             -------------	      |
              |        ssl  |     nginx |             |
              |        --> 443          |______________________>LDAP
    	      |   	     -----------	      |
	      |			  |		      |
	      |		    -----5000-----            |
	      |		    |    webfront|	      |
	      |		     ------------  	      |
	      ----------------------------------------
