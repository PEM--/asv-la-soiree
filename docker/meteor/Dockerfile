# Based on: https://github.com/joyent/docker-node/blob/master/0.10/wheezy/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

# Update system
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -qq -y --no-install-recommends && \
    apt-get install -qq -y --no-install-recommends \
      # CURL
      ca-certificates curl wget \
      # SCM
      bzr git mercurial openssh-client subversion \
      # Build
      build-essential && \
    apt-get autoremove -qq -y && \
    apt-get autoclean -qq -y && \
    rm -rf /var/lib/apt/lists/*

# Install NodeJS
# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN set -ex \
  && for key in \
  7937DFD2AB06298B2293C3187D33FF9D0246406D \
    114F43EE0176B71C7BC219DD50A3051F888C628D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done
ENV NODE_VERSION 0.10.40
ENV NPM_VERSION 2.13.3
RUN curl -sSLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    curl -sSLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --verify SHASUMS256.txt.asc && \
    grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc && \
    npm install -g npm@"$NPM_VERSION" && \
    npm cache clear

# Add PM2 for process management and restart
RUN npm install -g pm2

# Import sources
ADD bundle /app
WORKDIR /app

# Install Meteor's dependencies
RUN (cd programs/server && npm install)

EXPOSE 3000

# Set environment variables for Meteor
ENV PORT 3000
ENV ROOT_URL "http://192.168.1.50:$PORT"

# Launch application
COPY startMeteor.sh /app/startMeteor.sh
CMD ["./startMeteor.sh"]
