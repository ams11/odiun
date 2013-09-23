class AddScoreToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :score, :decimal, precision: 10, scale: 4, default: 0.0
  end
end
