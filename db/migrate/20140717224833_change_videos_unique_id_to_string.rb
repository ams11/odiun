class ChangeVideosUniqueIdToString < ActiveRecord::Migration
  def change
    change_column :videos, :unique_id, :string
  end
end
