class AddFilenameToScans < ActiveRecord::Migration
  def change
    add_column :scans, :filename, :string
  end
end
