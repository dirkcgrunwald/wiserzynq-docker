FROM vivado-base${version}:1.0

RUN apt-get update && apt-get install -y make sshfs python python-numpy; \
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
