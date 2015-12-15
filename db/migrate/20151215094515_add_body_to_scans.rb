class AddBodyToScans < ActiveRecord::Migration
  def change
    add_column :scans, :body, :text
  end
end
