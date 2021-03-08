#!/bin/sh
set -e
cd /mnt/hls/live
now=$(/bin/date +%s)
filename=$now.jpeg

if [ -n "$2" ]; then
    mkdir -p $2
    cd $2
fi
echo $filename >> thumbnails.txt
ffmpeg -i $1 -f image2 -s 320x240 $filename

rm $1