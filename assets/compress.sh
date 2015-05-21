#!/bin/bash

# Old video
# videoIn='./asv-la-soiree-ballons.mp4'
# videoOut='../app/public/videos/asv-la-soiree-ballons.mp4'
# timeStamp='00:00:03'
# tmpCover='./asv-la-soiree-ballons.jpg'
# coverOut='../app/public/videos/asv-la-soiree-ballons.jpg'

# New video
videoIn='./lyon-festival-light.mp4'
videoOut='../app/public/videos/lyon-festival-light.mp4'
timeStamp='00:00:03'
tmpCover='./lyon-festival-light.jpg'
# 720P
cover='../app/public/videos/lyon-festival-light.jpg'
# 800x640
coverMedium='../app/public/videos/lyon-festival-light-medium.jpg'
# 320x256
coverSmall='../app/public/videos/lyon-festival-light-small.jpg'
# Quality settings
quality=75

# H.264 - no audio
ffmpeg -y -i $videoIn -vcodec libx264 -preset veryslow -an -f mp4 $videoOut
# Extract a default image for talbets and smartphones
ffmpeg -ss $timeStamp -i $videoOut -frames 1 $tmpCover
convert $tmpCover -strip -interlace Plane -quality $quality $cover
convert $tmpCover -strip -interlace Plane -quality $quality -resize 800x640 $coverMedium
convert $tmpCover -strip -interlace Plane -quality $quality -resize 320x256 $coverSmall
# Create assets for small screens
jpegoptim --all-progressive -o -p -m $quality --strip-all $cover $coverMedium $coverSmall
