#!/bin/bash
mongod -f /etc/mongodb.conf --smallfiles &
sleep 5
mongo admin -u admin -p admin --eval "
  rs.initiate();
  rs.status();
  db.createUser({user:'oplog', pwd:'admin', roles: [{role: 'read', db: 'local'}]})
"
sleep 5
sync
killall mongodb
