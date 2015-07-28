FROM wiserzynq-base
MAINTAINER grunwald@cs.colorado.edu

WORKDIR /wzxc/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tofrodos \
    iproute \
    gawk \
    make \
    net-tools \
    ncurses-dev \
    tftp tftpd \
    libssl-dev zlib1g-dev lib32z1 unzip \
    flex \
    bison \
    expect \
    runit \
    bc \
    emacs24-nox


COPY imagefiles/xinetd.tftpd /etc/xinetd.d/tftpd
RUN mkdir -p /tftpboot ; \
    chmod -R 777 /tftpboot ; \
    chown -R nobody:nogroup /tftpboot ; \
    ln -s /etc/init.d/xinetd /etc/rc5.d/S40xinetd ; \
    /etc/init.d/xinetd restart ;
EXPOSE 69/udp

ENV HOST=arm-xilinx-linux-gnueabi \
    TOOLCHAIN=petalinux-v2015.2-final/tools/linux-i386/arm-xilinx-linux-gnueabi

# I'd put all these into the same ENV command, but you cannot define and use
# a var in the same command.
ENV ARCH=arm \
    TOOLCHAIN_ROOT=/wzxc/$TOOLCHAIN \
    CROSS_COMPILE=/wzxc/$TOOLCHAIN/bin/$HOST-
ENV AS=${CROSS_COMPILE}as \
    AR=${CROSS_COMPILE}ar \
    CC=${CROSS_COMPILE}gcc \
    CPP=${CROSS_COMPILE}cpp \
    CXX=${CROSS_COMPILE}g++ \
    LD=${CROSS_COMPILE}ld


ADD Avnet-Digilent-ZedBoard-v2015.2-final.bsp /built/
COPY petalinux-v2015.2-final-installer.run \
    imagefiles/accept-15.2.exp \
    imagefiles/entrypoint.sh \
    imagefiles/wzxc \
    /wzxc/

## The Xilinx peta-linux tools require /bin/bash rather than /bin/dash
## or some of the scripts fail. This is lame but reality.

RUN rm /bin/sh ; ln -s /bin/bash /bin/sh 

##
## Need to insure that a valid TERM is set or the license display objects
##
RUN export TERM=vt100; \
    expect /wzxc/accept-15.2.exp ; \
    rm /wzxc/petalinux-v2015.2-final-installer.run ; \
    rm /wzxc/petalinux_installation_log ; \
    . /wzxc/petalinux-v2015.2-final/settings.sh ; \
    echo $PETALINUX ; \
    petalinux-util --webtalk off ; \
    cd /built/Avnet-Digilent-ZedBoard-2015.2 ; \
    petalinux-build

WORKDIR /build
ENTRYPOINT ["/wzxc/entrypoint.sh"]
