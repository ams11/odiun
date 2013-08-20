class AddFieldsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :name, :string
    add_column :videos, :provider, :integer
    add_column :videos, :unique_id, :integer
    add_column :videos, :visible, :boolean, :default => false
    add_column :videos, :thumbnail_url, :string
    add_column :videos, :user_id, :integer
  end
end
