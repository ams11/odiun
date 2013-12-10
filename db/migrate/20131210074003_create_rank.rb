class CreateRank < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :rank, :null => false
      t.decimal :videos_watched, :precision => 10, :scale => 4, :null => false
      t.decimal :original_selection, :precision => 10, :scale => 4, :null => false
      t.decimal :personal_content, :precision => 10, :scale => 4, :null => false
    end
  end
end
