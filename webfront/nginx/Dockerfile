# TODO - matt: nginx in a container should not need privs
FROM ubuntu:14.04 

MAINTAINER Henrik Sachse <t3x7m3@posteo.de>
MAINTAINER Ning Gao

ENV NGINX_VERSION release-1.7.12

RUN apt-get update \
	&& apt-get install -y \
		ca-certificates \
		git gcc make libpcre3-dev zlib1g-dev libldap2-dev libssl-dev

# See http://wiki.nginx.org/InstallOptions
RUN mkdir /var/log/nginx \
	&& mkdir /etc/nginx \
	&& cd ~ \
	&& git clone https://github.com/kvspb/nginx-auth-ldap.git --single-branch --depth=1 \
	&& git clone https://github.com/nginx/nginx.git --branch=${NGINX_VERSION} --single-branch --depth=1 \
	&& cd ~/nginx \
	&& ./auto/configure \
		--add-module=/root/nginx-auth-ldap \
		--with-http_ssl_module \
		--with-debug \
		--conf-path=/etc/nginx/nginx.conf \ 
		--sbin-path=/usr/sbin/nginx \ 
		--pid-path=/var/log/nginx/nginx.pid \ 
		--error-log-path=/var/log/nginx/error.log \ 
		--http-log-path=/var/log/nginx/access.log \ 
	&& make install \
	&& cd ~ \
	&& rm -rf nginx-auth-ldap \
	&& rm -rf nginx \
	&& apt-get remove -y --purge git gcc make \
	&& apt-get autoremove -y --purge \
	&& apt-get clean -y

EXPOSE 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
