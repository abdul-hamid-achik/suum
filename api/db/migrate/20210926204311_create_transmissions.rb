class CreateTransmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :transmissions do |t|
      t.string :title
      t.integer :views
      t.boolean :public?
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
