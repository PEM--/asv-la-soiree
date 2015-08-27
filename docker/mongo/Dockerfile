# Based on: https://github.com/docker-library/mongo/blob/d5aca073ca71a7023e0d4193bd14642c6950d454/3.0/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

USER root

# Update system
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl numactl apt-utils psmisc && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install the necessary packages
# Grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu

# Install MongoDB
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb
# gpg: key 7F0CEB10: public key "Richard Kreuter <richard@10gen.com>" imported
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10
ENV MONGO_MAJOR 3.0
ENV MONGO_VERSION 3.0.6
RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list
RUN set -x && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends \
      mongodb-org=$MONGO_VERSION \
      mongodb-org-server=$MONGO_VERSION \
      mongodb-org-shell=$MONGO_VERSION \
      mongodb-org-mongos=$MONGO_VERSION \
      mongodb-org-tools=$MONGO_VERSION && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/mongodb && \
    mv /etc/mongod.conf /etc/mongod.conf.orig && \
    apt-get autoremove -y && \
    apt-get autoclean -y

# Prepare environment for Mongo daemon: Use a Docker Volume container
RUN mkdir -p /db && chown -R mongodb:mongodb /db
VOLUME /db

# Step1: Initialize a first configuration allowing:
# * Set the DB into an accessible mode for the command line
# * Create an initial ReplicaSet for OPLOG
# Note that the regular stop of the service doesn't work properly so we
# circumvent this by killing the service as properly as possible.
COPY mongod.conf /etc/mongod.conf
RUN service mongod stop && \
    service mongod start && \
    mongo --eval "rs.initiate(); rs.conf();" && \
    sync && \
    sleep 5 && \
    killall -9 mongod && \
    service mongod stop

# Step2: Initialize a second configuration allowing:
# * Binding to localhost so that only linked container can access to this instance.
RUN sed -i -e "s/^  # bindIp: 127.0.0.1/  bindIp: 127.0.0.1/" /etc/mongod.conf
CMD ["mongod", "-f", "/etc/mongod.conf"]
