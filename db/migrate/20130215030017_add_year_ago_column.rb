class AddYearAgoColumn < ActiveRecord::Migration
  def change
    add_column :events, :years_ago, :integer
    add_column :events, :over_time, :integer
  end
end
