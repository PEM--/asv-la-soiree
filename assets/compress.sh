#!/bin/bash
# H.264 - no audio
ffmpeg -y -i ./asv-la-soiree-ballons.mp4 -vcodec libx264 -preset veryslow -an -f mp4 ../app/public/asv-la-soiree-ballons.mp4
# Extract a default image for talbets and smartphones
ffmpeg -ss 00:00:03 -i ../app/public/asv-la-soiree-ballons.mp4 -frames 1 ./asv-la-soiree-ballons.jpg
convert -strip -interlace Plane -quality 80 ./asv-la-soiree-ballons.jpg ../app/public/asv-la-soiree-ballons.jpg
