class RemoveRankFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :rank
  end
end
