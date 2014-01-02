class AddPrimaryGenreScoreToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :primary_genre_id, :user_genre_score_id
  end
end
