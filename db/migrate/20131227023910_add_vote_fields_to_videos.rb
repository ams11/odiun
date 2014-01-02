class AddVoteFieldsToVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :score, :decimal
    add_column :videos, :score_total, :integer, :default => 0
    add_column :videos, :max_score, :integer, :default => 0
  end
end
