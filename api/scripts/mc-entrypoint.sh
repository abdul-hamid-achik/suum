#!/bin/sh
export MINIO_ACCESS_KEY=${AWS_ACCESS_KEY_ID:-local_access};
export MINIO_SECRET_KEY=${AWS_SECRET_ACCESS_KEY:-local_access};

cd /usr/bin || exit;

mc config host rm local;
mc config host add --quiet local http://suum-minio:9000  $MINIO_ACCESS_KEY $MINIO_SECRET_KEY;
mc rb --force --quiet local/uploads/;
mc mb --quiet local/uploads/;
mc policy set public local/uploads;
