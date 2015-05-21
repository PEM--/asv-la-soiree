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
coverOut='../app/public/videos/lyon-festival-light.jpg'
coverOut='../app/public/videos/lyon-festival-light.jpg'

# H.264 - no audio
# ffmpeg -y -i $videoIn -vcodec libx264 -preset veryslow -an -f mp4 $videoOut
# Extract a default image for talbets and smartphones
# ffmpeg -ss $timeStamp -i $videoOut -frames 1 $tmpCover
convert -strip -interlace Plane -quality 80 $tmpCover $coverOut

# Create assets for small screens
#convert -strip -interlace Plane -quality 80 $tmpCover $coverOut

#jpegoptim --strip-all
