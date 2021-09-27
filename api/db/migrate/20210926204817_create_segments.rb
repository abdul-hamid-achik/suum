class CreateSegments < ActiveRecord::Migration[6.1]
  def change
    create_table :segments do |t|
      t.text :file_data
      t.integer :duration
      t.belongs_to :transmission, null: false, foreign_key: true
      t.datetime :timestamp
      t.string :filename

      t.timestamps
    end
  end
end
