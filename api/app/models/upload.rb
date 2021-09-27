class Upload < ApplicationRecord
  include VideoUploader::Attachment(:video)

  validates_presence_of :video
end
