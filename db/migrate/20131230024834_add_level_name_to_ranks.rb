class AddLevelNameToRanks < ActiveRecord::Migration
  def change
    add_column :ranks, :name, :string
  end
end
