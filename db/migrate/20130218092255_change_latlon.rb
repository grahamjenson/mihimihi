class ChangeLatlon < ActiveRecord::Migration
  def change
    remove_column :events, :lonlat
    add_column :events, :lonlat, :text
  end
end
