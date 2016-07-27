#~/bin/bash
# build vivado images based on vivado-base
# arguments:
#	arg1: vivado version, e.g. 2014.4
#	arg2: docker registry server ip, e.g. docker.csel.io:7987
cp ../webfront/RedisHelper.py ./
sed -i -e 's/${version}/'$1'/g' Dockerfile 
sed -i -e 's/${version}/'$1'/g' entrypoint.sh
sudo docker build -t $2/vivado-build$1:1.0 .
sudo docker push $2/vivado-build$1:1.0
