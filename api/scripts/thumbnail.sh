#!/bin/sh
set -e

now=$(/bin/date +%s)
mkdir -p /mnt/hls/live/$1/thumbnail/$2/

/usr/local/bin/ffmpeg -i $1 -f image2 -s 180x135 /mnt/hls/live/$2/thumbnail/$now.jpeg
echo "/mnt/hls/live/$2/$now.jpeg written"