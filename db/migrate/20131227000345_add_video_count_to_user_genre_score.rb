class AddVideoCountToUserGenreScore < ActiveRecord::Migration
  def change
    add_column :user_genre_scores, :video_count, :integer
  end
end
