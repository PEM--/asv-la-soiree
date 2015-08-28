#!/bin/bash
rm -rf bundle
cd ../../app
meteor build --architecture os.linux.x86_64 --directory ../docker/meteor/
cd -
cp ../../app/production.json bundle/settings.json
