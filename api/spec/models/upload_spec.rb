require 'rails_helper'

describe Upload, type: :model do
  let(:mov) { Rails.root.join('spec/support/videos/nyc-drive-5av.mov') }
  let(:mp4) { Rails.root.join('spec/support/videos/aerial-view-of-the-old-roman-bridge-in-sarajevo-1.mp4') }
  let(:file) { File.open(mov) }
  let(:upload) do
    create :upload, title: 'nyc-drive-5av', video: file
  end

  it 'uploads video to s3 on create' do
    snapshot = { 'filename' => 'nyc-drive-5av.mov', 'mime_type' => 'video/quicktime', 'size' => 18_560_312 }
    expect(upload.video.metadata).to eq snapshot
  end

  it 'transform upload to mp4'
end
