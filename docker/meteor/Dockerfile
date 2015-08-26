# https://github.com/joyent/docker-node/blob/787d816f90dc1bf933b6503b876bdeb752b24f96/0.10/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

USER root

# Update system
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl numactl apt-utils psmisc && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get autoclean -y

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && \
    apt-get install -y -q --no-install-recommends \
      apt-utils \
      curl \
      apt-transport-https \
      build-essential \
      ca-certificates \
      curl \
      git \
      libssl-dev \
      python \
      rsync \
      software-properties-common \
      wget && \
    rm -rf /var/lib/apt/lists/*

# Install nvm with node, npm and nvm
ENV NVM_DIR /usr/local/nvm
ENV MVM_VERSION 0.28.1
ENV NODE_VERSION 0.10.40
RUN curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Import sources
ADD bundle /app
WORKDIR /app

# Environment variables
EXPOSE 3000

# Set environment variables for Meteor
#ENV MONGO_URL "mongodb://mongo-asv_la_soiree:27017"
# MONGO_OPLOG_URL="mongodb://oplog_url"
ENV PORT 3000
ENV ROOT_URL http://localhost:3000

# Install Meteor's dependencies
RUN npm install

# Launch application
COPY startMeteor.sh /app/startMeteor.sh
CMD ["./startMeteor.sh"]
