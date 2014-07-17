class ChangeVideoProviderToString < ActiveRecord::Migration
  def change
    change_column :videos, :provider, :string
  end
end
