class RemoveScoreDefault < ActiveRecord::Migration
  def change
    change_column :videos, :score, :decimal, :precision => 10, :scale => 4, :default => nil
  end
end
