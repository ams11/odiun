class AddVideoWatchedCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :videos_watched_count, :integer
  end
end
