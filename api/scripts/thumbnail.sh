#! /bin/sh
chown -R nginx:root /mnt/hls/live/thumbnail/
chmod -R 700 /mnt/hls/live/thumbnail/

now=$(/bin/date +%s)
mkdir -p /mnt/hls/live/thumbnail/$2/

/usr/local/bin/ffmpeg -i $1 -f image2 -s 180x135 /mnt/hls/live/$2/$now.jpeg
# rm $1
