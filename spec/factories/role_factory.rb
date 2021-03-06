# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string(255)
#

FactoryGirl.define do
  sequence(:role_sequence) { |n| "Role ##{n}" }

  factory :role, :class => Role do
    name { FactoryGirl.generate :role_sequence }
  end

  factory :admin_role, :parent => :role do
    name 'admin'
  end
end
