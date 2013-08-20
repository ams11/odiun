FactoryGirl.define do
  factory :video, :class => Video do
    user FactoryGirl.create(:user)
    url "http://www.youtube.com/embed/X3iFhLdWjqc?rel=0"
    name "Cats Playing Patty-cake, what they were saying..."
    description "This is hkbecky's video, Imagine what it would be if you could hear cats talking"
    thumbnail_url "http://i1.ytimg.com/vi/X3iFhLdWjqc/hqdefault.jpg"
    unique_id "X3iFhLdWjqc"
    provider "youtube"
  end
end