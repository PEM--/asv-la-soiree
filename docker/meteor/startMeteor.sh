#!/bin/bash
export METEOR_SETTINGS=$(cat /app/production.json)
node main.js
