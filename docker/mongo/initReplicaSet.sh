#!/bin/bash
if [ ! -f /var/db/replicasetInitialized ]; then
  echo "Initializing ReplicaSet"
  gosu mongodb mongod -f /etc/mongod.conf &
  sleep 2
  mongo admin --eval "rs.initiate(); rs.conf(); db.shutdownServer({timeoutSecs: 1});"
  touch /var/db/replicasetInitialized
fi
gosu mongodb mongod -f /etc/mongod.conf
