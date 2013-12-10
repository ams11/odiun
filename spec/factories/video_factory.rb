# == Schema Information
#
# Table name: videos
#
#  id                  :integer          not null, primary key
#  url                 :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  name                :string(255)
#  provider            :integer
#  unique_id           :integer
#  visible             :boolean          default(FALSE)
#  thumbnail_url       :string(255)
#  user_id             :integer
#  featured            :boolean          default(FALSE)
#  large_thumbnail_url :string(255)
#  score               :decimal(10, 4)
#  genre_id            :integer
#

FactoryGirl.define do
  factory :video, :class => Video do
    user { FactoryGirl.create(:user) }
    url "http://www.youtube.com/embed/X3iFhLdWjqc?rel=0"
    name "Cats Playing Patty-cake, what they were saying..."
    description "This is hkbecky's video, Imagine what it would be if you could hear cats talking"
    thumbnail_url "http://i1.ytimg.com/vi/X3iFhLdWjqc/hqdefault.jpg"
    unique_id "X3iFhLdWjqc"
    provider "youtube"
  end
end
