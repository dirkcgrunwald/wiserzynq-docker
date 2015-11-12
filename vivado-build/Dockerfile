FROM vivado-base

RUN apt-get update && apt-get install -y make sshfs; \
	mkdir /vivado; \
	chmod -R a+rw /vivado;

WORKDIR /vivado/
COPY entrypoint.sh \
	/vivado/

RUN chmod a+x /vivado/entrypoint.sh; \
	chmod -R a+rw /opt/Xilinx/Vivado/2014.4; \
	chmod -R a+rx /root; \
	chmod -R a+rw /root/.Xilinx; \
	mkdir /root/.ssh; \
	mkdir /vivado/build; \
	chmod -R a+rw /vivado/build
	
COPY sshkeys/id_rsa /root/.ssh/
 
RUN chmod 600 /root/.ssh/id_rsa;
	
ENTRYPOINT ["/vivado/entrypoint.sh"]
