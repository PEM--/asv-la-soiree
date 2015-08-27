#!/bin/bash
set
export METEOR_SETTINGS=$(cat /app/settings.json)
node main.js
