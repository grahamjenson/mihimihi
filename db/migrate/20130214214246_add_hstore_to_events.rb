class AddHstoreToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lonlat, :hstore
  end
end
