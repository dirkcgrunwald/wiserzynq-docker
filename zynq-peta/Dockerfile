FROM wiserzynq-base
MAINTAINER grunwald@cs.colorado.edu

WORKDIR /pkg/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tofrodos \
    iproute \
    gawk \
    make \
    net-tools \
    ncurses-dev \
    tftp tftpd \
    zlib1g-dev \
    flex \
    bison \
    expect

COPY imagefiles/xinetd.tftpd /etc/xinetd.d/tftpd
RUN mkdir -p /tftpboot ; \
    chmod -R 777 /tftpboot ; \
    chown -R nobody /tftpboot ; \
    service xinetd restart
EXPOSE 69/udp

ADD Avnet-Digilent-ZedBoard-v2014.4-final.bsp \
    petalinux-v2014.4-final-installer.run imagefiles/script.exp /pkg/

## The Xilinx peta-linux tools require /bin/bash rather than /bin/dash
## or some of the scripts fail. This is lame but reality.

RUN rm /bin/sh ; ln -s /bin/bash /bin/sh 

##
## Need to insure that a valid TERM is set or the license display objects
##
RUN export TERM=vt100; \
    expect /pkg/script.exp ; \
    rm /pkg/petalinux-v2014.4-final-installer.run ; \
    rm /pkg/petalinux_installation_log ; \
    . /pkg/petalinux-v2014.4-final/settings.sh ; \
    echo $PETALINUX ; \
    petalinux-util --webtalk off 
