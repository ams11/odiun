# == Schema Information
#
# Table name: ranks
#
#  id                 :integer          not null, primary key
#  rank               :integer          not null
#  videos_watched     :decimal(10, 4)   not null
#  original_selection :decimal(10, 4)   not null
#  personal_content   :decimal(10, 4)   not null
#

FactoryGirl.define do
  factory :rank, :class => Rank do
    rank 1
    videos_watched 50.0
    original_selection 20.0
    personal_content 30.0
  end
end
