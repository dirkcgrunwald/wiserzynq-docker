#!/bin/bash
# arguments
#	arg1: ldap server ip
#	arg2: this server dns name
#	arg3: redis server ip
#	arg4: redis server port
#	arg5: redis password
script_path=`realpath $0`
script_dir=`dirname $script_path`
script_dir_adjusted=`echo $script_dir | sed -e 's/\//\\\\\//g'`
cd nginx
docker build -t nginx_ldap .
sudo pip install Flask
sudo pip install redis
cp auth/registry.conf.sample auth/registry.conf
sed -i -e 's/${ldap_server_ip}/'$1'/g' auth/registry.conf
sed -i -e 's/${server_url}/'$2'/g' auth/registry.conf
cp docker-compose.yml.sample docker-compose.yml
sed -i -e 's/${auth_directory}/'$script_dir_adjusted'\/auth\//g' docker-compose.yml
sed -i -e 's/${registry_conf}/'$script_dir_adjusted'\/auth\/registry.conf/g' docker-compose.yml
cp RedisHelper.py.sample RedisHelper.py
sed -i -e 's/${redis_ip}/'$3'/g' RedisHelper.py
sed -i -e 's/${redis_port}/'$4'/g' RedisHelper.py
sed -i -e 's/${redis_pass}/'$5'/g' RedisHelper.py
