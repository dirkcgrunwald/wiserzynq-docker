FROM vivado-base

RUN apt-get update && apt-get install make; \
	mkdir /vivado; \
	chmod -R a+rw /vivado;
WORKDIR /vivado/
COPY entrypoint.sh \
	/vivado/

RUN chmod a+x /vivado/entrypoint.sh; \
	chmod -R a+rw /opt/Xilinx/Vivado/2014.4; \
	chmod -R a+rx /root; \
	chmod -R a+rw /root/.Xilinx;
	
ENTRYPOINT ["/vivado/entrypoint.sh"]
