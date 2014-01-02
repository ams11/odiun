class CreateUserVote < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.integer :user_id
      t.integer :video_id
      t.decimal :score
    end
  end
end
