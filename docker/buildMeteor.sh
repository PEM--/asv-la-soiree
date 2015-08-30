#!/bin/bash
rm -rf meteor/bundle nginx/bundle
cd ../app
meteor build --architecture os.linux.x86_64 --directory ../docker/meteor
cd -
cp ../app/production.json meteor/bundle/settings.json
cp -R meteor/bundle nginx
