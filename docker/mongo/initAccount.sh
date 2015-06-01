#!/bin/bash
mongod -f /etc/mongodb.conf --smallfiles &
sleep 5
mongo admin --eval "
  db.createUser({
    user: 'admin',
    pwd: 'admin',
    roles: [
      'dbAdmin',
      'readWrite',
      'clusterAdmin',
      'userAdmin',
      'userAdminAnyDatabase',
      'readWriteAnyDatabase',
      'dbAdminAnyDatabase',
      {role: 'root', db: 'admin'}
    ]
  });
"
mongo admin -u admin -p admin --eval "
  db = db.getSiblingDB('$PROJECT_NAME');
  db.createUser({
    user: '$PROJECT_NAME',
    pwd: '$PROJECT_NAME',
    roles: [
      {role: 'readWrite', db: '$PROJECT_NAME'}
    ]
  });
"
sleep 5
sync
killall mongod
