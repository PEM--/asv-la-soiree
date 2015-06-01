#!/bin/bash
rm -rf bundle
cd ../../app
demeteorizer -o ../docker/meteor/bundle -a asv_la_soiree
cd -
cp ../../app/production.json bundle/settings.json
