#!/bin/bash
# H.264 - no audio
ffmpeg -y -i ./asv-la-soiree-ballons.mp4 -vcodec libx264 -preset veryslow -an -f mp4 ../app/public/asv-la-soiree-ballons.mp4
