FROM vivado-base${version}:1.0

RUN apt-get update && apt-get install -y make sshfs python python-numpy python-pip lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6; \
	mkdir /vivado; \
	chmod -R a+rw /vivado;

RUN pip install redis

WORKDIR /vivado/
RUN mkdir -p /home/vivado-user/.ssh;\
	chmod -R a+rwx /home/vivado-user; \
	chmod -R a+rw /root/.Xilinx; \
	mkdir /vivado/build; \
	chmod -R a+rw /vivado/build

RUN printf "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/vivado-user/.ssh/config
	
COPY sshkeys/id_rsa /home/vivado-user/.ssh/
RUN chmod 644 /home/vivado-user/.ssh/id_rsa;
	
COPY entrypoint.sh \
	/vivado/
RUN chmod a+x /vivado/entrypoint.sh; 

COPY RedisHelper.py \
	/vivado/build/

COPY StartBuild.py \
	/vivado/build/

ENTRYPOINT ["/vivado/entrypoint.sh"]

RUN chmod -R a+rwx /root
