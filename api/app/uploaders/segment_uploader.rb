class SegmentUploader < Shrine
  plugin :validation_helpers
  Attacher.validate { validate_mime_type %w[video/mpegts] }
end
