namespace :odiun do
  desc "force an update of all the Video objects in the system"
  task :update_videos => :environment do
    fake_user = User.find_by_email("fake@example.com")
    fake_user = User.create(:email => "fake@example.com", :password => "secret11") if fake_user.nil?

    Video.find_each do |video|
      video.update_attribute(:user_id, fake_user.id) if video.user.nil?
      video.update_video! :url => video.url
    end
  end
end