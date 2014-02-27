class AddScoreTypesToUserVotes < ActiveRecord::Migration
  def change
    remove_column :user_votes, :score
    add_column :user_votes, :score_emotion, :integer
    add_column :user_votes, :score_intellect, :integer
    add_column :user_votes, :score_entertain, :integer
  end
end
