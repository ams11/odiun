# == Schema Information
#
# Table name: user_votes
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  video_id        :integer
#  score_emotion   :integer
#  score_intellect :integer
#  score_entertain :integer
#

FactoryGirl.define do
  factory :user_vote, :class => UserVote do
    user { FactoryGirl.create(:user) }
    video { FactoryGirl.create(:video) }
    score_emotion 58
    score_intellect 47
    score_entertain 99
  end
end
