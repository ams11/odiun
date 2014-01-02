FactoryGirl.define do
  factory :user_vote, :class => UserVote do
    user { FactoryGirl.create(:user) }
    video { FactoryGirl.create(:video) }
    score 47.33
  end
end