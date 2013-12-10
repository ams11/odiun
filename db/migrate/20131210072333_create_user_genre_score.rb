class CreateUserGenreScore < ActiveRecord::Migration
  def change
    create_table :user_genre_scores do |t|
      t.integer :user_id, :null => false
      t.integer :genre_id, :null => false
      t.decimal :score, :precision => 10, :scale => 4, :default => 0.0
      t.string :type, :null => false
    end
  end
end
