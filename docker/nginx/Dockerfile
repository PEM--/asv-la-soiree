# Based on: https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

# Add NGinx official repository
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list
ENV NGINX_VERSION 1.9.4-1~wheezy

# Update system
ENV DEBIAN_FRONTEND noninteractive
RUN groupadd -r www && \
    useradd -r -g www www && \
    apt-get update && \
    apt-get upgrade -qq -y --no-install-recommends && \
    apt-get install -qq -y --no-install-recommends \
      ca-certificates nginx=${NGINX_VERSION} && \
    apt-get autoremove -qq -y && \
    apt-get autoclean -qq -y && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Configuration
COPY h5bp-nginx-cfg/nginx.conf /etc/nginx/nginx.conf
COPY h5bp-nginx-cfg/mime.types /etc/nginx/mime.types
COPY h5bp-nginx-cfg/h5bp /etc/nginx/h5bp
COPY h5bp-nginx-cfg/sites-available/default.conf /etc/nginx/conf.d/default.conf

# Mount points for volumes
RUN mkdir -p /etc/certs /var/cache/nginx  /var/tmp

# Source
# Raw source files exposed as HTTP
ADD raw /www
# Project files exposed as HTTPS
ADD public /wwws

# Ensure proper rights on statis assets
RUN chown -R www:www /www /wwws /var/cache /var/tmp

# Launch NGinx
CMD ["nginx", "-g", "daemon off;"]
