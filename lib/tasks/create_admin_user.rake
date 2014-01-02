namespace :odiun do
  desc "create an admin user in the db"
  task :create_admin_user => :environment do
    admin_user = User.find_by_email("admin@example.com")
    admin_user = User.create(:email => "admin@example.com", :password => "secret11") if admin_user.nil?
    admin_role = Role.find_by_name(:admin)
    admin_role = Role.create(:name => :admin) if admin_role.nil?
    unless admin_user.admin?
      admin_user.roles << admin_role
    end

    User.find_each do |user|
      user.set_defaults!
    end
  end
end