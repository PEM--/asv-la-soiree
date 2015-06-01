#!/bin/bash
mongo admin --eval \
  "db.addUser({ user: 'admin', pwd: 'admin', roles: ['userAdminAnyDatabase', 'readWriteAnyDatabase', 'dbAdminAnyDatabase', 'clusterAdmin'] });
  db = db.getSiblingDB('eportfolio');
  db.addUser({user: 'admin', pwd: 'admin', roles: ['readWrtite']});"

mongo admin -u admin -p admin \
  --eval "rs.initiate(); rs.status(); db.addUser({ user:'oplogger', pwd:'admin', roles:[], otherDBRoles:{ local: ['read'] }});"
