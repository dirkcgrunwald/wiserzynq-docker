FROM wiserzynq-base
MAINTAINER grunwald@cs.colorado.edu

RUN apt-get update && apt-get install -y \
    lsb-core \
    unzip

COPY linux_flexlm_v11.11.0_201503.zip  \
     imagefiles/entrypoint.sh \
     Xilinx.lic \
     /opt/

RUN  cd /opt/ ; \
     unzip linux_flexlm_v11.11.0_201503.zip ; \
     rm linux_flexlm_v11.11.0_201503.zip ; \
     chmod ugo+x /opt/entrypoint.sh ;

ENTRYPOINT ["/opt/entrypoint.sh"]
