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