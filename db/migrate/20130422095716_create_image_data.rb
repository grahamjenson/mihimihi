class CreateImageData < ActiveRecord::Migration
  def change
    create_table :image_data do |t|
      t.string :link
      t.string :title
      t.string :image
      t.integer :years_ago

      t.timestamps
    end
  end
end
