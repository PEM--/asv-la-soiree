FROM debian:latest
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

USER root

# Update system
RUN apt-get update
RUN apt-get install -y apt-utils psmisc
RUN apt-get autoremove

# Install the necessary packages
RUN apt-key adv --keyserver 'keyserver.ubuntu.com' --recv '7F0CEB10'
# @NOTE Mongo isn't present in Jessie yet. We import and fix the one from Wheezy
RUN echo 'deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main' | tee '/etc/apt/sources.list.d/mongodb-org-3.0.list'
RUN apt-get update
RUN apt-get install -y mongodb-org

# Prepare environment for Mongo daemon: Use a Docker Volume container
VOLUME /db

# Create admin account, eportfolio DB and eportfolio user
ENV PROJECT_NAME eportfolio
COPY mongodbInit.conf /etc/mongodb.conf
# COPY initAccount.sh /initAccount.sh
# RUN /initAccount.sh
# RUN rm /initAccount.sh

# Create the replica set and the oplog account
#COPY mongodb.conf /etc/mongodb.conf
#COPY initReplicaset.sh /initReplicaset.sh
#RUN /initReplicaset.sh
# RUN rm /initReplicaset.sh

# Not necessary but clearer in development
EXPOSE 27017

# Launch Mongo
CMD ["mongod", "-f", "/etc/mongodb.conf", "--smallfiles"]
