#!/bin/sh
set -e

chown -R $USER:$USER /mnt/hls/live
chmod -R 700 /mnt/hls/live

exec nginx;