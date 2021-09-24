require 'shrine'
require 'shrine/storage/s3'

config = {
  bucket: ENV['AWS_BUCKET'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION'],
  endpoint: ENV['AWS_ENDPOINT'],
  force_path_style: true
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **config),
  store: Shrine::Storage::S3.new(prefix: 'public', **config)
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
