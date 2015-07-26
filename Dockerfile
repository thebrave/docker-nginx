FROM thebrave/rpi-jessie:latest
MAINTAINER Jean Berniolles <jean@berniolles.fr>

# init
CMD /config/loop

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install -y ca-certificates inotify-tools supervisor \
		unzip wget \
		nginx \
		php5-cli php5-curl php5-fpm php5-gd php5-mcrypt \
		php5-mysql php5-pgsql php5-sqlite \
	&& apt-get clean \
	&& echo -n > /var/lib/apt/extended_states \
  && rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/nginx/*.d && /etc/php5/fpm/pool.d \
	mkdir -p /etc/nginx/addon.d /etc/nginx/conf.d /etc/nginx/host.d \
		/etc/nginx/nginx.d /etc/php5/fpm/pool.d

ADD config /config
RUN chmod 755 /config/*

ADD etc /etc

ADD supervisord-nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisord-php.conf /etc/supervisor/conf.d/php-fpm.conf

EXPOSE 80/tcp
EXPOSE 443/tcp
