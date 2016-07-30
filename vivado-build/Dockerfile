FROM vivado-base${version}:1.0

RUN apt-get update && apt-get install -y make sshfs python python-numpy python-pip lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6;
RUN pip install redis

RUN mkdir -p /vivado/build; \
	chmod -R a+rwx /vivado;\
	mkdir -p /home/vivado-user/.ssh;\
	chmod -R a+rwx /home/vivado-user; 

RUN printf "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/vivado-user/.ssh/config
	
COPY sshkeys/id_rsa /home/vivado-user/.ssh/
COPY entrypoint.sh \
	/vivado/
COPY ENV /vivado/ENV
COPY RedisHelper.py StartBuild.py\
	/vivado/build/

RUN chmod 644 /home/vivado-user/.ssh/id_rsa;\
	chmod a+x /vivado/entrypoint.sh; 

ENTRYPOINT ["/vivado/entrypoint.sh"]
WORKDIR /vivado

