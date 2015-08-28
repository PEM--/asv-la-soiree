#!/bin/bash
METEOR_SETTINGS=$(cat /app/settings.json) pm2 start -s --no-daemon --no-vizion main.js
