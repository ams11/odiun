class AddLargeThumbnailToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :large_thumbnail_url, :string
  end
end
