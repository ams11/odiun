# == Schema Information
#
# Table name: user_genre_scores
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  genre_id   :integer          not null
#  score      :decimal(10, 4)   default(0.0)
#  score_type :string(255)      not null
#

FactoryGirl.define do
  factory :user_genre_score, :class => UserGenreScore do
    user { FactoryGirl.create(:user) }
    genre { FactoryGirl.create(:genre) }
    score_type "watched"
    score 4.33
  end
end
