#!/bin/bash
gosu mongodb mongod -f /etc/mongod.conf &
sleep 2
mongo admin --quiet --eval "rs.initiate(); rs.conf(); db.shutdownServer({timeoutSecs: 0});"
sync
sleep 2
killall -9 mongod
gosu mongodb mongod -f /etc/mongod.conf
