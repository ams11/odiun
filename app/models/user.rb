class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :image,
                    :styles => { :medium => "200x200>",
                                 :small => "100x100>",
                                 :thumb => "40x40>" },
                    :default_style => :medium,
                    :default_url => '/images/missing.png',
                    :storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem),
                    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    :url => '/users/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/users/:id/:style/:basename.:extension'
end
