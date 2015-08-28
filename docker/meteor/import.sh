#!/bin/bash
rm -rf bundle
cd ../../app
#demeteorizer -o ../docker/meteor/bundle -a asv_la_soiree
#meteor build --architecture os.linux.x86_64 ../docker/meteor/
#meteor build --architecture os.linux.x86_64 --directory ../docker/meteor/
meteor build --architecture os.linux.x86_64 --directory --debug ../docker/meteor/
cd -
cp ../../app/production.json bundle/settings.json
