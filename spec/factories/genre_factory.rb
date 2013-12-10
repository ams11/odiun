# == Schema Information
#
# Table name: genres
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do
  factory :genre, :class => Genre do
    name "Comedy"
  end
end
