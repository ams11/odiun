class RenameUserGenreScoreType < ActiveRecord::Migration
  def change
    rename_column :user_genre_scores, :type, :score_type
  end
end
