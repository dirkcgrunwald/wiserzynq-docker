Docker module to package the Xilinx LMGR. The Xilinx/FlexLM license
server depends on having the lsb-core package installed, which you
may not way.

This docker container uses the --net=host network. You need to allocate
your Xilinx/Flex license using the IP address and MAC of your host.

You then start the docker container using
    /usr/bin/docker run --name=xilinx-lmgr --net=host -d -t wiserzynq-lm

you can check on the log using
    /usr/bin/docker logs xilinx-lmgr

When building the container,  need to retrieve a copy of
     linux_flexlm_v11.11.0_201503.zip
and your license file named
    Xilinx.lic

To check status of licenses (on the server host or another),
you can run

    /usr/bin/docker run --rm -i -t wiserzynq-lm /opt/opt/linux_flexlm_v11.11.0_201503/lnx64.o/lmgrd lmstat -c 2100@your-server host


