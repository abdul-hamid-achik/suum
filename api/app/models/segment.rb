class Segment < ApplicationRecord
  include SegmentUploader::Attachment(:segment)

  belongs_to :transmission
end
