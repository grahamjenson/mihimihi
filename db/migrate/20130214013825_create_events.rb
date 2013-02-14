class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.datetime :start_date
      t.datetime :end_date
      t.string :large_icon_url
      t.string :small_icon_url
      t.string :tiny_icon_url
      t.string :event_type
      t.timestamps
    end
  end
end
