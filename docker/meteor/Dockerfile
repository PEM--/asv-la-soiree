# Based on: https://github.com/joyent/docker-node/blob/master/0.10/wheezy/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

USER root

# Update system
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
      # CURL
      ca-certificates curl wget \
      # SCM
      bzr git mercurial openssh-client subversion && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# ENV NODE_VERSION 0.10.40
# ENV NPM_VERSION 2.13.3
#
# RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
#     curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
#     gpg --verify SHASUMS256.txt.asc && \
#     grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && \
#     tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
#     rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc && \
#     npm install -g npm@"$NPM_VERSION" && \
#     npm cache clear

# # Import sources
# ADD bundle /app
# WORKDIR /app
#
# # Environment variables
# EXPOSE 3000
#
# # Set environment variables for Meteor
# #ENV MONGO_URL "mongodb://mongo-asv_la_soiree:27017"
# # MONGO_OPLOG_URL="mongodb://oplog_url"
# ENV PORT 3000
# ENV ROOT_URL http://localhost:3000
#
# # Install Meteor's dependencies
# RUN npm install
#
# # Launch application
# COPY startMeteor.sh /app/startMeteor.sh
# CMD ["./startMeteor.sh"]
