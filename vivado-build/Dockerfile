FROM vivado-base

WORKDIR /vivado/
COPY entrypoint.sh \
	/vivado/

RUN chmod a+x /vivado/entrypoint.sh; \
	chmod -R a+w /opt/Xilinx/Vivado/2014.4; \
	chmod a+x /root; \
	chmod -R a+w /root/.Xilinx;
	
ENTRYPOINT ["/vivado/entrypoint.sh"]
