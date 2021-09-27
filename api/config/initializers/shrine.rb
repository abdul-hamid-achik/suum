require 'shrine'
require 'shrine/storage/s3'

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :determine_mime_type
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :presign_endpoint, presign_options: lambda { |request|
  filename = request.params['filename']
  type     = request.params['type']

  {
    content_disposition: ContentDisposition.inline(filename), # set download filename
    content_type: type,
    content_length_range: 0..(100 * 1024 * 1024)
  }
}

options = {
  bucket: ENV.fetch('AWS_BUCKET') { 'suum' },
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID') do
                   '[AWS_ACCESS_KEY_ID]'
                 end,
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY') do
                       '[AWS_SECRET_ACCESS_KEY]'
                     end,
  region: ENV.fetch('AWS_REGION') { 'local' },
  endpoint: ENV.fetch('AWS_ENDPOINT') { 'http://localhost:9000' },
  force_path_style: true
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **options),
  store: Shrine::Storage::S3.new(**options)
}
