class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name
    end

    add_column :videos, :genre_id, :integer
  end
end
