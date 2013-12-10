# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  rank_id                :integer
#

FactoryGirl.define do
  factory :user, :class => User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password "secret11"
    password_confirmation "secret11"
  end

  factory :admin_user, :parent => :user do
    roles { [Role.find_by_name('admin') || FactoryGirl.create(:role, :name => 'admin')] }
  end

  factory :voter_user, :parent => :user do
    roles { [Role.find_by_name('voter') || FactoryGirl.create(:role, :name => 'voter')] }
  end

end
