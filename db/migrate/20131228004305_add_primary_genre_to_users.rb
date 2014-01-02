class AddPrimaryGenreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_genre_id, :integer
  end
end
