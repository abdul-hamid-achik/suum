class AddVideoDataToUploads < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :video_data, :text
  end
end
