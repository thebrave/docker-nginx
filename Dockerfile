FROM debian:jessie
MAINTAINER Jean Berniolles <jean@berniolles.fr>

# init
CMD /config/loop
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y dist-upgrade

# Base
RUN apt-get install -y ca-certificates inotify-tools nano pwgen supervisor \
	unzip wget

# Nginx
RUN apt-get install -y nginx

# PHP5
RUN apt-get install -y php5-cli php5-curl php5-fpm php5-gd php5-mcrypt \
	php5-mysql php5-pgsql php5-sqlite

# Cleanup
RUN apt-get clean && \
	echo -n > /var/lib/apt/extended_states

RUN rm -rf /etc/nginx/addon.d /etc/php5/fpm/pool.d && \
	mkdir -p /etc/nginx/addon.d /etc/php5/fpm/pool.d

RUN rm -rf /etc/nginx/*.d && \
	mkdir -p /etc/nginx/addon.d /etc/nginx/conf.d /etc/nginx/host.d \
		/etc/nginx/nginx.d

ADD config /config
ADD etc /etc

ADD supervisord-nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisord-php.conf /etc/supervisor/conf.d/php-fpm.conf

EXPOSE 80/tcp
EXPOSE 443/tcp
