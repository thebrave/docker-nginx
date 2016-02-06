FROM gliderlabs/alpine:3.3
MAINTAINER Jean Berniolles <jean@berniolles.fr>

# init
CMD /config/loop

# Base
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache ca-certificates inotify-tools nano pwgen supervisor \
		unzip wget bash shadow@testing nginx php php-fpm

RUN rm -rf /etc/nginx/*.d && \
	mkdir -p /etc/nginx/addon.d /etc/nginx/conf.d /etc/nginx/host.d \
		/etc/nginx/nginx.d /etc/supervisor/conf.d /var/log/supervisor

ADD config /config
RUN chmod 755 /config/*

ADD etc /etc

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD supervisord-nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisord-php.conf /etc/supervisor/conf.d/php-fpm.conf

EXPOSE 80/tcp
EXPOSE 443/tcp
