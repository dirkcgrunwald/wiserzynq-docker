FROM vivado-base${vivado-version, e.g. 2014-4}:1.0

RUN apt-get update && apt-get install -y make sshfs python python-numpy lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6; \
	mkdir /vivado; \
	chmod -R a+rw /vivado;

WORKDIR /vivado/
RUN chmod -R a+rwx /root; \
	chmod -R a+rw /root/.Xilinx; \
	mkdir /root/.ssh; \
	mkdir /vivado/build; \
	chmod -R a+rw /vivado/build
	
COPY sshkeys/id_rsa /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa;
	
COPY entrypoint.sh \
	/vivado/
RUN chmod a+x /vivado/entrypoint.sh; 

ENTRYPOINT ["/vivado/entrypoint.sh"]
